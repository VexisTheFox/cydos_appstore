-- @name: CryptoTick
-- @bg: 0x8400
-- @icon_b64: BmAGYB/wGBgYGBgwH+Af8BgYGAwYDBgYH/AGYAZgAAA=

local VP_X, VP_Y, VP_W, VP_H = 0, 20, 240, 274
local coins = {
    { sym = "BTC", name = "Bitcoin",  price = "---", col = 0xFD20 },
    { sym = "ETH", name = "Ethereum", price = "---", col = 0x07FF },
    { sym = "SOL", name = "Solana",   price = "---", col = 0x07E0 }
}
local status = "Tap REFRESH LIVE PRICES"

local function drawUI()
    gui.fillRect(VP_X, VP_Y, VP_W, VP_H, 0x0821)
    gui.fillRect(VP_X, VP_Y, VP_W, 24, 0x8400)
    gui.drawFastHLine(VP_X, VP_Y + 24, VP_W, 0xFFE0)
    gui.drawText(8, VP_Y + 8, "CRYPTO LIVE TICKER (USD)", 0xFFFF, 1)

    for i = 1, 3 do
        local cy = VP_Y + 32 + (i - 1) * 48
        gui.fillRect(12, cy, 216, 42, 0x10A2)
        gui.drawRect(12, cy, 216, 42, coins[i].col)
        gui.drawText(20, cy + 8, coins[i].sym .. " - " .. coins[i].name, coins[i].col, 1)
        gui.drawText(20, cy + 20, "$ " .. coins[i].price, 0xFFFF, 2)
    end

    gui.fillRect(12, VP_Y + 180, 216, 28, 0x10A2)
    gui.drawRect(12, VP_Y + 180, 216, 28, 0x3186)
    gui.drawText(18, VP_Y + 190, string.sub(status, 1, 34), 0x9CD3, 1)

    gui.fillRect(20, VP_Y + 218, 200, 42, 0x04D3)
    gui.drawRect(20, VP_Y + 218, 200, 42, 0xFFE0)
    gui.drawText(54, VP_Y + 235, "REFRESH LIVE PRICES", 0xFFFF, 1)
end

local function fetchCrypto()
    status = "Querying CoinGecko HTTPS API..."
    drawUI()
    local url = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,solana&vs_currencies=usd"
    local body, code, err = http.get(url)
    if body and code == 200 then
        local btc = string.match(body, '"bitcoin"%s*:%s*{%s*"usd"%s*:%s*([0-9%.]+)')
        local eth = string.match(body, '"ethereum"%s*:%s*{%s*"usd"%s*:%s*([0-9%.]+)')
        local sol = string.match(body, '"solana"%s*:%s*{%s*"usd"%s*:%s*([0-9%.]+)')
        if btc then coins[1].price = btc end
        if eth then coins[2].price = eth end
        if sol then coins[3].price = sol end
        status = "Updated via CoinGecko API"
    else
        status = "Err " .. tostring(code) .. ": " .. tostring(err or "Check WiFi")
    end
    drawUI()
end

drawUI()
local wasT = false
while true do
    local tx, ty, pressed = input.getTouch()
    if pressed and not wasT and ty >= VP_Y + 216 and ty <= VP_Y + 262 then
        sys.beep(1300, 25)
        fetchCrypto()
    end
    wasT = pressed
    sys.delay(25)
end
