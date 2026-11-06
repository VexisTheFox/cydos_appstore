-- @name: CyberSnake
-- @bg: 0x03E0
-- @icon_b64: AAAAAAAA//wAAP/+AAD/AAAA/wAAAP/8AAD//wAAAA/wAAAP8AAAD/AA//8AAP/+AAAAAAAAAAAAAAAAAAAAAA==

local VP_X, VP_Y, VP_W, VP_H = 0, 20, 240, 274
local CELL = 10
local COLS, ROWS = 22, 18
local GX, GY = 10, VP_Y + 28

local snake = {{x = 10, y = 9}, {x = 9, y = 9}, {x = 8, y = 9}}
local dirX, dirY = 1, 0
local food = {x = 15, y = 9}
local score, best = 0, 0

local function spawnFood()
    food.x = math.random(0, COLS - 1)
    food.y = math.random(0, ROWS - 1)
end

local function drawChrome()
    gui.fillRect(VP_X, VP_Y, VP_W, VP_H, 0x0821)
    gui.fillRect(VP_X, VP_Y, VP_W, 22, 0x03E0)
    gui.drawText(8, VP_Y + 7, "CYBERSNAKE | S:" .. score .. " B:" .. best, 0x0000, 1)
    gui.drawRect(GX - 1, GY - 1, COLS * CELL + 2, ROWS * CELL + 2, 0x07E0)

    local by = VP_Y + 216
    local labels = {"LEFT", "UP", "DOWN", "RIGHT"}
    for i = 1, 4 do
        local bx = 8 + (i - 1) * 57
        gui.fillRect(bx, by, 53, 46, 0x10A2)
        gui.drawRect(bx, by, 53, 46, 0x07E0)
        gui.drawText(bx + 10, by + 18, labels[i], 0xFFFF, 1)
    end
end

drawChrome()
gui.fillRect(GX + food.x * CELL, GY + food.y * CELL, CELL - 1, CELL - 1, 0xF800)

while true do
    local tx, ty, pressed = input.getTouch()
    if pressed and ty >= VP_Y + 212 then
        local btn = math.floor((tx - 8) / 57) + 1
        if btn == 1 and dirX == 0 then dirX, dirY = -1, 0
        elseif btn == 2 and dirY == 0 then dirX, dirY = 0, -1
        elseif btn == 3 and dirY == 0 then dirX, dirY = 0, 1
        elseif btn == 4 and dirX == 0 then dirX, dirY = 1, 0 end
    end

    local nx = (snake[1].x + dirX) % COLS
    local ny = (snake[1].y + dirY) % ROWS

    local hit = false
    for i = 1, #snake do
        if snake[i].x == nx and snake[i].y == ny then hit = true; break end
    end

    if hit then
        sys.beep(240, 90)
        score = 0
        snake = {{x = 10, y = 9}, {x = 9, y = 9}, {x = 8, y = 9}}
        dirX, dirY = 1, 0
        drawChrome()
        gui.fillRect(GX + food.x * CELL, GY + food.y * CELL, CELL - 1, CELL - 1, 0xF800)
    else
        table.insert(snake, 1, {x = nx, y = ny})
        gui.fillRect(GX + nx * CELL, GY + ny * CELL, CELL - 1, CELL - 1, 0x07E0)
        if nx == food.x and ny == food.y then
            score = score + 10
            if score > best then best = score end
            sys.beep(1300, 18)
            gui.fillRect(VP_X, VP_Y, VP_W, 22, 0x03E0)
            gui.drawText(8, VP_Y + 7, "CYBERSNAKE | S:" .. score .. " B:" .. best, 0x0000, 1)
            spawnFood()
            gui.fillRect(GX + food.x * CELL, GY + food.y * CELL, CELL - 1, CELL - 1, 0xF800)
        else
            local tail = table.remove(snake)
            gui.fillRect(GX + tail.x * CELL, GY + tail.y * CELL, CELL - 1, CELL - 1, 0x0821)
        end
    end

    sys.delay(95)
end
