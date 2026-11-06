-- @name: Pomodoro
-- @bg: 0x9000
-- @icon_b64: DbAH4B/4P/x//n5+/n/+f/7//39//n/+P/wf+AfgAAA=

local VP_X, VP_Y, VP_W, VP_H = 0, 20, 240, 274
local isWork = true
local totalSec = 25 * 60
local remSec = totalSec
local running = false
local sessions = 0

local function drawChrome()
    gui.fillRect(VP_X, VP_Y, VP_W, VP_H, 0x0821)
    gui.fillRect(VP_X, VP_Y, VP_W, 24, isWork and 0x9000 or 0x03E0)
    gui.drawText(8, VP_Y + 8, isWork and "POMODORO [25M FOCUS]" or "POMODORO [5M BREAK]", 0xFFFF, 1)

    gui.fillRect(14, VP_Y + 36, 212, 110, 0x10A2)
    gui.drawRect(14, VP_Y + 36, 212, 110, isWork and 0xF800 or 0x07E0)
    gui.drawText(24, VP_Y + 46, "Completed Sessions: " .. sessions, 0x9CD3, 1)

    gui.fillRect(14, VP_Y + 158, 212, 42, 0x18E3)
    gui.drawRect(14, VP_Y + 158, 212, 42, 0x07FF)
    gui.drawText(48, VP_Y + 174, "SWITCH WORK / BREAK", 0xFFE0, 1)

    gui.fillRect(14, VP_Y + 212, 102, 44, running and 0x7800 or 0x04D3)
    gui.drawRect(14, VP_Y + 212, 102, 44, 0xFFFF)
    gui.drawText(34, VP_Y + 230, running and "PAUSE" or "START", 0xFFFF, 1)

    gui.fillRect(124, VP_Y + 212, 102, 44, 0x2C9F)
    gui.drawRect(124, VP_Y + 212, 102, 44, 0x07FF)
    gui.drawText(152, VP_Y + 230, "RESET", 0xFFFF, 1)
end

local function drawClock()
    local m = math.floor(remSec / 60)
    local s = remSec % 60
    gui.fillRect(24, VP_Y + 68, 192, 38, 0x10A2)
    gui.drawText(64, VP_Y + 74, string.format("%02d:%02d", m, s), 0xFFE0, 4)

    local pw = math.floor(((totalSec - remSec) / totalSec) * 188)
    gui.fillRect(26, VP_Y + 118, 188, 14, 0x0821)
    gui.fillRect(26, VP_Y + 118, pw, 14, isWork and 0xF800 or 0x07E0)
end

drawChrome()
drawClock()

local lastTick = sys.getUptime()
local wasT = false

while true do
    local tx, ty, pressed = input.getTouch()
    if pressed and not wasT then
        if ty >= VP_Y + 158 and ty <= VP_Y + 200 then
            sys.beep(1100, 20)
            isWork = not isWork
            totalSec = isWork and (25 * 60) or (5 * 60)
            remSec = totalSec
            running = false
            drawChrome(); drawClock()
        elseif ty >= VP_Y + 212 then
            sys.beep(1250, 20)
            if tx < 120 then running = not running
            else remSec = totalSec; running = false end
            drawChrome(); drawClock()
        end
    end
    wasT = pressed

    local now = sys.getUptime()
    if running and (now - lastTick >= 1000) then
        lastTick = now
        if remSec > 0 then
            remSec = remSec - 1
            drawClock()
        else
            sys.beep(1600, 200)
            if isWork then sessions = sessions + 1 end
            isWork = not isWork
            totalSec = isWork and (25 * 60) or (5 * 60)
            remSec = totalSec
            running = false
            drawChrome(); drawClock()
        end
    end
    sys.delay(30)
end
