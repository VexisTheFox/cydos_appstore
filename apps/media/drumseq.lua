-- @name: BeatBox 8
-- @bg: 0x580F
-- @icon_b64: 7u7u7u7uAADg4ODg4OAAAA4ODg4ODgAA7u7u7u7uAAA=

local VP_X, VP_Y, VP_W, VP_H = 0, 20, 240, 274
local tracks = {
    { name = "KICK", freq = 110, dur = 45, col = 0xF800, steps = {true,false,false,false,true,false,false,false} },
    { name = "SNAR", freq = 340, dur = 35, col = 0xFFE0, steps = {false,false,true,false,false,false,true,false} },
    { name = "HHAT", freq = 1800, dur = 14, col = 0x07FF, steps = {true,true,true,true,true,true,true,true} },
    { name = "BASS", freq = 220, dur = 50, col = 0x07E0, steps = {true,false,false,true,false,true,false,false} }
}
local bpm = 120
local playing = true
local curStep = 1

local function drawGrid()
    gui.fillRect(VP_X, VP_Y, VP_W, VP_H, 0x0821)
    gui.fillRect(VP_X, VP_Y, VP_W, 24, 0x580F)
    gui.drawText(8, VP_Y + 8, "BEATBOX 8-STEP SEQUENCER | " .. bpm .. " BPM", 0xFFFF, 1)

    for t = 1, 4 do
        local ty = VP_Y + 36 + (t - 1) * 42
        gui.drawText(6, ty + 12, tracks[t].name, tracks[t].col, 1)
        for s = 1, 8 do
            local sx = 42 + (s - 1) * 24
            local on = tracks[t].steps[s]
            gui.fillRect(sx, ty, 21, 34, on and tracks[t].col or 0x18E3)
            gui.drawRect(sx, ty, 21, 34, (s == curStep) and 0xFFFF or 0x3186)
        end
    end

    gui.fillRect(12, VP_Y + 216, 96, 42, playing and 0x7800 or 0x04D3)
    gui.drawRect(12, VP_Y + 216, 96, 42, 0xFFFF)
    gui.drawText(28, VP_Y + 233, playing and "PAUSE SEQ" or "PLAY SEQ", 0xFFFF, 1)

    gui.fillRect(118, VP_Y + 216, 52, 42, 0x10A2)
    gui.drawRect(118, VP_Y + 216, 52, 42, 0x07FF)
    gui.drawText(130, VP_Y + 233, "BPM-", 0xFFFF, 1)

    gui.fillRect(176, VP_Y + 216, 52, 42, 0x10A2)
    gui.drawRect(176, VP_Y + 216, 52, 42, 0x07FF)
    gui.drawText(188, VP_Y + 233, "BPM+", 0xFFFF, 1)
end

local function updatePlayhead(prevS, newS)
    for t = 1, 4 do
        local ty = VP_Y + 36 + (t - 1) * 42
        gui.drawRect(42 + (prevS - 1) * 24, ty, 21, 34, 0x3186)
        gui.drawRect(42 + (newS - 1) * 24, ty, 21, 34, 0xFFFF)
    end
end

drawGrid()
local lastStepMs = sys.getUptime()
local wasT = false

while true do
    local tx, ty, pressed = input.getTouch()
    if pressed and not wasT then
        if ty >= VP_Y + 36 and ty < VP_Y + 204 and tx >= 42 and tx < 234 then
            local t = math.floor((ty - (VP_Y + 36)) / 42) + 1
            local s = math.floor((tx - 42) / 24) + 1
            if t >= 1 and t <= 4 and s >= 1 and s <= 8 then
                tracks[t].steps[s] = not tracks[t].steps[s]
                local sx = 42 + (s - 1) * 24
                local ry = VP_Y + 36 + (t - 1) * 42
                gui.fillRect(sx, ry, 21, 34, tracks[t].steps[s] and tracks[t].col or 0x18E3)
                gui.drawRect(sx, ry, 21, 34, (s == curStep) and 0xFFFF or 0x3186)
            end
        elseif ty >= VP_Y + 216 then
            if tx < 110 then playing = not playing
            elseif tx < 172 then bpm = math.max(60, bpm - 10)
            else bpm = math.min(200, bpm + 10) end
            drawGrid()
        end
    end
    wasT = pressed

    local now = sys.getUptime()
    local stepInterval = math.floor(15000 / bpm)
    if playing and (now - lastStepMs >= stepInterval) then
        lastStepMs = now
        local prevS = curStep
        curStep = (curStep % 8) + 1
        updatePlayhead(prevS, curStep)
        for t = 1, 4 do
            if tracks[t].steps[curStep] then
                sys.beep(tracks[t].freq, tracks[t].dur)
                break
            end
        end
    end
    sys.delay(15)
end
