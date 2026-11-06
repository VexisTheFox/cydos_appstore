# CYD OS App Store (`cydos_appstore`)

Official cloud application repository for **[CYD Android OS](https://github.com/VexisTheFox/android_cyd_os)** running on the ESP32 Cheap Yellow Display (`ESP32-2432S028`).

Contains **24 carefully engineered Lua 5.4 applications** organized across 4 categories (**Internet**, **Games**, **Media**, and **Utilities**), each with a custom `16x16` Base64 pixel-art icon (`-- @icon_b64`), custom launcher badge color (`-- @bg`), and display title (`-- @name`).

---

## Repository Directory Structure

```text
cydos_appstore/
├── catalog.json                 # Machine-readable store index (24 apps)
├── README.md                    # Documentation & Lua header format guide
└── apps/
    ├── internet/                # 6 Cloud REST API, Weather, Space & Network apps
    │   ├── weather.lua          # Multi-city live Open-Meteo weather station
    │   ├── nettools.lua         # TCP Ping, WAN IP & NTP test suite
    │   ├── crypto.lua           # Live BTC, ETH & SOL USD price ticker (CoinGecko API)
    │   ├── iss.lua              # Real-time International Space Station orbital radar
    │   ├── wifiradar.lua        # Live Wi-Fi RSSI signal graph & nearby AP scanner
    │   └── quotefetch.lua       # Cloud tech quotes fetcher & Flash bookmarker
    ├── games/                   # 6 Touch Arcade & Puzzle games
    │   ├── flappy.lua           # Flappy CYD (35 FPS arcade)
    │   ├── game2048.lua         # 2048 4x4 sliding tile puzzle
    │   ├── snake.lua            # CyberSnake classic grid game
    │   ├── breakout.lua         # BrickBreak touch-paddle Arkanoid arcade
    │   ├── mines.lua            # Minesweep 7x7 touch Minesweeper with Flag/Dig toggle
    │   └── memory.lua           # MemMatrix audio-visual sequence brain trainer
    ├── media/                   # 5 Audio, Light & Sensor studio apps
    │   ├── cybersynth.lua       # 8-key FM touch synthesizer with octave switching
    │   ├── drumseq.lua          # BeatBox 8 (4-track x 8-step touch drum machine)
    │   ├── rgbstudio.lua        # Onboard RGB LED (GPIO 4/16/17) & backlight controller
    │   ├── luxmeter.lua         # LuxScope real-time LDR light sensor oscilloscope
    │   └── metronome.lua        # Studio visual & audio BPM metronome
    └── utilities/               # 7 Clocks, Timers, Engineering & Security utilities
        ├── worldclock.lua       # Multi-timezone live NTP world clock
        ├── stopwatch.lua        # Precision 1/10s stopwatch with 5-lap history
        ├── pomodoro.lua         # 25m Focus / 5m Break productivity timer
        ├── unitconv.lua         # Engineering & everyday unit converter
        ├── resistor.lua         # 4-band electronic resistor color code calculator
        ├── notes.lua            # QuickNotes persistent Flash memo with QWERTY keyboard
        └── passgen.lua          # PassVault password & 4-digit PIN generator + vault
```

---

## Complete Catalog of 24 Store Applications

| Category | App Title | ID | Description | Raw OTA URL |
| :--- | :--- | :--- | :--- | :--- |
| **Internet** | **Weather** | `weather` | Open-Meteo live temp & wind | [`apps/internet/weather.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/internet/weather.lua) |
| **Internet** | **NetTools** | `nettools` | TCP Ping, WAN IP & NTP test | [`apps/internet/nettools.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/internet/nettools.lua) |
| **Internet** | **CryptoTick** | `crypto` | Live BTC, ETH & SOL USD prices | [`apps/internet/crypto.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/internet/crypto.lua) |
| **Internet** | **ISS Orbit** | `iss` | Live ISS space radar tracker | [`apps/internet/iss.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/internet/iss.lua) |
| **Internet** | **WiFi Radar** | `wifiradar` | Live RSSI graph & AP scanner | [`apps/internet/wifiradar.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/internet/wifiradar.lua) |
| **Internet** | **TechQuotes** | `quotefetch` | Cloud wisdom & Flash bookmark | [`apps/internet/quotefetch.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/internet/quotefetch.lua) |
| **Games** | **Flappy CYD** | `flappy` | Smooth 35 FPS arcade game | [`apps/games/flappy.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/games/flappy.lua) |
| **Games** | **2048 Game** | `game2048` | Classic 4x4 2048 tile puzzle | [`apps/games/game2048.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/games/game2048.lua) |
| **Games** | **CyberSnake** | `snake` | Classic grid arcade snake | [`apps/games/snake.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/games/snake.lua) |
| **Games** | **BrickBreak** | `breakout` | Touch paddle Arkanoid arcade | [`apps/games/breakout.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/games/breakout.lua) |
| **Games** | **Minesweep** | `mines` | 7x7 touch Minesweeper puzzle | [`apps/games/mines.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/games/mines.lua) |
| **Games** | **MemMatrix** | `memory` | Audio-visual memory trainer | [`apps/games/memory.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/games/memory.lua) |
| **Media** | **CyberSynth** | `cybersynth` | 8-key FM synthesizer & octaves | [`apps/media/cybersynth.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/media/cybersynth.lua) |
| **Media** | **BeatBox 8** | `drumseq` | 4-track x 8-step drum machine | [`apps/media/drumseq.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/media/drumseq.lua) |
| **Media** | **RGB Studio** | `rgbstudio` | RGB LED & backlight controller | [`apps/media/rgbstudio.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/media/rgbstudio.lua) |
| **Media** | **LuxScope** | `luxmeter` | LDR light sensor oscilloscope | [`apps/media/luxmeter.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/media/luxmeter.lua) |
| **Media** | **Metronome** | `metronome` | Studio BPM & time sig click | [`apps/media/metronome.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/media/metronome.lua) |
| **Utilities** | **WorldTime** | `worldclock` | Multi-timezone live NTP clock | [`apps/utilities/worldclock.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/utilities/worldclock.lua) |
| **Utilities** | **Stopwatch** | `stopwatch` | Precision 1/10s lap timer | [`apps/utilities/stopwatch.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/utilities/stopwatch.lua) |
| **Utilities** | **Pomodoro** | `pomodoro` | 25m focus / 5m break timer | [`apps/utilities/pomodoro.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/utilities/pomodoro.lua) |
| **Utilities** | **UnitConv** | `unitconv` | Engineering unit converter | [`apps/utilities/unitconv.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/utilities/unitconv.lua) |
| **Utilities** | **OhmCalc** | `resistor` | 4-band resistor color decoder | [`apps/utilities/resistor.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/utilities/resistor.lua) |
| **Utilities** | **QuickNotes** | `notes` | Persistent Flash QWERTY memo | [`apps/utilities/notes.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/utilities/notes.lua) |
| **Utilities** | **PassVault** | `passgen` | Password & PIN key generator | [`apps/utilities/passgen.lua`](https://raw.githubusercontent.com/VexisTheFox/cydos_appstore/main/apps/utilities/passgen.lua) |

---

## CYD OS Lua App Header Specification

Every `.lua` application in this store includes a 3-line metadata header at the top of the file so the CYD OS Home Screen and Play Store automatically render its custom name, badge color, and `16x16` Base64 icon:

```lua
-- @name: Weather
-- @bg: 0x0276
-- @icon_b64: A8AP8B/4P/x//n/+P/wAACIiREQAABEQIiAAAAAAAAA=
```
