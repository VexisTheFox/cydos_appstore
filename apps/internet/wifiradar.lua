-- @name: WiFi Radar
-- @bg: 0x04D3
-- @icon_b64: D/A4HGAGh+EMMBAII8QGYAgQAYADwAPAAYAAAD/8AAA=

local VP_X, VP_Y, VP_W, VP_H = 0, 20, 240, 274
local hist = {}
for i = 1, 40 do hist[i] = -90 end
local apList = {}

local function drawChrome()
    gui.fillRect(VP_X, VP_Y, VP_W, VP_H, 0x0821)
    gui.fillRect(VP_X, VP_Y, VP_W, 22, 0x04D3)
    gui.drawFastHLine(VP_X, VP_Y + 22, VP_W, 0x07FF)
    gui.drawText(8, VP_Y + 7, "WIFI RSSI RADAR & SCANNER", 0xFFFF, 1)

    gui.fillRect(20, VP_Y + 222, 200, 40, 0x2C9F)
    gui.drawRect(20, VP_Y + 222, 200, 40, 0x07FF)
    gui.drawText(64, VP_Y + 238, "SCAN NEARBY APS", 0xFFFF, 1)
end

local function updateGraph()
    local rssi = wifi.getRSSI() or -95
    if rssi == 0 then rssi = -95 end
    table.remove(hist, 1)
    table.insert(hist, rssi)

    gui.fillRect(12, VP_Y + 28, 216, 40, 0x10A2)
    gui.drawRect(12, VP_Y + 28, 216, 40, 0x3186)
    gui.drawText(18, VP_Y + 34, "SSID: " .. wifi.getSSID() .. " (" .. rssi .. " dBm)", 0x07FF, 1)
    gui.drawText(18, VP_Y + 50, "IP: " .. wifi.getIP() .. " | MAC: " .. string.sub(wifi.getMac(), 10, 17), 0x9CD3, 1)

    local gx, gy, gw, gh = 12, VP_Y + 74, 216, 68
    gui.fillRect(gx, gy, gw, gh, 0x0000)
    gui.drawRect(gx, gy, gw, gh, 0x07E0)
    for i = 1, #hist do
        local v = hist[i]
        if v < -95 then v = -95 elseif v > -30 then v = -30 end
        local h = math.floor(((v + 95) / 65) * (gh - 8))
        local col = (v > -65) and 0x07E0 or ((v > -80) and 0xFFE0 or 0xF800)
        gui.fillRect(gx + 6 + (i - 1) * 5, gy + gh - 4 - h, 4, h, col)
    end

    gui.fillRect(12, VP_Y + 148, 216, 66, 0x10A2)
    gui.drawRect(12, VP_Y + 148, 216, 66, 0x3186)
    gui.drawText(18, VP_Y + 154, "NEARBY NETWORKS (" .. #apList .. "):", 0xFFE0, 1)
    for i = 1, math.min(3, #apList) do
        local ap = apList[i]
        gui.drawText(18, VP_Y + 168 + (i - 1) * 14,
            string.sub(ap.ssid or "?", 1, 18) .. " (" .. tostring(ap.rssi) .. " dBm)", 0xFFFF, 1)
    end
end

drawChrome()
local wasT = false
local tick = 0
while true do
    local tx, ty, pressed = input.getTouch()
    if pressed and not wasT and ty >= VP_Y + 220 then
        sys.beep(1200, 25)
        gui.drawText(64, VP_Y + 238, "SCANNING WIFI... ", 0xFFE0, 1)
        apList = wifi.scan() or {}
        drawChrome()
        updateGraph()
    end
    wasT = pressed
    tick = tick + 1
    if tick % 10 == 1 then updateGraph() end
    sys.delay(30)
end
