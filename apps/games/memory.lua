-- @name: MemMatrix
-- @bg: 0x4010
-- @icon_b64: fn5+fmZ+Zn5+fn5+AAAAAH5+fn5+Zn5mfn5+fgAAAAA=

local VP_X, VP_Y, VP_W, VP_H = 0, 20, 240, 274
local pads = {
    { x = 20,  y = VP_Y + 38, col = 0xF800, dim = 0x5800, freq = 440 },
    { x = 124, y = VP_Y + 38, col = 0x07E0, dim = 0x0280, freq = 554 },
    { x = 20,  y = VP_Y + 132, col = 0x07FF, dim = 0x0290, freq = 659 },
    { x = 124, y = VP_Y + 132, col = 0xFFE0, dim = 0x5A80, freq = 880 }
}
local seq = {}
local step = 1
local best = 0

local function drawPad(idx, lit)
    local p = pads[idx]
    gui.fillRect(p.x, p.y, 96, 84, lit and p.col or p.dim)
    gui.drawRect(p.x, p.y, 96, 84, 0xFFFF)
end

local function drawHeader(msg)
    gui.fillRect(VP_X, VP_Y, VP_W, 26, 0x4010)
    gui.drawText(8, VP_Y + 8, "MEMMATRIX | LVL:" .. #seq .. " BEST:" .. best, 0xFFFF, 1)
    gui.fillRect(20, VP_Y + 228, 200, 34, 0x10A2)
    gui.drawRect(20, VP_Y + 228, 200, 34, 0x07FF)
    gui.drawText(32, VP_Y + 241, msg, 0xFFE0, 1)
end

local function playSeq()
    drawHeader("Watch the sequence...")
    sys.delay(350)
    for i = 1, #seq do
        local idx = seq[i]
        drawPad(idx, true)
        sys.beep(pads[idx].freq, 120)
        sys.delay(220)
        drawPad(idx, false)
        sys.delay(110)
    end
    step = 1
    drawHeader("Your turn! Tap pads in order")
end

local function nextRound()
    table.insert(seq, math.random(1, 4))
    if #seq - 1 > best then best = #seq - 1 end
    playSeq()
end

gui.fillRect(VP_X, VP_Y, VP_W, VP_H, 0x0821)
for i = 1, 4 do drawPad(i, false) end
nextRound()

local wasT = false
while true do
    local tx, ty, pressed = input.getTouch()
    if pressed and not wasT then
        for i = 1, 4 do
            local p = pads[i]
            if tx >= p.x and tx <= p.x + 96 and ty >= p.y and ty <= p.y + 84 then
                drawPad(i, true)
                sys.beep(p.freq, 90)
                sys.delay(140)
                drawPad(i, false)
                if i == seq[step] then
                    step = step + 1
                    if step > #seq then
                        sys.delay(250)
                        nextRound()
                    end
                else
                    sys.beep(220, 200)
                    drawHeader("Wrong! Restarting level 1...")
                    sys.delay(700)
                    seq = {}
                    nextRound()
                end
                break
            end
        end
    end
    wasT = pressed
    sys.delay(25)
end
