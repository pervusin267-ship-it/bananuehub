local UIS = game:GetService("UserInputService")
local p = game.Players.LocalPlayer
local sg = Instance.new("ScreenGui", p.PlayerGui)
sg.Name = "FexawV3"
sg.ResetOnSpawn = false

_G.CurrentIndex = 500
_G.MaxIndex = 4000
_G.FarmActive = false

local main = Instance.new("Frame", sg)
main.Size, main.Position = UDim2.new(0, 520, 0, 340), UDim2.new(0.5, -260, 0.5, -170)
main.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
main.Visible = false
Instance.new("UICorner", main)

local side = Instance.new("Frame", main)
side.Size, side.BackgroundColor3 = UDim2.new(0, 160, 1, 0), Color3.fromRGB(0, 50, 150)
Instance.new("UICorner", side)

local container = Instance.new("Frame", main)
container.Position, container.Size, container.BackgroundTransparency = UDim2.new(0, 170, 0, 10), UDim2.new(1, -180, 1, -20), 1

local pages = {}
local function CreatePage(name)
    local f = Instance.new("ScrollingFrame", container)
    f.Size, f.BackgroundTransparency, f.Visible, f.ScrollBarThickness = UDim2.new(1, 0, 1, 0), 1, false, 0
    Instance.new("UIListLayout", f).Padding = UDim.new(0, 8)
    pages[name] = f
    return f
end

local mP, pP = CreatePage("Main"), CreatePage("Premium")
mP.Visible = true

local ob = Instance.new("Frame", sg)
ob.Size, ob.Position = UDim2.new(0, 350, 0, 40), UDim2.new(0.5, -175, 0, 5)
ob.BackgroundColor3, ob.BackgroundTransparency = Color3.new(0,0,0), 0.4
Instance.new("UICorner", ob)

local obT = Instance.new("TextButton", ob)
obT.Size, obT.Position, obT.BackgroundTransparency = UDim2.new(1, -40, 1, 0), UDim2.new(0, 40, 0, 0), 1
obT.Text, obT.TextColor3 = "FEXAW | ID: 500", Color3.new(1, 1, 1)

local function AddTab(name, target, order)
    local b = Instance.new("TextButton", side)
    b.Size, b.Position = UDim2.new(1, -20, 0, 35), UDim2.new(0, 10, 0, 70 + (order * 40))
    b.BackgroundColor3, b.BackgroundTransparency = Color3.new(0,0,0), 0.5
    b.Text, b.TextColor3 = name, Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(pages) do v.Visible = false end
        target.Visible = true
    end)
end

AddTab("Main", mP, 0)
AddTab("Premium", pP, 1)

local function AddToggle(parent, name, callback)
    local enabled = false
    local b = Instance.new("TextButton", parent)
    b.Size, b.BackgroundColor3 = UDim2.new(1, -5, 0, 40), Color3.fromRGB(0, 50, 150)
    b.Text, b.TextColor3 = name .. ": OFF", Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        enabled = not enabled
        b.Text = name .. (enabled and ": ON" or ": OFF")
        b.BackgroundColor3 = enabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(0, 50, 150)
        callback(enabled)
    end)
end

AddToggle(pP, "ULTRA ACTION (250/s)", function(v)
    _G.FarmActive = v
    if _G.FarmActive then
        task.spawn(function()
            local rem = game:GetService("ReplicatedStorage").Shared.Universe.Network.RemoteEvent.Actionable
            while _G.FarmActive do
                for i = _G.CurrentIndex, _G.MaxIndex do
                    if not _G.FarmActive then 
                        _G.CurrentIndex = i
                        break 
                    end
                    obT.Text = "FEXAW | ID: " .. i
                    pcall(function() rem:FireServer(i) end)
                    
                    if i % 250 == 0 then 
                        task.wait(1) 
                    else 
                        task.wait(1/4000) 
                    end
                end
                if _G.CurrentIndex >= _G.MaxIndex then _G.CurrentIndex = 1 end
                task.wait(0.1)
            end
        end)
    end
end)

AddToggle(mP, "Anti-AFK", function(v)
    _G.A = v
    task.spawn(function()
        while _G.A do
            task.wait(15)
            if p.Character and p.Character:FindFirstChild("Humanoid") then p.Character.Humanoid:ChangeState(3) end
        end
    end)
end)

local ot = Instance.new("TextButton", ob)
ot.Size, ot.BackgroundTransparency, ot.Text, ot.TextColor3, ot.TextSize = UDim2.new(0, 40, 1, 0), 1, "÷", Color3.new(1, 1, 1), 25
local function toggle() main.Visible = not main.Visible end
ot.MouseButton1Click:Connect(toggle)
obT.MouseButton1Click:Connect(toggle)
