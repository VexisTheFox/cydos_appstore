-- @name: Stopwatch
-- @bg: 0x6010
-- @icon_b64: B+ABgDfsf/5wDsGDwYPBg8HjwAPAA3AOf/4f+AfgAAA=

local VP_X, VP_Y, VP_W, VP_H = 0, 20, 240, 274
local running = false
local startMs = 0
local elapsedMs = 0
local laps = {}

local function fmtMs(ms)
    local totalSec = math.floor(ms / 1000)
    local mins = math.floor(totalSec / 60)
    local secs = totalSec % 60
    local tenths = math.floor((ms % 1000) / 100)
    return string.format("%02d:%02d.%d", mins, secs, tenths)
end

local function drawChrome()
    gui.fillRect(VP_X, VP_Y, VP_W, VP_H, 0x0821)
    gui.fillRect(VP_X, VP_Y, VP_W, 24, 0x6010)
    gui.drawFastHLine(VP_X, VP_Y + 24, VP_W, 0x07FF)
    gui.drawText(8, VP_Y + 8, "PRECISION STOPWATCH & LAPS", 0xFFFF, 1)

    gui.fillRect(14, VP_Y + 34, 212, 68, 0x10A2)
    gui.drawRect(14, VP_Y + 34, 212, 68, 0x07FF)

    gui.fillRect(14, VP_Y + 110, 212, 98, 0x10A2)
    gui.drawRect(14, VP_Y + 110, 212, 98, 0x3186)
    gui.drawText(22, VP_Y + 116, "LAP HISTORY:", 0x9CD3, 1)
    for i = 1, #laps do
        gui.drawText(22, VP_Y + 128 + (i - 1) * 15, "Lap " .. i .. ": " .. laps[i], 0xFFFF, 1)
    end

    gui.fillRect(14, VP_Y + 218, 100, 42, running and 0x7800 or 0x04D3)
    gui.drawRect(14, VP_Y + 218, 100, 42, 0xFFFF)
    gui.drawText(34, VP_Y + 235, running and "STOP" or "START", 0xFFFF, 1)

    gui.fillRect(126, VP_Y + 218, 100, 42, 0x2C9F)
    gui.drawRect(126, VP_Y + 218, 100, 42, 0x07FF)
    gui.drawText(146, VP_Y + 235, running and "LAP" or "RESET", 0xFFFF, 1)
end

local function drawTimer(ms)
    gui.fillRect(24, VP_Y + 48, 192, 40, 0x10A2)
    gui.drawText(48, VP_Y + 54, fmtMs(ms), 0xFFE0, 4)
end

drawChrome()
drawTimer(0)

local wasT = false
while true do
    local now = sys.getUptime()
    local cur = running and (elapsedMs + (now - startMs)) or elapsedMs
    drawTimer(cur)

    local tx, ty, pressed = input.getTouch()
    if pressed and not wasT and ty >= VP_Y + 218 and ty <= VP_Y + 262 then
        sys.beep(1150, 20)
        if tx < 120 then
            if running then
                elapsedMs = elapsedMs + (now - startMs)
                running = false
            else
                startMs = now
                running = true
            end
            drawChrome()
            drawTimer(cur)
        else
            if running then
                table.insert(laps, 1, fmtMs(cur))
                if #laps > 5 then table.remove(laps) end
            else
                elapsedMs = 0
                laps = {}
            end
            drawChrome()
            drawTimer(running and cur or 0)
        end
    end
    wasT = pressed
    sys.delay(45)
end
