-- @name: Minesweep
-- @bg: 0x3186
-- @icon_b64: AYAhhBGID/Af+B24PDz8P/w/P/wf+B/4D/ARiCGEAYA=

local VP_X, VP_Y, VP_W, VP_H = 0, 20, 240, 274
local N, MINES = 7, 7
local CELL = 28
local GX, GY = 22, VP_Y + 30
local mine, rev, flag = {}, {}, {}
local flagMode = false
local gameOver = false

local function initBoard()
    gameOver = false
    for r = 1, N do
        mine[r], rev[r], flag[r] = {}, {}, {}
        for c = 1, N do mine[r][c], rev[r][c], flag[r][c] = false, false, false end
    end
    local placed = 0
    while placed < MINES do
        local r, c = math.random(1, N), math.random(1, N)
        if not mine[r][c] then mine[r][c] = true; placed = placed + 1 end
    end
end

local function countAdj(r, c)
    local cnt = 0
    for dr = -1, 1 do
        for dc = -1, 1 do
            local nr, nc = r + dr, c + dc
            if nr >= 1 and nr <= N and nc >= 1 and nc <= N and mine[nr][nc] then
                cnt = cnt + 1
            end
        end
    end
    return cnt
end

local function reveal(r, c)
    if r < 1 or r > N or c < 1 or c > N or rev[r][c] or flag[r][c] then return end
    rev[r][c] = true
    if countAdj(r, c) == 0 and not mine[r][c] then
        for dr = -1, 1 do
            for dc = -1, 1 do reveal(r + dr, c + dc) end
        end
    end
end

local function drawUI()
    gui.fillRect(VP_X, VP_Y, VP_W, VP_H, 0x0821)
    gui.fillRect(VP_X, VP_Y, VP_W, 22, 0x3186)
    gui.drawText(8, VP_Y + 7, gameOver and "MINESWEEPER [BOOM!]" or "MINESWEEPER (7 MINES)", 0xFFFF, 1)

    for r = 1, N do
        for c = 1, N do
            local x = GX + (c - 1) * CELL
            local y = GY + (r - 1) * CELL
            if rev[r][c] then
                local bg = mine[r][c] and 0xF800 or 0x10A2
                gui.fillRect(x, y, CELL - 2, CELL - 2, bg)
                gui.drawRect(x, y, CELL - 2, CELL - 2, 0x3186)
                if mine[r][c] then
                    gui.drawText(x + 9, y + 9, "*", 0xFFFF, 1)
                else
                    local n = countAdj(r, c)
                    if n > 0 then gui.drawText(x + 10, y + 9, tostring(n), 0x07FF, 1) end
                end
            else
                gui.fillRect(x, y, CELL - 2, CELL - 2, flag[r][c] and 0x6010 or 0x2965)
                gui.drawRect(x, y, CELL - 2, CELL - 2, 0x07FF)
                if flag[r][c] then gui.drawText(x + 9, y + 9, "F", 0xFFE0, 1) end
            end
        end
    end

    gui.fillRect(18, VP_Y + 232, 100, 34, flagMode and 0x6010 or 0x04D3)
    gui.drawRect(18, VP_Y + 232, 100, 34, 0xFFFF)
    gui.drawText(28, VP_Y + 245, flagMode and "MODE: FLAG" or "MODE: DIG", 0xFFFF, 1)

    gui.fillRect(126, VP_Y + 232, 96, 34, 0x2C9F)
    gui.drawRect(126, VP_Y + 232, 96, 34, 0x07FF)
    gui.drawText(144, VP_Y + 245, "NEW GAME", 0xFFFF, 1)
end

initBoard()
drawUI()

local wasT = false
while true do
    local tx, ty, pressed = input.getTouch()
    if pressed and not wasT then
        if ty >= GY and ty < GY + N * CELL and tx >= GX and tx < GX + N * CELL and not gameOver then
            local c = math.floor((tx - GX) / CELL) + 1
            local r = math.floor((ty - GY) / CELL) + 1
            if flagMode then
                flag[r][c] = not flag[r][c]
                sys.beep(900, 15)
            else
                if mine[r][c] then
                    rev[r][c] = true
                    gameOver = true
                    sys.beep(220, 120)
                else
                    reveal(r, c)
                    sys.beep(1200, 15)
                end
            end
            drawUI()
        elseif ty >= VP_Y + 230 then
            sys.beep(1050, 20)
            if tx < 122 then flagMode = not flagMode else initBoard() end
            drawUI()
        end
    end
    wasT = pressed
    sys.delay(25)
end
