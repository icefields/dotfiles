require("luci_session")
require("luci_search")
local settings = require("settings")

settings.set_setting("session.always_save", true)
settings.set_setting("application.prefer_dark_mode", true)
settings.set_setting("window.close_with_last_tab", true)

-- --------- --
-- HARDENING --
-- --------- --
local fakeUserAgent = "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0"
local privacySettings = {
    -- UserAgent
    ["webview.user_agent"] = fakeUserAgent,
    -- Disable DNS prefetching (reduces tracking via speculative DNS)
    ["webview.enable_dns_prefetching"] = false,
    -- Disable hyperlink auditing (used for ping-based tracking)
    ["webview.enable_hyperlink_auditing"] = false,
    -- Disable WebGL (reduces fingerprinting surface)
    ["webview.enable_webgl"] = false,
    -- Disable media stream access
    ["webview.enable_media_stream"] = false,
    -- Disable WebAudio fingerprinting
    ["webview.enable_webaudio"] = false,
}

for key, value in pairs(privacySettings) do
    settings.set_setting(key, value)
end

-- EXAMPLE override for a specific site that needs a different UA
settings.set_setting("webview.user_agent",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36",
    { domain = "example.com" })

