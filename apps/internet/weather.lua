-- @name: Weather
-- @bg: 0x0276
-- @icon_b64: A8AP8B/4P/x//n/+P/wAACIiREQAABEQIiAAAAAAAAA=

local VP_X, VP_Y, VP_W, VP_H = 0, 20, 240, 274
local cities = {
    { name = "Prague",   lat = "50.08", lon = "14.43" },
    { name = "New York", lat = "40.71", lon = "-74.01" },
    { name = "London",   lat = "51.51", lon = "-0.13" },
    { name = "Tokyo",    lat = "35.68", lon = "139.69" },
    { name = "Berlin",   lat = "52.52", lon = "13.41" },
    { name = "Tirana",   lat = "41.33", lon = "19.82" }
}
local cityIdx = 1
local temp = "--.- C"
local wind = "-- km/h"
local status = "Tap FETCH LIVE for Open-Meteo"

local function drawUI()
    gui.fillRect(VP_X, VP_Y, VP_W, VP_H, 0x0821)
    gui.fillRect(VP_X, VP_Y, VP_W, 24, 0x0276)
    gui.drawFastHLine(VP_X, VP_Y + 24, VP_W, 0x07FF)
    gui.drawText(8, VP_Y + 8, "LIVE WEATHER STATION", 0xFFFF, 1)

    local c = cities[cityIdx]
    gui.fillRect(12, VP_Y + 32, 216, 28, 0x18E3)
    gui.drawRect(12, VP_Y + 32, 216, 28, 0x07FF)
    gui.drawText(20, VP_Y + 42, "< CITY: " .. c.name .. " (" .. c.lat .. "," .. c.lon .. ") >", 0xFFE0, 1)

    gui.fillRect(12, VP_Y + 68, 216, 92, 0x10A2)
    gui.drawRect(12, VP_Y + 68, 216, 92, 0x3186)
    gui.drawText(24, VP_Y + 80, "TEMPERATURE:", 0x9CD3, 1)
    gui.drawText(24, VP_Y + 96, temp, 0xFFE0, 4)
    gui.drawText(24, VP_Y + 132, "WIND SPEED: " .. wind, 0x07FF, 2)

    gui.fillRect(12, VP_Y + 168, 216, 36, 0x10A2)
    gui.drawRect(12, VP_Y + 168, 216, 36, 0x3186)
    gui.drawText(20, VP_Y + 174, "API Status:", 0x07E0, 1)
    gui.drawText(20, VP_Y + 188, string.sub(status, 1, 33), 0xFFFF, 1)

    gui.fillRect(20, VP_Y + 216, 200, 44, 0x04D3)
    gui.drawRect(20, VP_Y + 216, 200, 44, 0x07FF)
    gui.drawText(62, VP_Y + 234, "FETCH LIVE WEATHER", 0xFFFF, 1)
end

local function fetchWeather()
    local c = cities[cityIdx]
    status = "Querying api.open-meteo.com..."
    drawUI()
    local url = "https://api.open-meteo.com/v1/forecast?latitude=" .. c.lat .. "&longitude=" .. c.lon .. "&current_weather=true"
    local body, code, err = http.get(url)
    if body and code == 200 then
        local cw = string.match(body, '"current_weather"%s*:%s*(%b{})') or body
        local t = string.match(cw, '"temperature"%s*:%s*([%-0-9%.]+)')
        local w = string.match(cw, '"windspeed"%s*:%s*([%-0-9%.]+)')
        if t then temp = t .. " C" end
        if w then wind = w .. " km/h" end
        status = "HTTP 200 OK (" .. c.name .. ")"
    else
        status = "Err " .. tostring(code) .. ": " .. tostring(err or "No WiFi")
    end
    drawUI()
end

drawUI()
local wasT = false
while true do
    local tx, ty, pressed = input.getTouch()
    if pressed and not wasT then
        if ty >= VP_Y + 32 and ty <= VP_Y + 60 then
            sys.beep(1050, 20)
            cityIdx = (cityIdx % #cities) + 1
            drawUI()
        elseif ty >= VP_Y + 216 and ty <= VP_Y + 260 then
            sys.beep(1250, 25)
            fetchWeather()
        end
    end
    wasT = pressed
    sys.delay(25)
end
