#!/usr/bin/env swift
// xdg.swift — macOS XDG-style home audit, Markdown report (prompts from xdg-prompts/*.mds), migrations via rsync.
// Usage: swift xdg.swift [audit|check|migrate] [options]
//        chmod +x xdg.swift && ./xdg.swift audit

import Foundation

// MARK: - Script / prompt paths

func scriptDirectory() -> URL {
    let arg0 = CommandLine.arguments[0]
    if arg0.hasSuffix(".swift") || arg0.contains("xdg.swift") {
        return URL(fileURLWithPath: arg0).standardizedFileURL.deletingLastPathComponent()
    }
    return URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
}

func promptsDirectory() -> URL {
    scriptDirectory().appendingPathComponent("xdg-prompts", isDirectory: true)
}

func loadMds(_ name: String) throws -> String {
    let url = promptsDirectory().appendingPathComponent(name)
    guard FileManager.default.fileExists(atPath: url.path) else {
        throw NSError(domain: "xdg", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing prompt file: \(url.path)"])
    }
    return try String(contentsOf: url, encoding: .utf8)
}

// MARK: - Environment

struct XDGEnv {
    let home: URL
    let config: URL
    let cache: URL
    let data: URL
    let state: URL

    let bunSrc: URL
    let bunDst: URL
    let bunCacheDst: URL
    let lmSrc: URL
    let lmDst: URL
    let cursorSrc: URL
    let cursorDst: URL
    let npmSrc: URL
    let npmDst: URL
    let dockerSrc: URL
    let dockerDst: URL
    let snippetOut: URL

    init() {
        let h = FileManager.default.homeDirectoryForCurrentUser
        func envDir(_ key: String, _ def: String) -> URL {
            if let v = ProcessInfo.processInfo.environment[key], !v.isEmpty {
                return URL(fileURLWithPath: (v as NSString).expandingTildeInPath).standardizedFileURL
            }
            return h.appendingPathComponent(def)
        }
        home = h
        config = envDir("XDG_CONFIG_HOME", ".config")
        cache = envDir("XDG_CACHE_HOME", ".cache")
        data = envDir("XDG_DATA_HOME", ".local/share")
        state = envDir("XDG_STATE_HOME", ".local/state")

        bunSrc = home.appendingPathComponent(".bun")
        bunDst = config.appendingPathComponent("bun")
        bunCacheDst = bunDst.appendingPathComponent("install/cache")
        lmSrc = home.appendingPathComponent(".lmstudio")
        lmDst = config.appendingPathComponent("lm-studio")
        cursorSrc = home.appendingPathComponent(".cursor")
        cursorDst = config.appendingPathComponent("cursor")
        npmSrc = home.appendingPathComponent(".npm")
        npmDst = cache.appendingPathComponent("npm")
        dockerSrc = home.appendingPathComponent(".docker")
        dockerDst = config.appendingPathComponent("docker")
        snippetOut = config.appendingPathComponent("xdg-env-macos.sh")
    }
}

// MARK: - Classification

private let conventionTooling: Set<String> = [
    ".vscode", ".ipython", ".jupyter", ".matplotlib", ".keras", ".aws", ".azure", ".bundle", ".gradle", ".m2",
    ".swiftpm", ".cocoapods", ".conda", ".dotnet", ".nuget", ".templateengine", ".aspnet", ".mono", ".android",
    ".skiko", ".pyenv", ".rbenv", ".nvm", ".oh-my-zsh", ".gem", ".redhat", ".parallel", ".parallelcache", ".dotnet_tools",
]

enum DotKind: String {
    case skip
    case xdgRoot = "xdg_root"
    case exemptSsh = "exempt_ssh"
    case exemptMacos = "exempt_macos"
    case conventionShell = "convention_shell"
    case conventionHistory = "convention_history"
    case conventionGit = "convention_git"
    case conventionNode = "convention_node"
    case conventionZshCache = "convention_zsh_cache"
    case conventionEditor = "convention_editor"
    case conventionTooling = "convention_tooling"
    case relocatableCore = "relocatable_core"
    case relocatableExtended = "relocatable_extended"
    case unknown
}

func classify(name: String) -> DotKind {
    switch name {
    case ".", "..": return .skip
    case ".config", ".cache", ".local": return .xdgRoot
    case ".ssh": return .exemptSsh
    case ".Trash", ".DS_Store", ".CFUserTextEncoding", ".localized": return .exemptMacos
    case ".zshrc", ".zshenv", ".zprofile", ".zlogin", ".bashrc", ".bash_profile", ".profile", ".bash_history",
         ".zsh_history", ".xonshrc", ".inputrc", ".editrc", ".hushlogin":
        return .conventionShell
    case ".viminfo", ".lesshst", ".wget-hsts", ".python_history": return .conventionHistory
    case ".gitconfig", ".gitignore_global": return .conventionGit
    case ".npmrc", ".yarnrc", ".yarnrc.yml", ".node_repl_history": return .conventionNode
    case ".vim", ".emacs.d", ".tmux.conf", ".tmux": return .conventionEditor
    case ".bun", ".npm", ".docker", ".cursor", ".lmstudio": return .relocatableCore
    case ".cargo", ".rustup", ".kube", ".steam": return .relocatableExtended
    default:
        if name.hasPrefix(".zcompdump") { return .conventionZshCache }
        if conventionTooling.contains(name) { return .conventionTooling }
        return .unknown
    }
}

func coreViolation(name: String, env: XDGEnv) -> Bool {
    switch name {
    case ".bun": return FileManager.default.fileExists(atPath: env.bunSrc.path)
    case ".lmstudio": return FileManager.default.fileExists(atPath: env.lmSrc.path)
    case ".cursor": return FileManager.default.fileExists(atPath: env.cursorSrc.path)
    case ".npm": return FileManager.default.fileExists(atPath: env.npmSrc.path)
    case ".docker": return FileManager.default.fileExists(atPath: env.dockerSrc.path)
    default: return false
    }
}

func extendedPresent(name: String, env: XDGEnv) -> Bool {
    switch name {
    case ".cargo", ".rustup", ".kube", ".steam":
        return FileManager.default.fileExists(atPath: env.home.appendingPathComponent(name).path)
    default: return false
    }
}

// MARK: - rsync

func whichRsync() -> String? {
    let paths = ["/usr/bin/rsync", "/opt/homebrew/bin/rsync"]
    for p in paths where FileManager.default.isExecutableFile(atPath: p) { return p }
    return nil
}

@discardableResult
func runRsync(_ rsync: String, _ args: [String]) throws -> String {
    let p = Process()
    p.executableURL = URL(fileURLWithPath: rsync)
    p.arguments = args
    let out = Pipe()
    let err = Pipe()
    p.standardOutput = out
    p.standardError = err
    try p.run()
    p.waitUntilExit()
    guard p.terminationStatus == 0 else {
        let ed = err.fileHandleForReading.readDataToEndOfFile()
        let es = String(data: ed, encoding: .utf8) ?? ""
        throw NSError(domain: "xdg", code: Int(p.terminationStatus), userInfo: [NSLocalizedDescriptionKey: "rsync failed: \(es)"])
    }
    let d = out.fileHandleForReading.readDataToEndOfFile()
    return String(data: d, encoding: .utf8) ?? ""
}

func verifyTree(rsync: String, src: URL, dst: URL) throws -> Bool {
    guard FileManager.default.fileExists(atPath: src.path) else { return true }
    guard FileManager.default.fileExists(atPath: dst.path) else { return false }
    let o = try runRsync(rsync, ["-rn", "--checksum", src.path + "/", dst.path + "/"])
    return o.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
}

func copyTree(rsync: String, src: URL, dst: URL) throws {
    guard FileManager.default.fileExists(atPath: src.path) else { return }
    try FileManager.default.createDirectory(at: dst, withIntermediateDirectories: true)
    _ = try runRsync(rsync, ["-a", src.path + "/", dst.path + "/"])
}

// MARK: - Audit

struct AuditResult {
    var total = 0
    var exempt = 0
    var xdgRoot = 0
    var convention = 0
    var viol = 0
    var unknown = 0
    var extn = 0
    var violNames: [String] = []
    var unknownNames: [String] = []
    var extNames: [String] = []
    var inventory: [(String, DotKind)] = []
}

func runAudit(env: XDGEnv) throws -> AuditResult {
    var r = AuditResult()
    let fm = FileManager.default
    let items = try fm.contentsOfDirectory(at: env.home, includingPropertiesForKeys: nil)
    var names = items.map { $0.lastPathComponent }.filter { $0.hasPrefix(".") && $0 != "." }
    names.sort()

    for b in names {
        let k = classify(name: b)
        if k == .skip { continue }
        r.total += 1
        r.inventory.append((b, k))
        switch k {
        case .xdgRoot:
            r.xdgRoot += 1
            r.exempt += 1
        case .exemptSsh, .exemptMacos:
            r.exempt += 1
        case .conventionShell, .conventionHistory, .conventionGit, .conventionNode, .conventionZshCache,
             .conventionEditor, .conventionTooling:
            r.convention += 1
            r.exempt += 1
        case .relocatableCore:
            if coreViolation(name: b, env: env) {
                r.viol += 1
                r.violNames.append(b)
            } else {
                r.exempt += 1
            }
        case .relocatableExtended:
            if extendedPresent(name: b, env: env) {
                r.extn += 1
                r.extNames.append(b)
            }
        case .unknown:
            r.unknown += 1
            r.unknownNames.append(b)
        case .skip:
            break
        }
    }

    return r
}

func score(for r: AuditResult) -> Int {
    guard r.total > 0 else { return 100 }
    var s = (100 * r.exempt) / r.total
    s -= 12 * r.viol
    return max(0, s)
}

func buildReport(env: XDGEnv, r: AuditResult, score: Int) throws -> String {
    let agent = try loadMds("agent-maintenance.mds")
    let strategies = try loadMds("strategies.mds")
    let iso = ISO8601DateFormatter().string(from: Date()).replacingOccurrences(of: "+00:00", with: "Z")

    var md = ""
    md += "# XDG-style home compliance (macOS)\n\n"
    md += "**Score: \(score)/100** — exempt coverage (− **12 ×** core relocatables still under `$HOME`: .bun / .lmstudio / .cursor / .npm / .docker). Extended and unknown rows are informational; extend `classify(name:)` in `xdg.swift` or prompts in `xdg-prompts/`.\n\n"
    md += "_Generated: \(iso) · Tool: `xdg.swift`_\n\n"
    md += agent + "\n\n"
    md += "## Summary\n\n| Metric | Count |\n|--------|-------|\n"
    md += "| Dot entries (depth 1) | \(r.total) |\n"
    md += "| Compliant / exempt | \(r.exempt) |\n"
    md += "| — XDG roots (.config / .cache / .local) | \(r.xdgRoot) |\n"
    md += "| — Conventions (shell, editors, …) | \(r.convention) |\n"
    md += "| **Core relocatable violations** | **\(r.viol)** |\n"
    md += "| Extended relocatables (.cargo, …) | \(r.extn) |\n"
    md += "| Unknown / review | \(r.unknown) |\n\n"

    md += "## Core relocatable violations (migrate targets)\n\n"
    if r.violNames.isEmpty {
        md += "_None — no core relocatable dirs left at `$HOME` (or already merged)._\n\n"
    } else {
        md += "| Path | Action |\n|------|--------|\n"
        for n in r.violNames {
            switch n {
            case ".bun": md += "| `\(env.bunSrc.path)` | `swift xdg.swift migrate --apply` → `\(env.bunDst.path)` |\n"
            case ".lmstudio": md += "| `\(env.lmSrc.path)` | `swift xdg.swift migrate --apply` → `\(env.lmDst.path)` |\n"
            case ".cursor": md += "| `\(env.cursorSrc.path)` | Quit Cursor; `swift xdg.swift migrate --apply` |\n"
            case ".npm": md += "| `\(env.npmSrc.path)` | `swift xdg.swift migrate --apply --with-npm` |\n"
            case ".docker": md += "| `\(env.dockerSrc.path)` | `swift xdg.swift migrate --apply --with-docker` |\n"
            default: md += "| `\(env.home.path)/\(n)` | Extend `xdg.swift` migrate + `strategies.mds` |\n"
            }
        }
        md += "\n"
    }

    md += "## Extended relocatables (strategy only)\n\n"
    if r.extNames.isEmpty {
        md += "_None detected._\n\n"
    } else {
        md += "| Path | Note |\n|------|------|\n"
        for n in r.extNames {
            md += "| `\(env.home.path)/\(n)` | Set `CARGO_HOME` / `RUSTUP_HOME` / `KUBECONFIG`; add migrate to `xdg.swift` when ready. |\n"
        }
        md += "\n"
    }

    md += "## Unknown / review\n\n"
    if r.unknownNames.isEmpty {
        md += "_None._\n\n"
    } else {
        md += "| Path | Note |\n|------|------|\n"
        for n in r.unknownNames {
            md += "| `\(env.home.path)/\(n)` | Add to `classify(name:)` in `xdg.swift` or document exempt. |\n"
        }
        md += "\n"
    }

    md += "## Full inventory (depth 1)\n\n| Name | Classification |\n|------|----------------|\n"
    for (b, k) in r.inventory.sorted(by: { $0.0 < $1.0 }) {
        md += "| `\(b)` | \(k.rawValue) |\n"
    }
    md += "\n## Strategies (reference)\n\n"
    md += strategies + "\n\n"
    md += "## Environment snapshot\n\n```\n"
    md += "XDG_CONFIG_HOME=\(env.config.path)\n"
    md += "XDG_CACHE_HOME=\(env.cache.path)\n"
    md += "XDG_DATA_HOME=\(env.data.path)\n"
    md += "XDG_STATE_HOME=\(env.state.path)\n```\n"
    return md
}

// MARK: - Migrate / snippet

func emitSnippet(env: XDGEnv) throws {
    try FileManager.default.createDirectory(at: env.config, withIntermediateDirectories: true)
    var lines: [String] = []
    lines.append("# Generated by xdg.swift — source from ~/.zprofile or ~/.zshenv")
    lines.append("export XDG_CONFIG_HOME=\"\(env.config.path)\"")
    lines.append("export XDG_CACHE_HOME=\"\(env.cache.path)\"")
    lines.append("export XDG_DATA_HOME=\"\(env.data.path)\"")
    lines.append("export XDG_STATE_HOME=\"\(env.state.path)\"")
    lines.append("export BUN_INSTALL=\"\(env.bunDst.path)\"")
    lines.append("export BUN_INSTALL_CACHE_DIR=\"\(env.bunCacheDst.path)\"")
    lines.append("export LM_STUDIO_HOME=\"\(env.lmDst.path)\"")
    lines.append("export LM_STUDIO_MODELS_DIR=\"${LM_STUDIO_MODELS_DIR:-$HOME/Desktop/LMStudio-Models}\"")
    lines.append("export CURSOR_CONFIG_DIR=\"\(env.cursorDst.path)\"")
    lines.append("export DOCKER_CONFIG=\"\(env.dockerDst.path)\"")
    lines.append("export PATH=\"${BUN_INSTALL}/bin:${LM_STUDIO_HOME}/bin:${PATH}\"")
    lines.append("")
    try lines.joined(separator: "\n").write(to: env.snippetOut, atomically: true, encoding: .utf8)
    fputs("OK: wrote \(env.snippetOut.path)\n", stderr)
}

func migrateOne(env: XDGEnv, rsync: String, name: String, src: URL, dst: URL, dry: Bool) throws {
    guard FileManager.default.fileExists(atPath: src.path) else { return }
    var isDir: ObjCBool = false
    guard FileManager.default.fileExists(atPath: src.path, isDirectory: &isDir), isDir.boolValue else { return }
    if dry {
        print("[dry-run] \(name): rsync \(src.path)/ -> \(dst.path)/ ; verify ; rm -rf \(src.path)")
        return
    }
    try FileManager.default.createDirectory(at: env.config, withIntermediateDirectories: true)
    try FileManager.default.createDirectory(at: env.bunCacheDst, withIntermediateDirectories: true)
    try FileManager.default.createDirectory(at: dst, withIntermediateDirectories: true)
    print("Merging \(name): \(src.path) -> \(dst.path)")
    try copyTree(rsync: rsync, src: src, dst: dst)
    guard try verifyTree(rsync: rsync, src: src, dst: dst) else {
        fputs("ERR: \(name): verify failed — not removing \(src.path)\n", stderr)
        exit(1)
    }
    try FileManager.default.removeItem(at: src)
    fputs("OK: \(name): removed \(src.path)\n", stderr)
}

func reportPair(label: String, src: URL, dst: URL) {
    let fm = FileManager.default
    if fm.fileExists(atPath: src.path) {
        if fm.fileExists(atPath: dst.path) {
            fputs("WARN: \(label): \(src.path) and \(dst.path) both exist — migrate merges then removes source if verify passes.\n", stderr)
        } else {
            fputs("OK: \(label): would migrate \(src.path) -> \(dst.path)\n", stderr)
        }
    } else {
        fputs("  \(label): (no \(src.path))\n", stderr)
    }
}

func cmdCheck(env: XDGEnv) throws {
    fputs("XDG_CONFIG_HOME=\(env.config.path)\n", stderr)
    fputs("XDG_CACHE_HOME=\(env.cache.path)\n", stderr)
    fputs("XDG_DATA_HOME=\(env.data.path)\n", stderr)
    fputs("XDG_STATE_HOME=\(env.state.path)\n\n", stderr)
    reportPair(label: "Bun", src: env.bunSrc, dst: env.bunDst)
    reportPair(label: "LM Studio", src: env.lmSrc, dst: env.lmDst)
    reportPair(label: "Cursor", src: env.cursorSrc, dst: env.cursorDst)
    fputs("\n", stderr)
    guard let rsync = whichRsync() else {
        fputs("WARN: rsync not found; skipping checksum compare\n", stderr)
        return
    }
    if fmDir(env.bunSrc), fmDir(env.bunDst) {
        if try verifyTree(rsync: rsync, src: env.bunSrc, dst: env.bunDst) {
            fputs("OK: Bun trees match\n", stderr)
        } else {
            fputs("WARN: Bun trees differ\n", stderr)
        }
    }
    if fmDir(env.lmSrc), fmDir(env.lmDst) {
        if try verifyTree(rsync: rsync, src: env.lmSrc, dst: env.lmDst) {
            fputs("OK: LM Studio trees match\n", stderr)
        } else {
            fputs("WARN: LM Studio trees differ\n", stderr)
        }
    }
}

func fmDir(_ u: URL) -> Bool {
    var b: ObjCBool = false
    return FileManager.default.fileExists(atPath: u.path, isDirectory: &b) && b.boolValue
}

func cmdAudit(env: XDGEnv, args: ArraySlice<String>) throws {
    var toStdout = false
    var outPath = ProcessInfo.processInfo.environment["XDG_AUDIT_OUT"].flatMap { URL(fileURLWithPath: ($0 as NSString).expandingTildeInPath) }
        ?? env.state.appendingPathComponent("xdg-compliance-report.md")
    let rest = Array(args)
    var i = 0
    while i < rest.count {
        switch rest[i] {
        case "--stdout": toStdout = true
        case "--out":
            guard i + 1 < rest.count else { throw NSError(domain: "xdg", code: 2, userInfo: [NSLocalizedDescriptionKey: "--out needs path"]) }
            i += 1
            outPath = URL(fileURLWithPath: (rest[i] as NSString).expandingTildeInPath)
        default: throw NSError(domain: "xdg", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unknown flag: \(rest[i])"])
        }
        i += 1
    }
    try FileManager.default.createDirectory(at: env.state, withIntermediateDirectories: true)
    let r = try runAudit(env: env)
    let sc = score(for: r)
    let md = try buildReport(env: env, r: r, score: sc)
    if toStdout {
        print(md)
    } else {
        try FileManager.default.createDirectory(at: outPath.deletingLastPathComponent(), withIntermediateDirectories: true)
        try md.write(to: outPath, atomically: true, encoding: .utf8)
        fputs("OK: wrote \(outPath.path)\n", stderr)
        fputs("Score: \(sc)/100\n", stderr)
    }
}

func cmdMigrate(env: XDGEnv, args: ArraySlice<String>) throws {
    guard let rsync = whichRsync() else {
        fputs("ERR: rsync not found\n", stderr)
        exit(1)
    }
    var dry = true
    var apply = false
    var yes = false
    var withNpm = false
    var withDocker = false
    for a in args {
        switch a {
        case "--apply": apply = true; dry = false
        case "--yes": yes = true
        case "--with-npm": withNpm = true
        case "--with-docker": withDocker = true
        default:
            fputs("ERR: Unknown: \(a)\n", stderr)
            exit(2)
        }
    }
    try cmdCheck(env: env)
    if apply && !yes {
        print("Removes ~/.bun, ~/.lmstudio, ~/.cursor (etc.) only after checksum verify. Type YES:")
        guard readLine(strippingNewline: true) == "YES" else {
            fputs("Aborted.\n", stderr)
            exit(1)
        }
    }
    if apply {
        try FileManager.default.createDirectory(at: env.config, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: env.bunCacheDst, withIntermediateDirectories: true)
    }
    try migrateOne(env: env, rsync: rsync, name: "Bun", src: env.bunSrc, dst: env.bunDst, dry: dry)
    try migrateOne(env: env, rsync: rsync, name: "LM Studio", src: env.lmSrc, dst: env.lmDst, dry: dry)
    try migrateOne(env: env, rsync: rsync, name: "Cursor", src: env.cursorSrc, dst: env.cursorDst, dry: dry)
    if withNpm {
        if dry {
            print("[dry-run] npm: \(env.npmSrc.path) -> \(env.npmDst.path)")
        } else if fmDir(env.npmSrc) {
            try FileManager.default.createDirectory(at: env.npmDst, withIntermediateDirectories: true)
            try copyTree(rsync: rsync, src: env.npmSrc, dst: env.npmDst)
            guard try verifyTree(rsync: rsync, src: env.npmSrc, dst: env.npmDst) else {
                fputs("ERR: npm verify failed\n", stderr)
                exit(1)
            }
            try FileManager.default.removeItem(at: env.npmSrc)
            fputs("OK: npm migrated\n", stderr)
        }
    }
    if withDocker {
        try migrateOne(env: env, rsync: rsync, name: "Docker", src: env.dockerSrc, dst: env.dockerDst, dry: dry)
    }
    if dry {
        print("Dry-run. Run: swift xdg.swift migrate --apply --yes")
        return
    }
    try emitSnippet(env: env)
    fputs("Done. Re-run: swift xdg.swift audit\n", stderr)
}

// MARK: - Entry

do {
    let env = XDGEnv()
    var argv = Array(CommandLine.arguments.dropFirst())
    if let h = argv.first, h == "-h" || h == "--help" || h == "help" {
        print("""
        xdg.swift — XDG home audit + migrate (prompts: xdg-prompts/*.mds)

          swift xdg.swift [audit] [--stdout] [--out PATH]
          swift xdg.swift check
          swift xdg.swift migrate [--apply] [--yes] [--with-npm] [--with-docker]

        Run from macos/scripts (or pass full path). Env: XDG_AUDIT_OUT, XDG_* .
        """)
        exit(0)
    }
    let cmd: String
    if let first = argv.first, ["audit", "check", "migrate"].contains(first) {
        cmd = first
        argv.removeFirst()
    } else {
        cmd = "audit"
    }
    switch cmd {
    case "audit":
        try cmdAudit(env: env, args: ArraySlice(argv))
    case "check":
        try cmdCheck(env: env)
    case "migrate":
        try cmdMigrate(env: env, args: ArraySlice(argv))
    default:
        fputs("Usage: swift xdg.swift audit|check|migrate ...\n", stderr)
        exit(2)
    }
} catch {
    fputs("ERR: \(error.localizedDescription)\n", stderr)
    exit(1)
}

