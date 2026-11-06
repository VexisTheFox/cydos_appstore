-- @name: PassVault
-- @bg: 0x0352
-- @icon_b64: B+AP8BgYGBgYGBgYf/5//n5+fD5+fn5+f/4//AAAAAA=

local VP_X, VP_Y, VP_W, VP_H = 0, 20, 240, 274
local CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789!@#$%&*"
local curPass = "Tap GENERATE"
local curPin = "----"
local len = 12
local status = "Entropy: 78 bits (Strong)"

local function genNow()
    local out = {}
    for i = 1, len do
        local idx = math.random(1, #CHARS)
        table.insert(out, string.sub(CHARS, idx, idx))
    end
    curPass = table.concat(out)
    curPin = string.format("%04d", math.random(0, 9999))
    status = "Generated " .. len .. "-char key + 4-digit PIN"
end

local function drawUI()
    gui.fillRect(VP_X, VP_Y, VP_W, VP_H, 0x0821)
    gui.fillRect(VP_X, VP_Y, VP_W, 24, 0x0352)
    gui.drawText(8, VP_Y + 8, "PASSVAULT KEY & PIN GENERATOR", 0xFFFF, 1)

    gui.fillRect(12, VP_Y + 34, 216, 56, 0x10A2)
    gui.drawRect(12, VP_Y + 34, 216, 56, 0x07FF)
    gui.drawText(20, VP_Y + 42, "PASSWORD (" .. len .. " CHARS):", 0x9CD3, 1)
    gui.drawText(20, VP_Y + 58, curPass, 0x07E0, 2)

    gui.fillRect(12, VP_Y + 98, 216, 44, 0x10A2)
    gui.drawRect(12, VP_Y + 98, 216, 44, 0x3186)
    gui.drawText(20, VP_Y + 106, "RANDOM 4-DIGIT PIN:", 0x9CD3, 1)
    gui.drawText(148, VP_Y + 104, curPin, 0xFFE0, 2)
    gui.drawText(20, VP_Y + 124, status, 0x07FF, 1)

    gui.fillRect(12, VP_Y + 152, 216, 36, 0x18E3)
    gui.drawRect(12, VP_Y + 152, 216, 36, 0x07FF)
    gui.drawText(42, VP_Y + 166, "LENGTH: " .. len .. " (TAP TO CYCLE)", 0xFFFF, 1)

    gui.fillRect(12, VP_Y + 202, 104, 48, 0x04D3)
    gui.drawRect(12, VP_Y + 202, 104, 48, 0x07E0)
    gui.drawText(26, VP_Y + 222, "GENERATE", 0xFFFF, 1)

    gui.fillRect(124, VP_Y + 202, 104, 48, 0x2C9F)
    gui.drawRect(124, VP_Y + 202, 104, 48, 0xFFE0)
    gui.drawText(134, VP_Y + 222, "SAVE VAULT", 0xFFFF, 1)
end

genNow()
drawUI()

local wasT = false
while true do
    local tx, ty, pressed = input.getTouch()
    if pressed and not wasT then
        if ty >= VP_Y + 152 and ty <= VP_Y + 188 then
            sys.beep(1050, 18)
            len = (len == 8) and 12 or ((len == 12) and 16 or 8)
            genNow(); drawUI()
        elseif ty >= VP_Y + 202 then
            sys.beep(1250, 22)
            if tx < 120 then
                genNow(); drawUI()
            else
                file.write("/apps/vault_key.txt", "PASS: " .. curPass .. "\nPIN: " .. curPin)
                status = "Saved to /apps/vault_key.txt!"
                drawUI()
            end
        end
    end
    wasT = pressed
    sys.delay(25)
end
