-- @name: TechQuotes
-- @bg: 0x4812
-- @icon_b64: P/x//sAD3DvcO8wb0CPAA9/73+PAA3/+Pn4GwAcAAAA=

local VP_X, VP_Y, VP_W, VP_H = 0, 20, 240, 274
local fallback = {
    { q = "Talk is cheap. Show me the code.", a = "Linus Torvalds" },
    { q = "Simplicity is prerequisite for reliability.", a = "Edsger Dijkstra" },
    { q = "First, solve the problem. Then write code.", a = "John Johnson" },
    { q = "Premature optimization is the root of evil.", a = "Donald Knuth" },
    { q = "Hardware eventually fails. Software lives.", a = "Michael Hartung" }
}
local curQ = fallback[1].q
local curA = fallback[1].a
local status = "Ready (Cloud + Offline Library)"

local function wrapText(str, x, y, maxChars, col)
    local line = ""
    local row = 0
    for word in string.gmatch(str, "%S+") do
        if #line + #word + 1 > maxChars then
            gui.drawText(x, y + row * 14, line, col, 1)
            row = row + 1
            line = word
            if row >= 5 then break end
        else
            line = (#line == 0) and word or (line .. " " .. word)
        end
    end
    if row < 5 and #line > 0 then
        gui.drawText(x, y + row * 14, line, col, 1)
    end
end

local function drawUI()
    gui.fillRect(VP_X, VP_Y, VP_W, VP_H, 0x0821)
    gui.fillRect(VP_X, VP_Y, VP_W, 24, 0x4812)
    gui.drawFastHLine(VP_X, VP_Y + 24, VP_W, 0x07FF)
    gui.drawText(8, VP_Y + 8, "TECH QUOTES & CLOUD WISDOM", 0xFFFF, 1)

    gui.fillRect(12, VP_Y + 34, 216, 124, 0x10A2)
    gui.drawRect(12, VP_Y + 34, 216, 124, 0x07FF)
    wrapText('"' .. curQ .. '"', 20, VP_Y + 46, 31, 0xFFFF)
    gui.drawText(20, VP_Y + 136, "- " .. string.sub(curA, 1, 28), 0xFFE0, 1)

    gui.fillRect(12, VP_Y + 166, 216, 32, 0x10A2)
    gui.drawRect(12, VP_Y + 166, 216, 32, 0x3186)
    gui.drawText(18, VP_Y + 178, string.sub(status, 1, 34), 0x07E0, 1)

    gui.fillRect(12, VP_Y + 212, 104, 44, 0x04D3)
    gui.drawRect(12, VP_Y + 212, 104, 44, 0x07FF)
    gui.drawText(26, VP_Y + 230, "FETCH QUOTE", 0xFFFF, 1)

    gui.fillRect(124, VP_Y + 212, 104, 44, 0x2C9F)
    gui.drawRect(124, VP_Y + 212, 104, 44, 0xFFE0)
    gui.drawText(138, VP_Y + 230, "SAVE FLASH", 0xFFFF, 1)
end

local function fetchQuote()
    status = "Fetching dummyjson.com/quotes..."
    drawUI()
    local body, code = http.get("https://dummyjson.com/quotes/random")
    if body and code == 200 then
        local q = string.match(body, '"quote"%s*:%s*"([^"]+)"')
        local a = string.match(body, '"author"%s*:%s*"([^"]+)"')
        if q then curQ = q end
        if a then curA = a end
        status = "Fetched live quote via HTTPS!"
    else
        local pick = fallback[math.random(1, #fallback)]
        curQ, curA = pick.q, pick.a
        status = "Offline Wisdom (No WiFi)"
    end
    drawUI()
end

drawUI()
local wasT = false
while true do
    local tx, ty, pressed = input.getTouch()
    if pressed and not wasT and ty >= VP_Y + 212 and ty <= VP_Y + 258 then
        sys.beep(1150, 20)
        if tx < 120 then
            fetchQuote()
        else
            file.write("/apps/saved_quote.txt", curQ .. " - " .. curA)
            status = "Saved to /apps/saved_quote.txt!"
            drawUI()
        end
    end
    wasT = pressed
    sys.delay(25)
end
