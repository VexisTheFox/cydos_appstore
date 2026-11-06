-- @name: BrickBreak
-- @bg: 0x9008
-- @icon_b64: 73vvewAA93v3ewAA73sAAAGAA8ABgAAAAAAf+D/8AAA=

local VP_X, VP_Y, VP_W, VP_H = 0, 20, 240, 274
local padX, prevPadX = 94, 94
local PAD_W, PAD_Y = 52, VP_Y + 248
local bx, by = 120, VP_Y + 180
local vx, vy = 3, -3.5
local prevBx, prevBy = bx, by
local score = 0
local bricks = {}
local rowCols = {0xF800, 0xFD20, 0xFFE0, 0x07E0, 0x07FF}

local function initBricks()
    gui.fillRect(VP_X, VP_Y, VP_W, VP_H, 0x0821)
    gui.fillRect(VP_X, VP_Y, VP_W, 20, 0x9008)
    gui.drawText(8, VP_Y + 6, "BRICK BREAKER | SCORE: " .. score, 0xFFFF, 1)
    bricks = {}
    for r = 1, 5 do
        bricks[r] = {}
        for c = 1, 6 do
            bricks[r][c] = true
            local x = 8 + (c - 1) * 38
            local y = VP_Y + 28 + (r - 1) * 14
            gui.fillRect(x, y, 34, 10, rowCols[r])
        end
    end
end

initBricks()

while true do
    local tx, ty, pressed = input.getTouch()
    if pressed then
        padX = tx - PAD_W / 2
        if padX < 4 then padX = 4 elseif padX > 236 - PAD_W then padX = 236 - PAD_W end
    end

    gui.fillRect(math.floor(prevBx) - 3, math.floor(prevBy) - 3, 7, 7, 0x0821)
    if math.floor(padX) ~= math.floor(prevPadX) then
        gui.fillRect(math.floor(prevPadX), PAD_Y, PAD_W, 8, 0x0821)
    end
    gui.fillRect(math.floor(padX), PAD_Y, PAD_W, 8, 0x07FF)

    bx = bx + vx
    by = by + vy

    if bx <= 6 or bx >= 234 then vx = -vx end
    if by <= VP_Y + 24 then vy = -vy end

    if vy > 0 and by >= PAD_Y - 4 and by <= PAD_Y + 6 and bx >= padX - 4 and bx <= padX + PAD_W + 4 then
        vy = -math.abs(vy)
        vx = ((bx - (padX + PAD_W / 2)) / (PAD_W / 2)) * 4.0
        sys.beep(980, 12)
    end

    for r = 1, 5 do
        local y = VP_Y + 28 + (r - 1) * 14
        if by >= y - 3 and by <= y + 12 then
            for c = 1, 6 do
                if bricks[r][c] then
                    local x = 8 + (c - 1) * 38
                    if bx >= x - 2 and bx <= x + 36 then
                        bricks[r][c] = false
                        gui.fillRect(x, y, 34, 10, 0x0821)
                        vy = -vy
                        score = score + 10
                        sys.beep(1350, 14)
                        gui.fillRect(140, VP_Y + 4, 96, 12, 0x9008)
                        gui.drawText(142, VP_Y + 6, "SCORE: " .. score, 0xFFE0, 1)
                        break
                    end
                end
            end
        end
    end

    if by > VP_Y + VP_H - 6 then
        sys.beep(240, 80)
        score = 0
        bx, by, vx, vy = 120, VP_Y + 180, 3, -3.5
        initBricks()
    end

    gui.fillCircle(math.floor(bx), math.floor(by), 3, 0xFFE0)
    prevBx, prevBy, prevPadX = bx, by, padX
    sys.delay(22)
end
