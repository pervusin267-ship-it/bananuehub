-- [[ BANANUE HUB | DEAD RAILS ]] --
local p = game.Players.LocalPlayer
local cam = workspace.CurrentCamera
local vim = game:GetService("VirtualInputManager")

-- Создание интерфейса (CoreGui для защиты)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
local Title = Instance.new("TextLabel", MainFrame)
local ToggleBtn = Instance.new("TextButton", MainFrame)
local SpeedInput = Instance.new("TextBox", MainFrame)
local SetSpeedBtn = Instance.new("TextButton", MainFrame)
local TpEndBtn = Instance.new("TextButton", MainFrame)
local HideBtn = Instance.new("TextButton", MainFrame)

ScreenGui.ResetOnSpawn = false
MainFrame.Size, MainFrame.Position = UDim2.new(0, 220, 0, 230), UDim2.new(0.05, 0, 0.4, 0)
MainFrame.BackgroundColor3, MainFrame.Active, MainFrame.Draggable = Color3.fromRGB(15, 15, 15), true, true

Title.Size, Title.Text, Title.TextColor3 = UDim2.new(1, 0, 0, 30), "BANANUE HUB V2", Color3.new(1, 0.8, 0)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

ToggleBtn.Size, ToggleBtn.Position, ToggleBtn.Text = UDim2.new(0.8, 0, 0, 35), UDim2.new(0.1, 0, 0.2, 0), "SYSTEM: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

SpeedInput.Size, SpeedInput.Position, SpeedInput.Text = UDim2.new(0.45, 0, 0, 30), UDim2.new(0.1, 0, 0.4, 0), "60"
SetSpeedBtn.Size, SetSpeedBtn.Position, SetSpeedBtn.Text = UDim2.new(0.3, 0, 0, 30), UDim2.new(0.6, 0, 0.4, 0), "SET"

TpEndBtn.Size, TpEndBtn.Position, TpEndBtn.Text = UDim2.new(0.8, 0, 0, 30), UDim2.new(0.1, 0, 0.6, 0), "TP TO END"
TpEndBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 150)

HideBtn.Size, HideBtn.Position, HideBtn.Text = UDim2.new(0.8, 0, 0, 30), UDim2.new(0.1, 0, 0.8, 0), "HIDE/SHOW"

-- Переменные
_G.AutoFarm, _G.MaxSpeed = false, 60
local IgnoredBonds, fixedRotation = {}, nil

-- Функции кнопок
SetSpeedBtn.MouseButton1Click:Connect(function() _G.MaxSpeed = tonumber(SpeedInput.Text) or 60 end)
HideBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
TpEndBtn.MouseButton1Click:Connect(function() p.Character.HumanoidRootPart.CFrame = CFrame.new(-161, 28, -49041) end)

ToggleBtn.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    if _G.AutoFarm and p.Character then fixedRotation = p.Character.HumanoidRootPart.CFrame.Rotation end
    ToggleBtn.Text = _G.AutoFarm and "SYSTEM: ACTIVE" or "SYSTEM: OFF"
    ToggleBtn.BackgroundColor3 = _G.AutoFarm and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

-- NoClip
game:GetService("RunService").Stepped:Connect(function()
    if _G.AutoFarm and p.Character then
        for _, v in pairs(p.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

-- Основной цикл фарма
spawn(function()
    while true do
        if _G.AutoFarm then
            pcall(function()
                local char = p.Character or p.CharacterAdded:Wait()
                local root = char:WaitForChild("HumanoidRootPart")
                if not fixedRotation then fixedRotation = root.CFrame.Rotation end
                
                local target = nil
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("bond") and not IgnoredBonds[v] then
                        local t = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart", true)
                        if t and (root.Position - t.Position).Magnitude < 400 then target = t break end
                    end
                end
                
                if target then
                    local railPos = root.Position
                    IgnoredBonds[target] = true
                    local start = tick()
                    while tick() - start < 3 do
                        root.CFrame = CFrame.new(target.Position + Vector3.new(0, 0, 3), target.Position)
                        cam.CFrame = CFrame.lookAt(cam.CFrame.Position, target.Position)
                        
                        vim:SendMouseButtonEvent(cam.ViewportSize.X/2, cam.ViewportSize.Y/2, 0, true, game, 1)
                        task.wait(0.17)
                        vim:SendMouseButtonEvent(cam.ViewportSize.X/2, cam.ViewportSize.Y/2, 0, false, game, 1)
                        task.wait(0.18)
                        
                        firetouchinterest(root, target, 0)
                        if target.Parent:FindFirstChildWhichIsA("ProximityPrompt") then fireproximityprompt(target.Parent:FindFirstChildWhichIsA("ProximityPrompt")) end
                    end
                    root.CFrame = CFrame.new(railPos) * fixedRotation
                else
                    root.CFrame = CFrame.new(root.Position) * fixedRotation * CFrame.new(0, 0, -(_G.MaxSpeed / 10))
                end

                for _, g in pairs(p.PlayerGui:GetChildren()) do
                    for _, b in pairs(g:GetDescendants()) do
                        if b:IsA("TextButton") and b.Visible and b.Name:lower():find("collect") then b:Activate() end
                    end
                end
            end)
        end
        task.wait(0.01)
    end
end)

print("Bananue Hub Loaded!")
