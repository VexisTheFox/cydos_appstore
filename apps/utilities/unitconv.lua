-- @name: UnitConv
-- @bg: 0x0451
-- @icon_b64: CAAYAD/8f/wwABAAAAAACAAYP/4//AAYAAgAAP//kkk=

local VP_X, VP_Y, VP_W, VP_H = 0, 20, 240, 274
local modes = {
    { name = "KM <-> MI",   u1 = "km", u2 = "mi",  fn = function(v) return v * 0.621371 end },
    { name = "KG <-> LB",   u1 = "kg", u2 = "lb",  fn = function(v) return v * 2.20462 end },
    { name = "C <-> F",     u1 = "C",  u2 = "F",   fn = function(v) return (v * 9 / 5) + 32 end },
    { name = "CM <-> INCH", u1 = "cm", u2 = "in",  fn = function(v) return v * 0.393701 end }
}
local mIdx = 1
local val = 10

local function drawUI()
    local m = modes[mIdx]
    gui.fillRect(VP_X, VP_Y, VP_W, VP_H, 0x0821)
    gui.fillRect(VP_X, VP_Y, VP_W, 24, 0x0451)
    gui.drawText(8, VP_Y + 8, "ENGINEERING UNIT CONVERTER", 0xFFFF, 1)

    gui.fillRect(14, VP_Y + 32, 212, 32, 0x18E3)
    gui.drawRect(14, VP_Y + 32, 212, 32, 0x07FF)
    gui.drawText(34, VP_Y + 44, "< MODE: " .. m.name .. " >", 0xFFE0, 1)

    gui.fillRect(14, VP_Y + 72, 212, 82, 0x10A2)
    gui.drawRect(14, VP_Y + 72, 212, 82, 0x3186)
    gui.drawText(24, VP_Y + 84, string.format("INPUT : %d %s", val, m.u1), 0xFFFF, 2)
    gui.drawText(24, VP_Y + 118, string.format("RESULT: %.2f %s", m.fn(val), m.u2), 0x07E0, 2)

    local deltas = {"-10", "-1", "+1", "+10", "x10", "CLR"}
    for i = 1, 6 do
        local r = math.floor((i - 1) / 3)
        local c = (i - 1) % 3
        local bx = 14 + c * 72
        local by = VP_Y + 166 + r * 46
        gui.fillRect(bx, by, 68, 40, 0x2C9F)
        gui.drawRect(bx, by, 68, 40, 0x07FF)
        gui.drawText(bx + 22, by + 16, deltas[i], 0xFFFF, 1)
    end
end

drawUI()
local wasT = false
while true do
    local tx, ty, pressed = input.getTouch()
    if pressed and not wasT then
        if ty >= VP_Y + 32 and ty <= VP_Y + 64 then
            sys.beep(1050, 18)
            mIdx = (mIdx % #modes) + 1
            drawUI()
        elseif ty >= VP_Y + 166 and ty <= VP_Y + 258 then
            sys.beep(1200, 18)
            local r = math.floor((ty - (VP_Y + 166)) / 46)
            local c = math.floor((tx - 14) / 72)
            local idx = r * 3 + c + 1
            if idx == 1 then val = val - 10
            elseif idx == 2 then val = val - 1
            elseif idx == 3 then val = val + 1
            elseif idx == 4 then val = val + 10
            elseif idx == 5 then val = val * 10
            elseif idx == 6 then val = 0 end
            drawUI()
        end
    end
    wasT = pressed
    sys.delay(25)
end
