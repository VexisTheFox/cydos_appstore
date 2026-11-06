-- @name: OhmCalc
-- @bg: 0x4208
-- @icon_b64: AAAAAAAAAAAf+D/8Ntz23/bfNtw//B/4AAAAAAAAAAA=

local VP_X, VP_Y, VP_W, VP_H = 0, 20, 240, 274
local colors = {
    { name = "BLK", col = 0x0000, mult = 1 },
    { name = "BRN", col = 0x6180, mult = 10 },
    { name = "RED", col = 0xF800, mult = 100 },
    { name = "ORG", col = 0xFD20, mult = 1000 },
    { name = "YEL", col = 0xFFE0, mult = 10000 },
    { name = "GRN", col = 0x07E0, mult = 100000 },
    { name = "BLU", col = 0x001F, mult = 1000000 },
    { name = "VIO", col = 0x781F, mult = 10000000 },
    { name = "GRY", col = 0x8410, mult = 1 },
    { name = "WHT", col = 0xFFFF, mult = 1 }
}
local b1, b2, b3 = 2, 1, 3 -- Brown(1), Black(0), Red(x100) = 1.0 kOhm

local function fmtOhms()
    local base = (b1 - 1) * 10 + (b2 - 1)
    local ohms = base * colors[b3].mult
    if ohms >= 1000000 then return string.format("%.2f MOhm", ohms / 1000000)
    elseif ohms >= 1000 then return string.format("%.2f kOhm", ohms / 1000)
    else return tostring(ohms) .. " Ohm" end
end

local function drawUI()
    gui.fillRect(VP_X, VP_Y, VP_W, VP_H, 0x0821)
    gui.fillRect(VP_X, VP_Y, VP_W, 24, 0x4208)
    gui.drawText(8, VP_Y + 8, "4-BAND RESISTOR OHM CALCULATOR", 0xFFFF, 1)

    gui.fillRect(16, VP_Y + 52, 208, 8, 0x9CD3)
    gui.fillRect(46, VP_Y + 38, 148, 36, 0xD611)
    gui.drawRect(46, VP_Y + 38, 148, 36, 0xFFFF)

    gui.fillRect(68,  VP_Y + 39, 14, 34, colors[b1].col)
    gui.fillRect(98,  VP_Y + 39, 14, 34, colors[b2].col)
    gui.fillRect(128, VP_Y + 39, 14, 34, colors[b3].col)
    gui.fillRect(164, VP_Y + 39, 10, 34, 0xFFE0)

    gui.fillRect(16, VP_Y + 86, 208, 44, 0x10A2)
    gui.drawRect(16, VP_Y + 86, 208, 44, 0x07FF)
    gui.drawText(34, VP_Y + 98, fmtOhms() .. " (+/-5%)", 0x07E0, 2)

    local bands = {
        { lbl = "BAND 1 (1st Digit): " .. colors[b1].name .. " (" .. (b1 - 1) .. ")", y = VP_Y + 140 },
        { lbl = "BAND 2 (2nd Digit): " .. colors[b2].name .. " (" .. (b2 - 1) .. ")", y = VP_Y + 182 },
        { lbl = "BAND 3 (Multiplier): " .. colors[b3].name, y = VP_Y + 224 }
    }
    for i = 1, 3 do
        gui.fillRect(16, bands[i].y, 208, 34, 0x18E3)
        gui.drawRect(16, bands[i].y, 208, 34, 0x07FF)
        gui.drawText(26, bands[i].y + 12, bands[i].lbl, 0xFFFF, 1)
    end
end

drawUI()
local wasT = false
while true do
    local tx, ty, pressed = input.getTouch()
    if pressed and not wasT then
        if ty >= VP_Y + 140 and ty <= VP_Y + 174 then
            b1 = (b1 % 10) + 1; sys.beep(1000, 15); drawUI()
        elseif ty >= VP_Y + 182 and ty <= VP_Y + 216 then
            b2 = (b2 % 10) + 1; sys.beep(1100, 15); drawUI()
        elseif ty >= VP_Y + 224 and ty <= VP_Y + 258 then
            b3 = (b3 % 8) + 1; sys.beep(1200, 15); drawUI()
        end
    end
    wasT = pressed
    sys.delay(25)
end
