local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local mouse = lp:GetMouse()

_G.BananueSettings = _G.BananueSettings or {}
_G.BananueConnections = _G.BananueConnections or {}

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Bananue_Ultra_Core_" .. math.random(100, 999)
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 600, 0, 500)
Main.Position = UDim2.new(0.5, -300, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Shadow = Instance.new("ImageLabel", Main)
Shadow.Size = UDim2.new(1, 40, 1, 40)
Shadow.Position = UDim2.new(0, -20, 0, -20)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.5

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", TopBar)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "★ BANANUE HUB V6.0 | МОДУЛЬ: CORE ★"
Title.TextColor3 = Color3.fromRGB(255, 200, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton", TopBar)
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Position = UDim2.new(1, -42, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Close.Text = "X"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.Font = Enum.Font.GothamBold
Instance.new("UICorner", Close)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -10, 1, -60)
Scroll.Position = UDim2.new(0, 5, 0, 55)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 8000)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
local List = Instance.new("UIListLayout", Scroll)
List.Padding = UDim.new(0, 5)

UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.Minus then
        Main.Visible = not Main.Visible
    end
end)

local function AddMod(name, key, cat, func)
    _G.BananueSettings[key] = false
    local b = Instance.new("TextButton", Scroll)
    b.Size = UDim2.new(0.97, 0, 0, 42)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.Text = "  ["..cat.."] "..name.." : ВЫКЛ"
    b.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    b.Font = Enum.Font.GothamSemibold
    b.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", b)

    b.MouseButton1Click:Connect(function()
        _G.BananueSettings[key] = not _G.BananueSettings[key]
        b.Text = "  ["..cat.."] "..name..(_G.BananueSettings[key] and " : ВКЛ" or " : ВЫКЛ")
        b.BackgroundColor3 = _G.BananueSettings[key] and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(25, 25, 25)
        if func then func(_G.BananueSettings[key]) end
    end)
end

AddMod("Ультра Скорость (Velocity)", "m_speed", "PLAYER", function(v)
    if v then
        _G.BananueConnections["Speed"] = RunService.Heartbeat:Connect(function()
            if lp.Character and lp.Character:FindFirstChild("Humanoid") then
                lp.Character.Humanoid.WalkSpeed = 100
            end
        end)
    else
        if _G.BananueConnections["Speed"] then _G.BananueConnections["Speed"]:Disconnect() end
        lp.Character.Humanoid.WalkSpeed = 16
    end
end)

AddMod("Мгновенный Прыжок (Power)", "m_jump", "PLAYER", function(v)
    lp.Character.Humanoid.JumpPower = v and 150 or 50
end)

AddMod("Полет через CFrame", "m_fly", "PLAYER")
AddMod("Проход через стены (NoClip)", "m_noclip", "PLAYER")
AddMod("Бесконечный Прыжок", "m_infjump", "PLAYER")
AddMod("Режим Бога (LocalGod)", "m_god", "PLAYER")
AddMod("Спинбот (Rage)", "m_spin", "PLAYER")
AddMod("Авто-Кликер (1ms)", "m_click", "PLAYER")
AddMod("Невидимость (Flicker)", "m_invis", "PLAYER")
AddMod("Анти-Толчок (Velocity)", "m_antiknock", "PLAYER")
local ESP_Folder = Instance.new("Folder", CoreGui)
ESP_Folder.Name = "B_ESP_Storage"

local function CreateESP(target)
    if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local Highlight = Instance.new("Highlight", ESP_Folder)
        Highlight.Adornee = target.Character
        Highlight.FillColor = Color3.fromRGB(255, 0, 0)
        Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        Highlight.FillTransparency = 0.5
        Highlight.OutlineTransparency = 0
        
        local Bill = Instance.new("BillboardGui", ESP_Folder)
        Bill.Adornee = target.Character.HumanoidRootPart
        Bill.Size = UDim2.new(0, 100, 0, 50)
        Bill.AlwaysOnTop = true
        Bill.StudsOffset = Vector3.new(0, 3, 0)
        
        local NameTag = Instance.new("TextLabel", Bill)
        NameTag.Size = UDim2.new(1, 0, 1, 0)
        NameTag.BackgroundTransparency = 1
        NameTag.Text = target.Name .. " [" .. math.floor(target.Character.Humanoid.Health) .. " HP]"
        NameTag.TextColor3 = Color3.new(1, 1, 1)
        NameTag.Font = Enum.Font.GothamBold
        NameTag.TextSize = 14
        
        RunService.RenderStepped:Connect(function()
            if _G.BananueSettings["esp_box"] and target.Character and target.Character:FindFirstChild("Humanoid") then
                Highlight.Enabled = true
                Bill.Enabled = true
                NameTag.Text = target.Name .. " [" .. math.floor(target.Character.Humanoid.Health) .. " HP]"
            else
                Highlight.Enabled = false
                Bill.Enabled = false
            end
        end)
    end
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= lp then CreateESP(player) end
end

Players.PlayerAdded:Connect(function(v)
    if v ~= lp then CreateESP(v) end
end)

AddMod("ESP Игроки (Box)", "esp_box", "VISUAL")
AddMod("ESP Трейсеры (Lines)", "esp_lines", "VISUAL")
AddMod("ESP Имена", "esp_names", "VISUAL")
AddMod("ESP Дистанция", "esp_dist", "VISUAL")
AddMod("ESP Скелет", "esp_skel", "VISUAL")
AddMod("Подсветка Предметов", "esp_items", "VISUAL")
AddMod("FullBright (Яркость)", "v_bright", "VISUAL", function(v)
    Lighting.Brightness = v and 3 or 1
    Lighting.ClockTime = v and 14 or Lighting.ClockTime
end)
AddMod("No Fog (Без Тумана)", "v_nofog", "VISUAL", function(v)
    Lighting.FogEnd = v and 100000 or 1000
end)
AddMod("X-Ray стены", "v_xray", "VISUAL")
AddMod("Убрать тени", "v_noshadow", "VISUAL", function(v)
    Lighting.GlobalShadows = not v
end)
AddMod("Радужный интерфейс", "v_rainbow", "VISUAL")
AddMod("Показать хитбоксы", "v_hitbox", "VISUAL")
AddMod("Трейсеры пуль", "v_bullet", "VISUAL")
AddMod("Изменить FOV", "v_fov", "VISUAL", function(v)
    camera.FieldOfView = v and 120 or 70
end)
AddMod("Зум мод", "v_zoom", "VISUAL")
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.Func31 then
            local f = p.Character:FindFirstChildOfClass("Tool")
            if f and f:FindFirstChild("Battery") then
                f.Battery.Value = 100
                if f:FindFirstChild("Light") then f.Light.Range = 100 f.Light.Brightness = 10 end
            end
        end
    end
end)
task.spawn(function()
    while task.wait(1) do
        if _G.Settings.Func32 then
            local e = workspace:FindFirstChild("Engine") or workspace:FindFirstChild("Train")
            if e and e:FindFirstChild("Fuel") then
                local fuel = workspace:FindFirstChild("FuelCanister") or workspace:FindFirstChild("Coal")
                if fuel then
                    p.Character.HumanoidRootPart.CFrame = fuel.CFrame
                    fireclickdetector(fuel:FindFirstChildOfClass("ClickDetector"))
                    task.wait(0.2)
                    p.Character.HumanoidRootPart.CFrame = e.PrimaryPart.CFrame
                end
            end
        end
    end
end)
RunService.RenderStepped:Connect(function()
    if _G.Settings.Func33 then
        local l = game:GetService("Lighting")
        l.ClockTime = 12
        l.FogEnd = 9e9
        l.GlobalShadows = false
        l.OutdoorAmbient = Color3.new(1,1,1)
    end
end)
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.Func34 then
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name:find("Ammo") or v.Name:find("Bullet") or v.Name:find("Shell") then
                    if v:IsA("BasePart") and v:FindFirstChildOfClass("ClickDetector") then
                        p.Character.HumanoidRootPart.CFrame = v.CFrame
                        fireclickdetector(v:FindFirstChildOfClass("ClickDetector"))
                    end
                end
            end
        end
    end
end)
task.spawn(function()
    while task.wait(0.1) do
        if _G.Settings.Func35 then
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(45), 0)
            end
        end
    end
end)
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.Func1 then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ClickDetector") and v.Parent:IsA("BasePart") then
                    local n = v.Parent.Name
                    if n:find("Coal") or n:find("Fuel") or n:find("Log") or n:find("Scrap") then
                        if (p.Character.HumanoidRootPart.Position - v.Parent.Position).Magnitude < 60 then
                            fireclickdetector(v)
                        end
                    end
                end
            end
        end
    end
end)
task.spawn(function()
    while task.wait(0.1) do
        if _G.Settings.Func2 then
            for _, v in pairs(workspace:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v.Name:find("Zombie") then
                    local d = (p.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                    if d < 25 then
                        p.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                        local t = p.Character:FindFirstChildOfClass("Tool")
                        if t then t:Activate() end
                    end
                end
            end
        end
    end
end)
task.spawn(function()
    while task.wait(1) do
        if _G.Settings.Func3 then
            local b = workspace:FindFirstChild("Bank") or workspace:FindFirstChild("Vault")
            if b then
                for _, z in pairs(workspace:GetChildren()) do
                    if z.Name == "Banker Zombie" and z:FindFirstChild("Bank Note") then
                        p.Character.HumanoidRootPart.CFrame = z.HumanoidRootPart.CFrame
                        task.wait(0.3)
                    end
                end
            end
        end
    end
end)
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.Func4 then
            local t = workspace:FindFirstChild("Train") or workspace:FindFirstChild("Engine")
            if t and t:FindFirstChild("PrimaryPart") then
                if (p.Character.HumanoidRootPart.Position - t.PrimaryPart.Position).Magnitude > 50 then
                    p.Character.HumanoidRootPart.CFrame = t.PrimaryPart.CFrame * CFrame.new(0, 5, 0)
                end
            end
        end
    end
end)
RunService.Heartbeat:Connect(function()
    if _G.Settings.Func5 then
        local l = game:GetService("Lighting")
        l.Brightness = 3
        l.ClockTime = 12
        l.FogEnd = 1e5
        l.OutdoorAmbient = Color3.new(1, 1, 1)
        for _, v in pairs(l:GetChildren()) do
            if v:IsA("Atmosphere") or v.Name == "Darkness" then v.Parent = nil end
        end
    end
end)
task.spawn(function()
    while task.wait(0.1) do
        if _G.Settings.Func6 then
            local t = workspace:FindFirstChild("Train") or workspace:FindFirstChild("Engine")
            if t then
                for _, v in pairs(t:GetDescendants()) do
                    if v.Name == "Health" and v.Value < 100 then
                        p.Character.HumanoidRootPart.CFrame = v.Parent.CFrame * CFrame.new(0, 3, 0)
                        local h = p.Backpack:FindFirstChild("Hammer") or p.Character:FindFirstChild("Hammer")
                        if h then p.Character.Humanoid:EquipTool(h) h:Activate() end
                    end
                end
            end
        end
    end
end)
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.Func7 then
            local f = p.Character:FindFirstChildOfClass("Tool")
            if f and (f.Name:find("Flashlight") or f:FindFirstChild("Battery")) then
                if f:FindFirstChild("Battery") then f.Battery.Value = 100 end
                if f:FindFirstChild("Light") then f.Light.Range = 150 f.Light.Brightness = 20 end
            end
        end
    end
end)
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.Func8 then
            for _, v in pairs(workspace:GetDescendants()) do
                if (v.Name:find("Ammo") or v.Name:find("Bullet") or v.Name:find("Shell")) and v:IsA("BasePart") then
                    if v:FindFirstChildOfClass("ClickDetector") then
                        p.Character.HumanoidRootPart.CFrame = v.CFrame
                        fireclickdetector(v:FindFirstChildOfClass("ClickDetector"))
                    end
                end
            end
        end
    end
end)
task.spawn(function()
    while task.wait(0.1) do
        if _G.Settings.Func9 then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ClickDetector") and (p.Character.HumanoidRootPart.Position - v.Parent.Position).Magnitude < 25 then
                    fireclickdetector(v)
                end
            end
        end
    end
end)
task.spawn(function()
    while task.wait(0.1) do
        if _G.Settings.Func10 then
            local r = workspace:FindFirstChild("Rails") or workspace:FindFirstChild("Track")
            if r then
                for _, v in pairs(r:GetChildren()) do
                    if v:IsA("BasePart") and v.Transparency > 0 then
                        p.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 2, 0)
                        local m = p.Backpack:FindFirstChild("Hammer") or p.Character:FindFirstChild("Hammer")
                        if m then p.Character.Humanoid:EquipTool(m) m:Activate() end
                    end
                end
            end
        end
    end
end)
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.Func11 then
            for _, v in pairs(workspace:GetDescendants()) do
                if (v.Name:find("Gold") or v.Name:find("Money") or v.Name:find("Cash") or v.Name:find("Coin")) and v:IsA("BasePart") then
                    local c = v:FindFirstChildOfClass("ClickDetector")
                    if c then p.Character.HumanoidRootPart.CFrame = v.CFrame fireclickdetector(c) end
                end
            end
        end
    end
end)
RunService.RenderStepped:Connect(function()
    if _G.Settings.Func12 then
        for _, v in pairs(workspace:GetDescendants()) do
            if (v.Name == "Scrap" or v.Name == "Coal" or v.Name == "Steel") and v:IsA("BasePart") then
                if not v:FindFirstChild("E_ESP") then
                    local h = Instance.new("BoxHandleAdornment", v)
                    h.Name = "E_ESP" h.Adornee = v h.AlwaysOnTop = true h.ZIndex = 10
                    h.Size = v.Size h.Transparency = 0.5 h.Color3 = Color3.new(0, 1, 0)
                end
            end
        end
    end
end)
task.spawn(function()
    while task.wait(0.1) do
        if _G.Settings.Func13 and p.Character:FindFirstChild("Humanoid") then
            local h = p.Character.Humanoid
            h.WalkSpeed = 35
            if h:FindFirstChild("Stamina") then h.Stamina.Value = 100 end
            if h:GetState() == Enum.HumanoidStateType.Jumping then h:ChangeState(Enum.HumanoidStateType.Flying) end
        end
    end
end)
task.spawn(function()
    while task.wait(1) do
        if _G.Settings.Func14 then
            local s = workspace:FindFirstChild("Shop") or workspace:FindFirstChild("Vending")
            if s then
                local d = s:FindFirstChild("AmmoBox") or s:FindFirstChild("BuyAmmo")
                if d and d:FindFirstChildOfClass("ClickDetector") then
                    p.Character.HumanoidRootPart.CFrame = d.CFrame
                    fireclickdetector(d:FindFirstChildOfClass("ClickDetector"))
                end
            end
        end
    end
end)
task.spawn(function()
    while task.wait(0.1) do
        if _G.Settings.Func15 then
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name ~= p.Name then
                    local h = v.Humanoid
                    if h.Health > 0 and (v.PrimaryPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < 50 then
                        local b = Instance.new("Beam", p.Character.HumanoidRootPart)
                        local a1 = Instance.new("Attachment", p.Character.HumanoidRootPart)
                        local a2 = Instance.new("Attachment", v.PrimaryPart)
                        b.Attachment0 = a1 b.Attachment1 = a2 b.Color = ColorSequence.new(Color3.new(1,0,0))
                        b.Width0 = 0.2 b.Width1 = 0.2 task.wait(0.1) b:Destroy() a1:Destroy() a2:Destroy()
                    end
                end
            end
        end
    end
end)
if _G.Settings.Func16 then p.Character.Humanoid.JumpPower = 100 end
if _G.Settings.Func17 then p.Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0) end
if _G.Settings.Func18 then for _, v in pairs(workspace:GetDescendants()) do if v.Name == "Part" and v.Transparency == 1 then v.CanCollide = true v.Transparency = 0.8 end end end
if _G.Settings.Func19 then workspace.CurrentCamera.FieldOfView = 120 end
if _G.Settings.Func20 then p.Character.Humanoid.HipHeight = 3 end
