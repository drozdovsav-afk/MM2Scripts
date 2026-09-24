local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("SWILL_FreezeMenu") then
    PlayerGui["SWILL_FreezeMenu"]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SWILL_FreezeMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 170)
MainFrame.Position = UDim2.new(0, 20, 0.5, -85)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
Title.Text = "SWILL Freeze v3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.Parent = MainFrame

local ScanBtn = Instance.new("TextButton")
ScanBtn.Size = UDim2.new(0.9, 0, 0, 35)
ScanBtn.Position = UDim2.new(0.05, 0, 0, 40)
ScanBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.Text = "1. Найти окно трейда"
ScanBtn.TextScaled = true
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.Parent = MainFrame

local FreezeBtn = Instance.new("TextButton")
FreezeBtn.Size = UDim2.new(0.9, 0, 0, 35)
FreezeBtn.Position = UDim2.new(0.05, 0, 0, 80)
FreezeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
FreezeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FreezeBtn.Text = "2. ЗАМОРОЗИТЬ"
FreezeBtn.TextScaled = true
FreezeBtn.Font = Enum.Font.GothamBold
FreezeBtn.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 45)
StatusLabel.Position = UDim2.new(0.05, 0, 0, 120)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Открой трейд и нажми кнопку 1"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
StatusLabel.TextWrapped = true
StatusLabel.Parent = MainFrame

local tradeGui = nil
local frozen = false
local heartbeatConn = nil

local function ScanForTrade()
    tradeGui = nil
    local found = {}
    for _, gui in pairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name ~= "SWILL_FreezeMenu" then
            table.insert(found, gui.Name)
        end
    end
    print("[SWILL] Все GUI: " .. table.concat(found, ", "))
    local names = {"TradeGui", "TradingGui", "Trade", "TradeWindow", "TradeFrame"}
    for _, n in ipairs(names) do
        if PlayerGui:FindFirstChild(n) then
            tradeGui = PlayerGui[n]
            StatusLabel.Text = "Найдено: " .. n
            print("[SWILL] Найдено: " .. n)
            return
        end
    end
    for _, gui in pairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and string.find(string.lower(gui.Name), "trade") then
            tradeGui = gui
            StatusLabel.Text = "Найдено: " .. gui.Name
            print("[SWILL] Найдено: " .. gui.Name)
            return
        end
    end
    StatusLabel.Text = "Не найдено. Открой трейд!"
end

local function Freeze()
    if not tradeGui then
        StatusLabel.Text = "Сначала нажми кнопку 1!"
        return
    end
    if frozen then return end
    frozen = true
    heartbeatConn = game:GetService("RunService").Heartbeat:Connect(function()
        pcall(function()
            for _, g in pairs(tradeGui:GetDescendants()) do
                if g:IsA("TextButton") or g:IsA("ImageButton") then
                    if g.MouseButton1Click then
                        g.MouseButton1Click:Disconnect()
                    end
                end
            end
        end)
    end)
    FreezeBtn.Text = "РАЗМОРОЗИТЬ"
    FreezeBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    StatusLabel.Text = "Заморожено: " .. tradeGui.Name
end
local function Unfreeze()
    if not frozen then return end
    frozen = false
    if heartbeatConn then
        heartbeatConn:Disconnect()
        heartbeatConn = nil
    end
    FreezeBtn.Text = "2. ЗАМОРОЗИТЬ"
    FreezeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    StatusLabel.Text = "Разморожено"
end

ScanBtn.MouseButton1Click:Connect(ScanForTrade)
FreezeBtn.MouseButton1Click:Connect(function()
    if frozen then Unfreeze() else Freeze() end
end)

print("[SWILL] Freeze v3 загружен")
