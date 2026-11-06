-- @name: Metronome
-- @bg: 0x3812
-- @icon_b64: A8AH4AZgDDANMBiYGJgwTDDsYOZgRv////9//gAAAAA=

local VP_X, VP_Y, VP_W, VP_H = 0, 20, 240, 274
local bpm = 100
local beatsPerBar = 4
local curBeat = 1
local running = true

local function drawChrome()
    gui.fillRect(VP_X, VP_Y, VP_W, VP_H, 0x0821)
    gui.fillRect(VP_X, VP_Y, VP_W, 24, 0x3812)
    gui.drawText(8, VP_Y + 8, "PRECISION STUDIO METRONOME", 0xFFFF, 1)

    gui.fillRect(14, VP_Y + 32, 212, 62, 0x10A2)
    gui.drawRect(14, VP_Y + 32, 212, 62, 0x07FF)
    gui.drawText(24, VP_Y + 42, tostring(bpm) .. " BPM", 0xFFE0, 4)
    gui.drawText(158, VP_Y + 52, beatsPerBar .. "/4 TIME", 0x07FF, 1)

    local btns = {"-10", "-1", "+1", "+10"}
    for i = 1, 4 do
        local bx = 14 + (i - 1) * 54
        gui.fillRect(bx, VP_Y + 168, 50, 36, 0x18E3)
        gui.drawRect(bx, VP_Y + 168, 50, 36, 0x07FF)
        gui.drawText(bx + 14, VP_Y + 182, btns[i], 0xFFFF, 1)
    end

    gui.fillRect(14, VP_Y + 214, 102, 44, running and 0x7800 or 0x04D3)
    gui.drawRect(14, VP_Y + 214, 102, 44, 0xFFFF)
    gui.drawText(34, VP_Y + 232, running and "STOP" or "START", 0xFFFF, 1)

    gui.fillRect(124, VP_Y + 214, 102, 44, 0x2C9F)
    gui.drawRect(124, VP_Y + 214, 102, 44, 0xFFE0)
    gui.drawText(140, VP_Y + 232, "TIME SIG", 0xFFFF, 1)
end

local function drawBeats()
    gui.fillRect(14, VP_Y + 102, 212, 56, 0x10A2)
    gui.drawRect(14, VP_Y + 102, 212, 56, 0x3186)
    for b = 1, beatsPerBar do
        local cx = 24 + (b - 1) * (192 / beatsPerBar) + 18
        local active = (b == curBeat)
        local col = active and ((b == 1) and 0xF800 or 0x07E0) or 0x2965
        gui.fillCircle(math.floor(cx), VP_Y + 130, 14, col)
    end
end

drawChrome()
drawBeats()

local lastBeatMs = sys.getUptime()
local wasT = false

while true do
    local tx, ty, pressed = input.getTouch()
    if pressed and not wasT then
        if ty >= VP_Y + 168 and ty <= VP_Y + 204 then
            local b = math.floor((tx - 14) / 54) + 1
            if b == 1 then bpm = math.max(40, bpm - 10)
            elseif b == 2 then bpm = math.max(40, bpm - 1)
            elseif b == 3 then bpm = math.min(208, bpm + 1)
            elseif b == 4 then bpm = math.min(208, bpm + 10) end
            drawChrome(); drawBeats()
        elseif ty >= VP_Y + 214 then
            if tx < 120 then running = not running
            else beatsPerBar = (beatsPerBar % 4) + 2; curBeat = 1 end
            drawChrome(); drawBeats()
        end
    end
    wasT = pressed

    local now = sys.getUptime()
    local interval = math.floor(60000 / bpm)
    if running and (now - lastBeatMs >= interval) then
        lastBeatMs = now
        drawBeats()
        sys.beep((curBeat == 1) and 1500 or 950, 25)
        curBeat = (curBeat % beatsPerBar) + 1
    end
    sys.delay(15)
end
