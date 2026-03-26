local p = game.Players.LocalPlayer
local cam, vim = workspace.CurrentCamera, game:GetService("VirtualInputManager")
local lighting = game:GetService("Lighting")

local ScreenGui = p:WaitForChild("PlayerGui"):FindFirstChild("BananueGui") or Instance.new("ScreenGui", p.PlayerGui)
ScreenGui.Name = "BananueGui"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size, MainFrame.Position = UDim2.new(0, 250, 0, 210), UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3, MainFrame.Active, MainFrame.Draggable = Color3.fromRGB(20, 20, 20), true, true

local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size, ToggleBtn.Position, ToggleBtn.Text = UDim2.new(0.9, 0, 0, 45), UDim2.new(0.05, 0, 0.05, 0), "START FARM"
ToggleBtn.BackgroundColor3, ToggleBtn.TextColor3 = Color3.fromRGB(150, 0, 0), Color3.new(1, 1, 1)

local SpeedInput = Instance.new("TextBox", MainFrame)
SpeedInput.Size, SpeedInput.Position, SpeedInput.Text = UDim2.new(0.9, 0, 0, 40), UDim2.new(0.05, 0, 0.30, 0), "80"
SpeedInput.BackgroundColor3, SpeedInput.TextColor3 = Color3.fromRGB(40, 40, 40), Color3.new(1, 1, 1)

local EndBtn = Instance.new("TextButton", MainFrame)
EndBtn.Size, EndBtn.Position, EndBtn.Text = UDim2.new(0.9, 0, 0, 45), UDim2.new(0.05, 0, 0.55, 0), "TP TO END"
EndBtn.BackgroundColor3, EndBtn.TextColor3 = Color3.fromRGB(50, 50, 150), Color3.new(1, 1, 1)

_G.AutoFarm, _G.MaxSpeed = false, 80
local Ignored, currentPoint = {}, 1
local Waypoints = {
    Vector3.new(-727, 5, 21936), Vector3.new(-208, 10, 22003),
    Vector3.new(-727, 5, 21936), Vector3.new(-208, 10, 22003),
    Vector3.new(135, 11, 13885), Vector3.new(-928, 12, 14113),
    Vector3.new(-344, 17, 6059), Vector3.new(710, 21, 6180),
    Vector3.new(-452, 12, -17760), Vector3.new(454, 23, -17619),
    Vector3.new(-56, 11, -25700), Vector3.new(-863, 14, -25654),
    Vector3.new(758, 21, -33685), Vector3.new(-585, 24, -33522)
}

local function fullBright()
    lighting.Brightness = 2
    lighting.ClockTime = 14
    lighting.FogEnd = 100000
    lighting.GlobalShadows = false
    lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end

local function clearFloor()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("floor") or v.Name:lower():find("ground") or v.Name:lower():find("plate")) then
            pcall(function() v:Destroy() end)
        end
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    _G.MaxSpeed = tonumber(SpeedInput.Text) or 80
    if _G.AutoFarm then 
        clearFloor() 
        fullBright()
    end
    ToggleBtn.Text = _G.AutoFarm and "FARMING..." or "START FARM"
    ToggleBtn.BackgroundColor3 = _G.AutoFarm and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

EndBtn.MouseButton1Click:Connect(function()
    _G.AutoFarm = false
    ToggleBtn.Text, ToggleBtn.BackgroundColor3 = "START FARM", Color3.fromRGB(150, 0, 0)
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        p.Character.HumanoidRootPart.CFrame = CFrame.new(-161, 27, -49041)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.05)
        if _G.AutoFarm and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local root = p.Character.HumanoidRootPart
            local target = nil
            local all = workspace:GetDescendants()
            
            for i = 1, #all do
                local v = all[i]
                if v.Name:lower():find("bond") and not Ignored[v] then
                    local t = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart", true)
                    if t and (root.Position - t.Position).Magnitude < 550 then 
                        target = t 
                        break 
                    end
                end
            end

            if target then
                Ignored[target] = true
                root.Velocity = Vector3.new(0,0,0)
                root.CFrame = CFrame.new(target.Position - Vector3.new(0, 1.5, 0))
                cam.CFrame = CFrame.lookAt(cam.CFrame.Position, target.Position)
                task.wait(0.1)
                local pr = target.Parent:FindFirstChildWhichIsA("ProximityPrompt") or target:FindFirstChildWhichIsA("ProximityPrompt")
                if pr then 
                    pr.RequiresLineOfSight = false
                    fireproximityprompt(pr) 
                end
                vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.3)
                vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                task.wait(0.2)
            else
                if next(Ignored) ~= nil then Ignored = {} end
                local goal = Waypoints[currentPoint]
                if (root.Position - goal).Magnitude < 30 then
                    currentPoint = (currentPoint % #Waypoints) + 1
                else
                    root.Velocity = Vector3.new(0,0,0)
                    local direction = (goal - root.Position).Unit
                    root.CFrame = CFrame.new(root.Position + direction * (_G.MaxSpeed / 20), goal)
                end
            end
            for _, v in pairs(p.Character:GetDescendants()) do 
                if v:IsA("BasePart") then v.CanCollide = false end 
            end
        end
    end
end)
