-- @name: RGB Studio
-- @bg: 0x8010
-- @icon_b64: B+Af+D/8f/55nnGOeZ4//B/4D/AH4AfgA8AH4APAAAA=

local VP_X, VP_Y, VP_W, VP_H = 0, 20, 240, 274
local r, g, b = 0, 255, 180
local bl = 240

local function rgb565(rv, gv, bv)
    return (math.floor(rv / 8) * 2048) + (math.floor(gv / 4) * 32) + math.floor(bv / 8)
end

local function applyHardware()
    if sys.setLED then sys.setLED(r, g, b) end
    if sys.setBrightness then sys.setBrightness(bl) end
end

local function drawSlider(label, y, val, col)
    gui.fillRect(14, y, 212, 32, 0x10A2)
    gui.drawRect(14, y, 212, 32, 0x3186)
    gui.drawText(20, y + 4, label .. ": " .. val, 0xFFFF, 1)
    local w = math.floor((val / 255) * 196)
    gui.fillRect(20, y + 16, 196, 10, 0x0821)
    gui.fillRect(20, y + 16, w, 10, col)
end

local function drawUI()
    gui.fillRect(VP_X, VP_Y, VP_W, VP_H, 0x0821)
    gui.fillRect(VP_X, VP_Y, VP_W, 22, 0x8010)
    gui.drawText(8, VP_Y + 7, "CYD RGB LED & BACKLIGHT STUDIO", 0xFFFF, 1)

    gui.fillRect(14, VP_Y + 28, 212, 32, rgb565(r, g, b))
    gui.drawRect(14, VP_Y + 28, 212, 32, 0xFFFF)
    gui.drawText(22, VP_Y + 40, string.format("HEX: #%02X%02X%02X", r, g, b), 0x0000, 1)

    drawSlider("RED   (GPIO 4)",  VP_Y + 66,  r,  0xF800)
    drawSlider("GREEN (GPIO 16)", VP_Y + 104, g,  0x07E0)
    drawSlider("BLUE  (GPIO 17)", VP_Y + 142, b,  0x07FF)
    drawSlider("TFT BACKLIGHT",   VP_Y + 180, bl, 0xFFE0)

    local presets = {
        { name = "CYBER", r = 0, g = 255, b = 255 },
        { name = "NEON",  r = 255, g = 0, b = 180 },
        { name = "AMBER", r = 255, g = 160, b = 0 },
        { name = "OFF",   r = 0, g = 0, b = 0 }
    }
    for i = 1, 4 do
        local bx = 14 + (i - 1) * 54
        gui.fillRect(bx, VP_Y + 222, 50, 38, 0x18E3)
        gui.drawRect(bx, VP_Y + 222, 50, 38, 0x07FF)
        gui.drawText(bx + 8, VP_Y + 237, presets[i].name, 0xFFFF, 1)
    end
end

applyHardware()
drawUI()

while true do
    local tx, ty, pressed = input.getTouch()
    if pressed and tx >= 20 and tx <= 216 then
        local v = math.floor(((tx - 20) / 196) * 255)
        if v < 0 then v = 0 elseif v > 255 then v = 255 end
        if ty >= VP_Y + 66 and ty <= VP_Y + 98 then r = v; applyHardware(); drawUI()
        elseif ty >= VP_Y + 104 and ty <= VP_Y + 136 then g = v; applyHardware(); drawUI()
        elseif ty >= VP_Y + 142 and ty <= VP_Y + 174 then b = v; applyHardware(); drawUI()
        elseif ty >= VP_Y + 180 and ty <= VP_Y + 212 then bl = math.max(25, v); applyHardware(); drawUI()
        elseif ty >= VP_Y + 222 and ty <= VP_Y + 260 then
            local idx = math.floor((tx - 14) / 54) + 1
            if idx == 1 then r, g, b = 0, 255, 255
            elseif idx == 2 then r, g, b = 255, 0, 180
            elseif idx == 3 then r, g, b = 255, 160, 0
            elseif idx == 4 then r, g, b = 0, 0, 0 end
            sys.beep(1100, 18)
            applyHardware()
            drawUI()
        end
    end
    sys.delay(25)
end
