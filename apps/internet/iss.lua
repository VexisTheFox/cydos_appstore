-- @name: ISS Orbit
-- @bg: 0x1928
-- @icon_b64: 4AfgB+PH5+fud///7nfn5+PH4YfgB+AHA8AP8DgcAAA=

local VP_X, VP_Y, VP_W, VP_H = 0, 20, 240, 274
local lat, lon = 0.0, 0.0
local alt, vel = "418 km", "27580 km/h"
local status = "Tap TRACK ISS NOW"

local function drawUI()
    gui.fillRect(VP_X, VP_Y, VP_W, VP_H, 0x0821)
    gui.fillRect(VP_X, VP_Y, VP_W, 22, 0x1928)
    gui.drawFastHLine(VP_X, VP_Y + 22, VP_W, 0x07FF)
    gui.drawText(8, VP_Y + 7, "ISS ORBITAL TELEMETRY RADAR", 0xFFFF, 1)

    local mx, my, mw, mh = 12, VP_Y + 28, 216, 108
    gui.fillRect(mx, my, mw, mh, 0x0010)
    gui.drawRect(mx, my, mw, mh, 0x07FF)
    gui.drawFastHLine(mx, my + mh / 2, mw, 0x2104)
    gui.drawLine(mx + mw / 2, my, mx + mw / 2, my + mh, 0x2104)

    local px = mx + math.floor(((lon + 180) / 360) * mw)
    local py = my + math.floor(((90 - lat) / 180) * mh)
    if px < mx + 4 then px = mx + 4 elseif px > mx + mw - 4 then px = mx + mw - 4 end
    if py < my + 4 then py = my + 4 elseif py > my + mh - 4 then py = my + mh - 4 end
    gui.fillCircle(px, py, 4, 0xFFE0)
    gui.drawRect(px - 7, py - 7, 14, 14, 0xF800)

    gui.fillRect(12, VP_Y + 142, 216, 68, 0x10A2)
    gui.drawRect(12, VP_Y + 142, 216, 68, 0x3186)
    gui.drawText(18, VP_Y + 148, string.format("LAT: %.2f   LON: %.2f", lat, lon), 0x07FF, 1)
    gui.drawText(18, VP_Y + 166, "ALT: " .. alt .. " | VEL: " .. vel, 0x07E0, 1)
    gui.drawText(18, VP_Y + 186, string.sub(status, 1, 33), 0x9CD3, 1)

    gui.fillRect(20, VP_Y + 218, 200, 42, 0x04D3)
    gui.drawRect(20, VP_Y + 218, 200, 42, 0x07FF)
    gui.drawText(66, VP_Y + 235, "TRACK ISS ORBIT NOW", 0xFFFF, 1)
end

local function fetchISS()
    status = "Querying api.wheretheiss.at..."
    drawUI()
    local body, code, err = http.get("https://api.wheretheiss.at/v1/satellites/25544")
    if body and code == 200 then
        local la = string.match(body, '"latitude"%s*:%s*([%-0-9%.]+)')
        local lo = string.match(body, '"longitude"%s*:%s*([%-0-9%.]+)')
        local al = string.match(body, '"altitude"%s*:%s*([0-9%.]+)')
        local ve = string.match(body, '"velocity"%s*:%s*([0-9%.]+)')
        if la then lat = tonumber(la) or 0 end
        if lo then lon = tonumber(lo) or 0 end
        if al then alt = string.format("%.1f km", tonumber(al) or 418) end
        if ve then vel = string.format("%.0f km/h", tonumber(ve) or 27580) end
        status = "Live ISS lock acquired!"
    else
        status = "Err " .. tostring(code) .. ": " .. tostring(err or "No WiFi")
    end
    drawUI()
end

drawUI()
local wasT = false
while true do
    local tx, ty, pressed = input.getTouch()
    if pressed and not wasT and ty >= VP_Y + 216 then
        sys.beep(1400, 25)
        fetchISS()
    end
    wasT = pressed
    sys.delay(30)
end
