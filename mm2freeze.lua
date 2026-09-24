if not frozen then return end
    frozen = false
    if heartbeatConn then
        heartbeatConn:Disconnect()
        heartbeatConn = nil
    end
    if tradeGuiName then
        local tg = PlayerGui:FindFirstChild(tradeGuiName)
        if tg then
            for _, g in pairs(tg:GetDescendants()) do
                if g:IsA("Frame") or g:IsA("TextLabel") or g:IsA("ImageLabel") then
                    g.Visible = true
                end
            end
        end
    end
    ToggleBtn.Text = "FREEZE: OFF"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    StatusLabel.Text = "Разморожено"
end

ToggleBtn.MouseButton1Click:Connect(function()
    if frozen then UnfreezeTrade() else FreezeTrade() end
end)

ScanBtn.MouseButton1Click:Connect(function()
    local found = FindTradeGui()
    if found then
        StatusLabel.Text = "Найдено: " .. found.Name
        print("[SWILL] Trade GUI: " .. found.Name)
    else
        StatusLabel.Text = "Не найдено"
        print("[SWILL] Trade GUI не найден")
    end
end)

print("[SWILL] Freeze v2 загружен")
