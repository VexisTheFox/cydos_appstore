# CYD OS App Store (`cydos_appstore`)

Official cloud application repository for **[CYD Android OS](https://github.com/VexisTheFox/android_cyd_os)** running on the ESP32 Cheap Yellow Display (`ESP32-2432S028`).

All featured applications in the on-device **Play Store** are hosted here and organized by category.

---

## Repository Directory Structure

```text
cydos_appstore/
├── catalog.json                 # Machine-readable store index & metadata
├── README.md                    # Documentation & Lua header format guide
└── apps/
    ├── internet/                # REST API, Weather, and Network diagnostic apps
    │   ├── weather.lua          # Live Open-Meteo weather station
    │   └── nettools.lua         # TCP Ping, WAN IP & NTP test suite
    ├── games/                   # Touch arcade & puzzle games
    │   ├── flappy.lua           # Flappy CYD (35 FPS arcade)
    │   ├── game2048.lua         # 2048 4x4 puzzle game
    │   └── snake.lua            # CyberSnake classic grid game
    ├── media/                   # Audio & synthesizer apps
    │   └── cybersynth.lua       # 8-key FM touch synthesizer
    └── utilities/               # Clocks, timers, and productivity tools
        ├── worldclock.lua       # Multi-timezone live NTP world clock
        └── stopwatch.lua        # Precision lap stopwatch & timer
```

---

## Featured Applications by Category

| Category | App Title | ID | Description | Raw OTA URL |
| :--- | :--- | :--- | :--- | :--- |
| **Internet** | **Weather** | `weather` | Live temperature & wind via Open-Meteo HTTPS API | [`apps/internet/weather.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/internet/weather.lua) |
| **Internet** | **NetTools** | `nettools` | Cloudflare/Google DNS TCP ping, WAN IP & NTP sync | [`apps/internet/nettools.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/internet/nettools.lua) |
| **Games** | **Flappy CYD** | `flappy` | Smooth 35 FPS touch arcade game | [`apps/games/flappy.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/games/flappy.lua) |
| **Games** | **2048 Game** | `game2048` | Classic 4x4 sliding tile puzzle | [`apps/games/game2048.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/games/game2048.lua) |
| **Games** | **CyberSnake** | `snake` | Classic grid snake game with high-score tracking | [`apps/games/snake.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/games/snake.lua) |
| **Media** | **CyberSynth** | `cybersynth` | 8-key FM touch synthesizer with octave switching | [`apps/media/cybersynth.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/media/cybersynth.lua) |
| **Utilities** | **WorldTime** | `worldclock` | Multi-timezone live NTP clock (UTC, CET, EST, JST, AEST) | [`apps/utilities/worldclock.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/utilities/worldclock.lua) |
| **Utilities** | **Stopwatch** | `stopwatch` | Precision 1/10s stopwatch with 5-lap history | [`apps/utilities/stopwatch.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/utilities/stopwatch.lua) |

---

## CYD OS Lua App Header Specification

Every `.lua` application in this store includes a 3-line metadata header at the top of the file so the CYD OS Home Screen and Play Store automatically render its custom name, badge color, and 16x16 Base64 icon:

```lua
-- @name: Weather
-- @bg: 0x0276
-- @icon_b64: APDwAAw/wwAD//wAP/9VAAP1VVAPVVVUAVVVVQVVVVUFVVVVAVVVVAAAAAAAoKCgAoKCgAKCgoAAAAAAAAAAAA==
```

- `-- @name:` Display name shown on the CYD Home Screen (up to 16 characters).
- `-- @bg:` 16-bit RGB565 background color for the app icon tile.
- `-- @icon_b64:` Base64-encoded `16x16` icon bitmap (`32 bytes` 1-bit monochrome, `64 bytes` 2-bit 4-color palette, or `256 bytes` RGB332).
