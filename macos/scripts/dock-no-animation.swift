#!/usr/bin/env swift
// dock-no-animation.swift — set Dock autohide animation duration to zero (instant show/hide).
// Writes com.apple.dock autohide-time-modifier = 0 and restarts Dock.
// Usage: swift dock-no-animation.swift
//        chmod +x dock-no-animation.swift && ./dock-no-animation.swift

import CoreFoundation
import Foundation

let domain = "com.apple.dock" as CFString
let key = "autohide-time-modifier" as CFString

func currentModifier() -> Double? {
    guard let v = CFPreferencesCopyAppValue(key, domain) else { return nil }
    if let n = v as? NSNumber { return n.doubleValue }
    if let d = v as? Double { return d }
    return nil
}

func setModifier(_ value: Double) {
    CFPreferencesSetAppValue(key, NSNumber(value: value), domain)
    guard CFPreferencesAppSynchronize(domain) else {
        fputs("ERR: could not synchronize com.apple.dock preferences\n", stderr)
        exit(1)
    }
}

func restartDock() {
    let p = Process()
    p.executableURL = URL(fileURLWithPath: "/usr/bin/killall")
    p.arguments = ["Dock"]
    do {
        try p.run()
        p.waitUntilExit()
        if p.terminationStatus != 0 {
            fputs("WARN: killall Dock exited \(p.terminationStatus); log out/in if Dock did not reload\n", stderr)
        }
    } catch {
        fputs("ERR: failed to restart Dock: \(error.localizedDescription)\n", stderr)
        exit(1)
    }
}

var argv = Array(CommandLine.arguments.dropFirst())
if let h = argv.first, h == "-h" || h == "--help" || h == "help" {
    print("""
    dock-no-animation.swift — Dock autohide animation time → 0 (instant)

      Sets com.apple.dock autohide-time-modifier to 0 and restarts Dock.
      Most noticeable when Dock is set to “Automatically hide and show the Dock”
      in System Settings → Desktop & Dock.

      swift dock-no-animation.swift
      swift dock-no-animation.swift --show   # print current modifier only
    """)
    exit(0)
}

if argv.first == "--show" {
    if let c = currentModifier() {
        print("autohide-time-modifier = \(c)")
    } else {
        print("autohide-time-modifier = (not set — system default)")
    }
    exit(0)
}

if !argv.isEmpty {
    fputs("ERR: unknown argument(s): \(argv.joined(separator: " "))\n", stderr)
    fputs("Try: swift dock-no-animation.swift --help\n", stderr)
    exit(2)
}

let before = currentModifier()
setModifier(0)
fputs("OK: autohide-time-modifier set to 0", stderr)
if let b = before {
    fputs(" (was \(b))", stderr)
}
fputs("\n", stderr)
restartDock()
fputs("OK: Dock restarted\n", stderr)
