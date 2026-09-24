local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

if PlayerGui:FindFirstChild("SWILL_FreezeMenu") then
    PlayerGui["SWILL_FreezeMenu"]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SWILL_FreezeMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 130)
MainFrame.Position = UDim2.new(0, 20, 0.5, -65)
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
Title.Text = "SWILL Freeze"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 45)
ToggleBtn.Position = UDim2.new(0.05, 0, 0, 45)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "FREEZE: OFF"
ToggleBtn.TextScaled = true
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ToggleBtn

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 25)
StatusLabel.Position = UDim2.new(0.05, 0, 0, 95)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Нажми, чтобы заморозить"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.Parent = MainFrame

local frozen = false
local heartbeatConn

local function FreezeTrade()
    if frozen then return end
    frozen = true
    local tradeGui = PlayerGui:FindFirstChild("TradeGui")
    if not tradeGui then
        StatusLabel.Text = "Трейд не открыт!"
        frozen = false
        return
    end
    heartbeatConn = RunService.Heartbeat:Connect(function()
        pcall(function()
            if tradeGui:FindFirstChild("Frame") then
                tradeGui.Frame.Visible = false
            end
            for _, g in pairs(tradeGui:GetDescendants()) do
                if g:IsA("TextButton") or g:IsA("ImageButton") then
                    if g.MouseButton1Click then
                        g.MouseButton1Click:Disconnect()
                    end
                end
            end
        end)
    end)
    ToggleBtn.Text = "FREEZE: ON"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    StatusLabel.Text = "Заморожено"
end

local function UnfreezeTrade()
    if not frozen then return end
    frozen = false
    if heartbeatConn then
        heartbeatConn:Disconnect()
        heartbeatConn = nil
    end
    local tradeGui = PlayerGui:FindFirstChild("TradeGui")
    if tradeGui and tradeGui:FindFirstChild("Frame") then
        tradeGui.Frame.Visible = true
    end
    ToggleBtn.Text = "FREEZE: OFF"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    StatusLabel.Text = "Нажми, чтобы заморозить"
end

ToggleBtn.MouseButton1Click:Connect(function()
    if frozen then
        UnfreezeTrade()
    else
        FreezeTrade()
    end
end)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "SWILL",
        Text = "Freeze Menu загружено",
        Duration = 3
    })
end)
