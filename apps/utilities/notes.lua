-- @name: QuickNotes
-- @bg: 0x2C9F
-- @icon_b64: P/w//DAMN+wwDDfsMAw37DAMN4wwDD/8P/wAAAAAAAA=

local VP_X, VP_Y, VP_W, VP_H = 0, 20, 240, 274
local FILE_PATH = "/apps/quicknotes.txt"
local lines = {"Tap + ADD NOTE to type", "Notes persist in Flash!"}

local function loadNotes()
    if file.exists(FILE_PATH) then
        local raw = file.read(FILE_PATH)
        if raw and #raw > 0 then
            lines = {}
            for s in string.gmatch(raw, "[^
]+") do
                table.insert(lines, s)
            end
        end
    end
end

local function saveNotes()
    file.write(FILE_PATH, table.concat(lines, "
"))
end

local function drawUI()
    gui.fillRect(VP_X, VP_Y, VP_W, VP_H, 0x0821)
    gui.fillRect(VP_X, VP_Y, VP_W, 24, 0x2C9F)
    gui.drawText(8, VP_Y + 8, "QUICKNOTES FLASH MEMO (" .. #lines .. ")", 0xFFFF, 1)

    for i = 1, 5 do
        local y = VP_Y + 32 + (i - 1) * 34
        gui.fillRect(12, y, 216, 30, 0x10A2)
        gui.drawRect(12, y, 216, 30, 0x3186)
        local txt = lines[i] or "--- empty slot ---"
        gui.drawText(18, y + 10, i .. ". " .. string.sub(txt, 1, 30), lines[i] and 0xFFFF or 0x8410, 1)
    end

    gui.fillRect(12, VP_Y + 214, 104, 44, 0x04D3)
    gui.drawRect(12, VP_Y + 214, 104, 44, 0x07FF)
    gui.drawText(26, VP_Y + 232, "+ ADD NOTE", 0xFFFF, 1)

    gui.fillRect(124, VP_Y + 214, 104, 44, 0x7800)
    gui.drawRect(124, VP_Y + 214, 104, 44, 0xF800)
    gui.drawText(138, VP_Y + 232, "CLEAR ALL", 0xFFFF, 1)
end

loadNotes()
drawUI()

local wasT = false
while true do
    local tx, ty, pressed = input.getTouch()
    if pressed and not wasT and ty >= VP_Y + 214 then
        sys.beep(1150, 20)
        if tx < 120 then
            local inputStr = gui.keyboard("New Flash Note", "")
            if inputStr and #inputStr > 0 then
                table.insert(lines, 1, inputStr)
                if #lines > 5 then table.remove(lines) end
                saveNotes()
            end
            drawUI()
        else
            lines = {}
            saveNotes()
            drawUI()
        end
    end
    wasT = pressed
    sys.delay(25)
end
