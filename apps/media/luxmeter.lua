-- @name: LuxScope
-- @bg: 0x5280
-- @icon_b64: AYAhhBAIB+AP8Bw4GBjoF+gXGBgcOA/wB+AQCCGEAYA=

local VP_X, VP_Y, VP_W, VP_H = 0, 20, 240, 274
local samples = {}
for i = 1, 50 do samples[i] = 500 end
local minV, maxV = 4095, 0

gui.fillRect(VP_X, VP_Y, VP_W, VP_H, 0x0821)
gui.fillRect(VP_X, VP_Y, VP_W, 22, 0x5280)
gui.drawFastHLine(VP_X, VP_Y + 22, VP_W, 0xFFE0)
gui.drawText(8, VP_Y + 7, "LDR LIGHT SENSOR OSCILLOSCOPE", 0xFFFF, 1)

gui.fillRect(20, VP_Y + 224, 200, 38, 0x18E3)
gui.drawRect(20, VP_Y + 224, 200, 38, 0x07FF)
gui.drawText(54, VP_Y + 239, "RESET MIN / MAX PEAKS", 0xFFFF, 1)

local wasT = false
while true do
    local tx, ty, pressed = input.getTouch()
    if pressed and not wasT and ty >= VP_Y + 222 then
        minV, maxV = 4095, 0
        sys.beep(1200, 20)
    end
    wasT = pressed

    local raw = sys.getLdr and sys.getLdr() or 512
    -- Invert or scale raw ADC (0..4095) into relative brightness %
    local pct = math.floor(((4095 - math.min(4095, raw)) / 4095) * 100)
    if raw < minV then minV = raw end
    if raw > maxV then maxV = raw end

    table.remove(samples, 1)
    table.insert(samples, pct)

    gui.fillRect(12, VP_Y + 30, 216, 62, 0x10A2)
    gui.drawRect(12, VP_Y + 30, 216, 62, 0x3186)
    gui.drawText(20, VP_Y + 38, "ADC (GPIO 34): " .. raw, 0x07FF, 1)
    gui.drawText(20, VP_Y + 54, "LIGHT LEVEL : " .. pct .. "%", 0xFFE0, 2)
    gui.drawText(20, VP_Y + 76, "Min ADC: " .. minV .. " | Max ADC: " .. maxV, 0x9CD3, 1)

    local gx, gy, gw, gh = 12, VP_Y + 100, 216, 114
    gui.fillRect(gx, gy, gw, gh, 0x0000)
    gui.drawRect(gx, gy, gw, gh, 0x07E0)
    for i = 2, #samples do
        local x1 = gx + 6 + (i - 2) * 4
        local y1 = gy + gh - 6 - math.floor((samples[i - 1] / 100) * (gh - 12))
        local x2 = gx + 6 + (i - 1) * 4
        local y2 = gy + gh - 6 - math.floor((samples[i] / 100) * (gh - 12))
        gui.drawLine(x1, y1, x2, y2, 0x07E0)
    end

    sys.delay(60)
end
