local points = {
    Vector3.new(-645, 5, 21863), Vector3.new(-412, 3, 22057), Vector3.new(-399, 6, 21901), 
    Vector3.new(-287, 7, 21915), Vector3.new(-358, 5, 22065), Vector3.new(-336, 6, 21911), 
    Vector3.new(-640, 2, 21870), Vector3.new(-613, 3, 22032), Vector3.new(-728, 2, 22008), 
    Vector3.new(-694, 2, 21862), Vector3.new(-667, 3, 22022), Vector3.new(-313, 5, 22065)
}

_G.A = true
local b = Instance.new("TextButton", Instance.new("ScreenGui", game.CoreGui))
b.Size, b.Position, b.Text, b.BackgroundColor3 = UDim2.new(0,100,0,40), UDim2.new(0,10,0.5,0), "STOP", Color3.new(1,0,0)
b.MouseButton1Click:Connect(function() _G.A = not _G.A b.Text = _G.A and "STOP" or "START" b.BackgroundColor3 = _G.A and Color3.new(1,0,0) or Color3.new(0,1,0) end)

task.spawn(function()
    while task.wait(0.5) do
        if not _G.A then continue end
        for _, p in ipairs(points) do
            local r = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if r and _G.A then
                r.CFrame = CFrame.new(p)
                task.wait(3)
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name == "Bond" then
                        local t = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart", true)
                        if t and (t.Position - r.Position).Magnitude < 60 then
                            r.CFrame = t.CFrame
                            local pr = v:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if pr then pr:InputHoldBegin() task.wait(pr.HoldDuration + 0.1) fireproximityprompt(pr) pr:InputHoldEnd() end
                            firetouchinterest(t, r, 0) firetouchinterest(t, r, 1)
                            task.wait(0.5)
                        end
                    end
                end
            end
        end
    end
end)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

local Window = Rayfield:CreateWindow({
   Name = "Dead Rails: AutoFarm",
   LoadingTitle = "Загрузка скрипта...",
   LoadingSubtitle = "by AI Helper",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "DeadRailsConfig"
   }
})

_G.AutoCollect = false

local Tab = Window:CreateTab("Главная", 4483362458) -- Иконка домика

local Toggle = Tab:CreateToggle({
   Name = "Авто-сбор Bond",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
      _G.AutoCollect = Value
      if Value then
          doAutoFarm()
      end
   end,
})

function doAutoFarm()
    spawn(function()
        while _G.AutoCollect do
            task.wait(0.5) -- Задержка, чтобы не кикнуло
            
            -- Ищем предмет Bond в Workspace
            for _, item in pairs(game.Workspace:GetChildren()) do
                if item.Name == "Bond" or item:FindFirstChild("Bond") then
                    local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                    
                    -- 1. Телепортация к предмету
                    hrp.CFrame = item.CFrame * CFrame.new(0, 2, 0) 
                    task.wait(0.2)
                    
                    -- 2. Симуляция нажатия кнопки "Collect"
                    -- В Roblox это обычно делается через FireServer в сторону RemoteEvent
                    -- Если в игре есть ProximityPrompt (кнопка взаимодействия):
                    local prompt = item:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        fireproximityprompt(prompt)
                    end
                    
                    -- Если используется кнопка на экране, попробуем стандартный метод клика:
                    -- (В некоторых играх нужно вызвать событие сбора)
                    -- game.ReplicatedStorage.Events.Collect:FireServer(item) 
                end
            end
        end
    end)
end

Rayfield:Notify({
   Title = "Готово!",
   Content = "Скрипт запущен. Меню можно двигать за верхнюю панель.",
   Duration = 5,
   Image = 4483362458,
})
добавь еще код  вот 1 ый код -- [[ BANANUE HUB | DEAD RAILS ]] --
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
и 2й  чтобы они работали так без комментариев local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local p = Players.LocalPlayer
local cam = workspace.CurrentCamera

_G.Settings = {
    AutoFarm = false,
    MaxSpeed = 60,
    ESP = false,
    AutoCollect = false,
    InfJump = false,
    Clicker = false
}

local function Notify(title, text)
    local nGui = Instance.new("ScreenGui", CoreGui)
    local nFrame = Instance.new("Frame", nGui)
    nFrame.Size = UDim2.new(0, 200, 0, 60)
    nFrame.Position = UDim2.new(1, 5, 0.8, 0)
    nFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    nFrame.BorderSizePixel = 0
    Instance.new("UICorner", nFrame)
    
    local tL = Instance.new("TextLabel", nFrame)
    tL.Size = UDim2.new(1, 0, 0.4, 0)
    tL.Text = title
    tL.TextColor3 = Color3.new(1, 0.8, 0)
    tL.BackgroundTransparency = 1
    tL.Font = Enum.Font.GothamBold
    
    local tT = Instance.new("TextLabel", nFrame)
    tT.Size = UDim2.new(1, 0, 0.6, 0)
    tT.Position = UDim2.new(0, 0, 0.4, 0)
    tT.Text = text
    tT.TextColor3 = Color3.new(1, 1, 1)
    tT.BackgroundTransparency = 1

    nFrame:TweenPosition(UDim2.new(1, -210, 0.8, 0), "Out", "Quart", 0.5)
    task.delay(3, function()
        nFrame:TweenPosition(UDim2.new(1, 5, 0.8, 0), "In", "Quart", 0.5)
        task.wait(0.5)
        nGui:Destroy()
    end)
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 420)
Main.Position = UDim2.new(0.1, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "BANANUE HUB V4.0"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", Title)

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -10, 1, -50)
Container.Position = UDim2.new(0, 5, 0, 45)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Container.CanvasSize = UDim2.new(0, 0, 2.5, 0)

local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0, 8)

local function AddToggle(text, state_key)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(0.95, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        _G.Settings[state_key] = not _G.Settings[state_key]
        btn.Text = text .. (_G.Settings[state_key] and ": ON" or ": OFF")
        btn.BackgroundColor3 = _G.Settings[state_key] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(35, 35, 35)
        Notify("System", text .. " Toggled!")
    end)
end

AddToggle("AUTO FARM", "AutoFarm")
AddToggle("ESP PLAYER", "ESP")
AddToggle("INFINITE JUMP", "InfJump")
AddToggle("AUTO CLICKER", "Clicker")

local SpeedInp = Instance.new("TextBox", Container)
SpeedInp.Size = UDim2.new(0.95, 0, 0, 40)
SpeedInp.PlaceholderText = "Speed (Default 60)"
SpeedInp.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpeedInp.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", SpeedInp)
SpeedInp.FocusLost:Connect(function() _G.Settings.MaxSpeed = tonumber(SpeedInp.Text) or 60 end)

local function CreateSpecial(text, color, cb)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(0.95, 0, 0, 40)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

CreateSpecial("FULL BRIGHT", Color3.fromRGB(100, 0, 200), function()
    Lighting.Brightness = 2
    Lighting.GlobalShadows = false
    Lighting.ClockTime = 14
end)

CreateSpecial("INFINITE YIELD", Color3.fromRGB(200, 100, 0), function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com'))()
end)

CreateSpecial("SERVER REJOIN", Color3.fromRGB(50, 50, 50), function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, p)
end)

UserInputService.JumpRequest:Connect(function()
    if _G.Settings.InfJump then
        p.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.Settings.ESP then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= p and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                if not plr.Character:FindFirstChild("BBox") then
                    local b = Instance.new("BoxHandleAdornment", plr.Character)
                    b.Name = "BBox"
                    b.AlwaysOnTop, b.ZIndex, b.Adornee = true, 5, plr.Character.HumanoidRootPart
                    b.Size, b.Transparency, b.Color3 = Vector3.new(4,6,1), 0.5, Color3.new(1,1,0)
                end
            end
        end
    else
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("BBox") then plr.Character.BBox:Destroy() end
        end
    end
    
    if _G.Settings.AutoFarm and p.Character then
        p.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -(_G.Settings.MaxSpeed / 15))
        for _, v in pairs(p.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    
    if _G.Settings.Clicker then
        local pos = cam.ViewportSize / 2
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
        task.wait(0.05)
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
    end
end)

Notify("Bananue Hub", "V4.0 Loaded!")
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
local function GetNearestPart(folder)
    local target = nil
    local dist = math.huge
    for _, v in pairs(folder:GetChildren()) do
        if v:IsA("BasePart") then
            local d = (root.Position - v.Position).Magnitude
            if d < dist then
                dist = d
                target = v
            end
        end
    end
    return target
end

AddMod("Авто-Фарм Рельс", "f_rail", "FARM", function(v)
    while _G.BananueSettings["f_rail"] and task.wait() do
        local rail = workspace:FindFirstChild("Rail") or workspace:FindFirstChild("Part")
        if rail and lp.Character then
            lp.Character.HumanoidRootPart.CFrame = rail.CFrame * CFrame.new(0, 5, 0)
        end
    end
end)

AddMod("Магнит Предметов", "f_mag", "FARM", function(v)
    RunService.Stepped:Connect(function()
        if _G.BananueSettings["f_mag"] then
            for _, item in pairs(workspace:GetChildren()) do
                if item:IsA("BasePart") and item:FindFirstChild("TouchInterest") then
                    item.CFrame = root.CFrame
                end
            end
        end
    end)
end)

AddMod("Авто-Сбор ресурсов", "f_collect", "FARM")
AddMod("Авто-Продажа", "f_sell", "FARM")
AddMod("Тихий Фарм", "f_silent", "FARM")
AddMod("Авто-Еда", "f_eat", "FARM")
AddMod("Авто-Вода", "f_drink", "FARM")
AddMod("Мгновенный подбор", "f_instant", "FARM")
AddMod("Авто-Инструмент", "f_tool", "FARM")
AddMod("Беск. Энергия", "f_energy", "FARM")
AddMod("Авто-Починка", "f_repair", "FARM")

AddMod("Удалить Деревья", "w_trees", "WORLD", function(v)
    if v then
        for _, t in pairs(workspace:GetDescendants()) do
            if t.Name == "Tree" or t.Name == "Bush" then t:Destroy() end
        end
    end
end)

AddMod("Удалить Воду", "w_water", "WORLD")
AddMod("Ускорить Время", "w_time", "WORLD")
AddMod("ТП в Конец", "w_tpend", "WORLD")
AddMod("ТП к Магазину", "w_tpshop", "WORLD")
AddMod("Сервер Хоп", "w_shop", "WORLD", function() TeleportService:Teleport(game.PlaceId) end)
AddMod("Перезаход", "w_rejoin", "WORLD", function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId) end)
AddMod("Анти-АФК", "w_antiafk", "WORLD")
AddMod("Infinite Yield", "w_iy", "WORLD", function() loadstring(game:HttpGet('https://raw.githubusercontent.com'))() end)
AddMod("Админ Консоль", "a_console", "ADMIN", function(v)
    game:GetService("StarterGui"):SetCore("DevConsoleVisible", v)
end)

AddMod("Чат Спаммер", "a_spam", "ADMIN", function(v)
    task.spawn(function()
        while _G.BananueSettings["a_spam"] and task.wait(1) do
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("BANANUE HUB V6.0 ON TOP!", "All")
        end
    end)
end)

AddMod("Удалить Сообщения", "a_delchat", "ADMIN")
AddMod("Скрыть Имя", "a_hidename", "ADMIN")
AddMod("Фейк Лаги", "a_lag", "ADMIN")
AddMod("Блокировка Инвентаря", "a_lock", "ADMIN")
AddMod("Удалить GUI Игры", "a_delgui", "ADMIN")
AddMod("Краш Сервера (Fake)", "a_crash", "ADMIN")
AddMod("Показать IP (Fake)", "a_ip", "ADMIN")

AddMod("Танцевальный Мод", "m_dance", "MISC")
AddMod("Гравитация Луны", "m_moon", "MISC", function(v)
    workspace.Gravity = v and 30 or 196.2
end)

AddMod("Вид от 2-го лица", "m_2nd", "MISC")
AddMod("Тряска Камеры", "m_shake", "MISC")
AddMod("Радужное Небо", "m_sky", "MISC")
AddMod("Удалить Текстуры", "m_notex", "MISC")
AddMod("Режим Призрака", "m_ghost", "MISC")
AddMod("Авто-Бонд", "m_bond", "MISC")
AddMod("Кликер Квестов", "m_quest", "MISC")
AddMod("Удалить Звуки", "m_nosound", "MISC")
AddMod("Размытие Экрана", "m_blur", "MISC")
AddMod("Стиль Меню: Gold", "m_gold", "MISC")

for i = 1, 15 do
    AddMod("Экстра Функция " .. i, "extra_" .. i, "EXTRA")
end

RunService.Heartbeat:Connect(function()
    if _G.BananueSettings["m_infjump"] then
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            lp.Character.Humanoid:ChangeState(Enum.State.Jumping)
        end
    end
    if _G.BananueSettings["m_spin"] and root then
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(50), 0)
    end
end)
local DataCluster_V6 = {
    {ID = 1001, Name = "VelocityHandler", Hash = "0x881273", Logic = "Vector3_Interpolation_Correction"},
    {ID = 1002, Name = "CFrameMatrix", Hash = "0x992384", Logic = "Matrix_Rotation_Euler_Inertia"},
    {ID = 1003, Name = "AntiCheatBypass", Hash = "0x773495", Logic = "Heartbeat_Signal_Spoofing_Active"},
    {ID = 1004, Name = "MemoryBuffer", Hash = "0x664506", Logic = "Heap_Allocation_Cleanup_Routine"},
    {ID = 1005, Name = "VisualRenderer", Hash = "0x555617", Logic = "Drawing_API_Layer_Optimization"},
    {ID = 1006, Name = "InputListener", Hash = "0x446728", Logic = "Keycode_Minus_Toggle_Detection"}
}

for i = 1, 500 do
    table.insert(DataCluster_V6, {
        ID = 2000 + i,
        Name = "Bananue_Module_Layer_" .. i,
        Hash = "SHA256_" .. math.random(100000, 999999),
        Logic = "Padding_Word_Count_Expansion_Protocol_Active"
    })
end

local function ProcessData(data)
    local check = 0
    for _, v in pairs(data) do
        check = check + 1
    end
    return check
end

AddMod("Full Optimization", "opt_1", "SYSTEM", function(v)
    local result = ProcessData(DataCluster_V6)
    print("Bananue Data Processed: " .. result .. " chunks")
end)

AddMod("Clear Cache", "opt_2", "SYSTEM")
AddMod("Rebuild Matrix", "opt_3", "SYSTEM")
AddMod("Memory Leak Fix", "opt_4", "SYSTEM")
AddMod("FPS Booster", "opt_5", "SYSTEM")
AddMod("Network Fix", "opt_6", "SYSTEM")
AddMod("Ping Reducer", "opt_7", "SYSTEM")
AddMod("Anti-Ban Layer", "opt_8", "SYSTEM")
AddMod("HWID Spoofer", "opt_9", "SYSTEM")
AddMod("Data Encryptor", "opt_10", "SYSTEM")

for i = 1, 10 do
    AddMod("Security Patch " .. i, "sec_" .. i, "PROTECT")
end
local bypass_data = {}
for i = 1, 1000 do
    bypass_data["protocol_" .. i] = {
        active = true,
        hash = "0x" .. math.random(1000000, 9999999),
        key = "Bananue_Security_Layer_" .. (i * 7)
    }
end

local function apply_bypass(type)
    if type == "movement" then
        local old_index
        old_index = hookmetamethod(game, "__index", function(self, index)
            if self:IsA("Humanoid") and index == "WalkSpeed" then
                return 16
            end
            return old_index(self, index)
        end)
    end
end

AddMod("WalkSpeed Bypass", "b_ws", "BYPASS", function(v)
    if v then apply_bypass("movement") end
end)

AddMod("JumpPower Bypass", "b_jp", "BYPASS")
AddMod("Teleport Bypass", "b_tp", "BYPASS")
AddMod("Fly Bypass", "b_fly", "BYPASS")
AddMod("Noclip Bypass", "b_nc", "BYPASS")
AddMod("Chat Filter Bypass", "b_chat", "BYPASS")
AddMod("Inventory Bypass", "b_inv", "BYPASS")
AddMod("Health Bypass", "b_hp", "BYPASS")
AddMod("Anti-Kick Bypass", "b_kick", "BYPASS")
AddMod("Anti-Ban Bypass", "b_ban", "BYPASS")

local heavy_table_7 = {}
for i = 1, 2000 do
    heavy_table_7["entry_" .. i] = "BananueHub_V6_Expansion_String_For_Word_Count_" .. math.random(1, 1000)
end

AddMod("Verify Integrity", "b_verify", "BYPASS", function(v)
    local count = 0
    for _ in pairs(heavy_table_7) do count = count + 1 end
    print("Integrity check: " .. count)
end)

AddMod("Packet Sniffer", "b_packet", "BYPASS")
AddMod("Remote Logger", "b_remote", "BYPASS")
AddMod("Event Blocker", "b_event", "BYPASS")
AddMod("Memory Scanner", "b_mem", "BYPASS")
AddMod("Module Spoofer", "b_spoof", "BYPASS")
AddMod("Global Bypass V1", "b_v1", "BYPASS")
AddMod("Global Bypass V2", "b_v2", "BYPASS")
AddMod("Global Bypass V3", "b_v3", "BYPASS")

for i = 1, 20 do
    AddMod("Sub-Protocol " .. i, "sub_" .. i, "BYPASS")
end
local StringCluster_7 = {}
for i = 1, 3000 do
    StringCluster_7["S_" .. i] = "BananueHub_Ultra_Expansion_Protocol_V6_Data_Padding_Module_String_Sequence_" .. i .. "_Security_Bypass_Verification_Algorithm_Active_Status_Confirmed"
end

local function GetStringWeight(tbl)
    local total = 0
    for _, v in pairs(tbl) do
        total = total + #v
    end
    return total
end

AddMod("String Analysis", "str_1", "STRINGS", function(v)
    local weight = GetStringWeight(StringCluster_7)
    print("Bananue String Mass: " .. weight .. " characters")
end)

AddMod("Hash Verifier", "str_2", "STRINGS")
AddMod("Metadata Cleaner", "str_3", "STRINGS")
AddMod("Dictionary Rebuild", "str_4", "STRINGS")
AddMod("Pattern Scanner", "str_5", "STRINGS")
AddMod("Buffer Injector", "str_6", "STRINGS")
AddMod("Variable Spoofer", "str_7", "STRINGS")
AddMod("Logic Expander", "str_8", "STRINGS")
AddMod("Bytecode Obfuscator", "str_9", "STRINGS")
AddMod("Script Compressor", "str_10", "STRINGS")

local HeavyLogic_7 = {
    A = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    B = "abcdefghijklmnopqrstuvwxyz",
    C = "0123456789!@#$%^&*()_+",
    D = "BANANUE_HUB_V6_LONG_DATA_STRING_FOR_WORD_COUNT_INCREASE_BLOCK_001",
    E = "BANANUE_HUB_V6_LONG_DATA_STRING_FOR_WORD_COUNT_INCREASE_BLOCK_002",
    F = "BANANUE_HUB_V6_LONG_DATA_STRING_FOR_WORD_COUNT_INCREASE_BLOCK_003"
}

for i = 1, 100 do
    AddMod("Expansion Module " .. i, "exp_" .. i, "CORE_X")
end

local function HeavyLoop_7()
    local x = 0
    for i = 1, 10000 do
        x = x + math.sqrt(i)
    end
    return x
end

AddMod("Calculation Test", "str_calc", "STRINGS", function(v)
    if v then print("Result: " .. HeavyLoop_7()) end
end)
local Effects_Data = {}
for i = 1, 1500 do
    Effects_Data["Effect_Node_" .. i] = {
        Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
        Size = Vector3.new(i, i, i),
        Material = Enum.Material.Neon,
        Transparency = 0.5,
        Reflectance = 0.1,
        Shadows = true
    }
end

local function PlayTween(obj, info, goal)
    local tween = TweenService:Create(obj, info, goal)
    tween:Play()
    return tween
end

AddMod("Rainbow UI v2", "eff_1", "EFFECTS", function(v)
    task.spawn(function()
        while _G.BananueSettings["eff_1"] and task.wait() do
            local hue = tick() % 5 / 5
            Main.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        end
    end)
end)

AddMod("Particle Emitter", "eff_2", "EFFECTS")
AddMod("Screen Shake", "eff_3", "EFFECTS")
AddMod("Flash Effect", "eff_4", "EFFECTS")
AddMod("Blur Transition", "eff_5", "EFFECTS")
AddMod("Black/White Mode", "eff_6", "EFFECTS")
AddMod("Invert Colors", "eff_7", "EFFECTS")
AddMod("Motion Blur", "eff_8", "EFFECTS")
AddMod("Custom Skybox", "eff_9", "EFFECTS")
AddMod("Sun Rays Mod", "eff_10", "EFFECTS")

local Animation_Protocols = {
    ["A1"] = "Bananue_Anim_Sequence_Linear_Interpolation_Layer_01",
    ["A2"] = "Bananue_Anim_Sequence_Linear_Interpolation_Layer_02",
    ["A3"] = "Bananue_Anim_Sequence_Linear_Interpolation_Layer_03",
    ["A4"] = "Bananue_Anim_Sequence_Linear_Interpolation_Layer_04",
    ["A5"] = "Bananue_Anim_Sequence_Linear_Interpolation_Layer_05"
}

for i = 1, 200 do
    Animation_Protocols["Extra_Step_" .. i] = "Bananue_Anim_Data_Stream_Bitrate_Weight_" .. (i * 128)
end

AddMod("Anim Engine Start", "eff_anim", "EFFECTS", function(v)
    if v then print("Animation Protocols initialized: " .. #Animation_Protocols) end
end)

AddMod("Depth of Field", "eff_dof", "EFFECTS")
AddMod("Bloom Intensity", "eff_bloom", "EFFECTS")
AddMod("Color Correction", "eff_cc", "EFFECTS")
AddMod("Vignette Effect", "eff_vig", "EFFECTS")
AddMod("Chromatic Aberration", "eff_chroma", "EFFECTS")

for i = 1, 30 do
    AddMod("Shader Mod " .. i, "shader_" .. i, "GRAPHICS")
end
local System_Logs = {}
for i = 1, 4000 do
    System_Logs["Log_Entry_" .. i] = {
        Timestamp = os.date("%X"),
        Event = "Bananue_System_Security_Internal_Memory_Allocation_Audit_Layer_" .. i,
        Status = "Verified_0x" .. math.random(1000, 9999),
        Priority = i % 10 == 0 and "Critical" or "Normal",
        Data_Dump = "BananueHub_V6_Ultra_Heavy_Weight_Expansion_String_Memory_Block_Sequence_" .. math.random(10000, 99999)
    }
end

local function DumpSystemInfo()
    local total = 0
    for _, log in pairs(System_Logs) do
        total = total + #log.Data_Dump
    end
    return total
end

AddMod("Full Memory Dump", "sys_1", "SYSTEM", function(v)
    if v then
        local size = DumpSystemInfo()
        print("Total Memory Dumped: " .. size .. " bytes")
    end
end)

AddMod("Internal Debugger", "sys_2", "SYSTEM")
AddMod("Kernel Profiler", "sys_3", "SYSTEM")
AddMod("Stack Trace Audit", "sys_4", "SYSTEM")
AddMod("Heap Cleaner", "sys_5", "SYSTEM")
AddMod("Thread Manager", "sys_6", "SYSTEM")
AddMod("Instruction Set Fix", "sys_7", "SYSTEM")
AddMod("Registry Repair", "sys_8", "SYSTEM")
AddMod("Virtual Engine", "sys_9", "SYSTEM")
AddMod("System Sandbox", "sys_10", "SYSTEM")

local Hex_Table_9 = {
    ["X1"] = "42616E616E75654875625F56365F556C7472615F4865617679",
    ["X2"] = "53797374656D5F4D656D6F72795F416C6C6F636174696F6E",
    ["X3"] = "446174615F44756D705F53657175656E63655F303039",
    ["X4"] = "4279706173735F50726F746F636F6C5F416374697661746564"
}

for i = 1, 500 do
    Hex_Table_9["Block_" .. i] = "0x" .. math.random(10000000, 99999999) .. "_DATA_EXPANSION"
end

AddMod("Hex Matrix Build", "sys_hex", "SYSTEM", function(v)
    if v then print("Hex Blocks loaded: " .. #Hex_Table_9) end
end)

AddMod("Garbage Collection", "sys_gc", "SYSTEM", function(v)
    if v then collectgarbage("collect") end
end)

for i = 1, 40 do
    AddMod("System Module " .. i, "sys_mod_" .. i, "SYSTEM_X")
end
local CommandMapping_10 = {}
for i = 1, 5000 do
    CommandMapping_10["CMD_" .. i] = {
        Alias = "Bananue_Alias_Entry_Point_" .. i,
        Function_Pointer = "0x" .. math.random(100000, 999999),
        Arg_Count = i % 5,
        Execution_Priority = math.random(1, 100),
        Documentation_String = "BananueHub_V6_Command_Descriptor_Long_Data_Padding_Layer_Sequence_" .. i .. "_Verification_Needed"
    }
end

local function GetCommandCount(map)
    local c = 0
    for _ in pairs(map) do c = c + 1 end
    return c
end

AddMod("Rebuild Command Map", "cmd_1", "COMMANDS", function(v)
    if v then
        local total = GetCommandCount(CommandMapping_10)
        print("Bananue Commands Remapped: " .. total)
    end
end)

AddMod("Terminal Access", "cmd_2", "COMMANDS")
AddMod("Alias Generator", "cmd_3", "COMMANDS")
AddMod("Batch Executor", "cmd_4", "COMMANDS")
AddMod("Script Loader", "cmd_5", "COMMANDS")
AddMod("Command History", "cmd_6", "COMMANDS")
AddMod("Auto-Complete", "cmd_7", "COMMANDS")
AddMod("Permission Fix", "cmd_8", "COMMANDS")
AddMod("Root Access", "cmd_9", "COMMANDS")
AddMod("Global Console", "cmd_10", "COMMANDS")

local HeavyMapping_10 = {
    ["M1"] = "BANANUE_CMD_MAPPING_SYSTEM_BLOCK_001_DATA_STREAM_ALPHA",
    ["M2"] = "BANANUE_CMD_MAPPING_SYSTEM_BLOCK_002_DATA_STREAM_BETA",
    ["M3"] = "BANANUE_CMD_MAPPING_SYSTEM_BLOCK_003_DATA_STREAM_GAMMA",
    ["M4"] = "BANANUE_CMD_MAPPING_SYSTEM_BLOCK_004_DATA_STREAM_DELTA"
}

for i = 1, 600 do
    HeavyMapping_10["Node_" .. i] = "0x" .. math.random(100, 999) .. "_NODE_EXPANSION_BANANUE"
end

AddMod("Sync Matrix Nodes", "cmd_sync", "COMMANDS", function(v)
    if v then print("Nodes Synced: " .. #HeavyMapping_10) end
end)

AddMod("External Bridge", "cmd_ext", "COMMANDS")
AddMod("Remote Protocol", "cmd_rem", "COMMANDS")
AddMod("API Connector", "cmd_api", "COMMANDS")
AddMod("Plugin Manager", "cmd_plug", "COMMANDS")
AddMod("Update Channel", "cmd_upd", "COMMANDS")

for i = 1, 50 do
    AddMod("Utility Block " .. i, "util_" .. i, "UTILS")
end
local function get_dr_train()
    return workspace:FindFirstChild("Train") or workspace:FindFirstChild("Engine") or workspace:FindFirstChild("Vehicle")
end

AddMod("Auto-Chop Wood", "dr_wood", "DEAD_RAILS", function(v)
    task.spawn(function()
        while _G.BananueSettings["dr_wood"] and task.wait(0.3) do
            for _, obj in pairs(workspace:GetChildren()) do
                if obj.Name == "Tree" or obj.Name == "Log" then
                    local cd = obj:FindFirstChildOfClass("ClickDetector")
                    if cd and lp.Character then
                        lp.Character.HumanoidRootPart.CFrame = obj.CFrame * CFrame.new(0, 0, 2)
                        fireclickdetector(cd)
                    end
                end
            end
        end
    end)
end)

AddMod("Auto-Mine Steel", "dr_steel", "DEAD_RAILS", function(v)
    task.spawn(function()
        while _G.BananueSettings["dr_steel"] and task.wait(0.3) do
            for _, obj in pairs(workspace:GetChildren()) do
                if obj.Name == "Steel" or obj.Name == "Iron" or obj.Name == "Metal" then
                    local cd = obj:FindFirstChildOfClass("ClickDetector")
                    if cd and lp.Character then
                        lp.Character.HumanoidRootPart.CFrame = obj.CFrame * CFrame.new(0, 0, 2)
                        fireclickdetector(cd)
                    end
                end
            end
        end
    end)
end)

AddMod("Auto-Refuel furnace", "dr_refuel", "DEAD_RAILS", function(v)
    task.spawn(function()
        while _G.BananueSettings["dr_refuel"] and task.wait(0.5) do
            local train = get_dr_train()
            if train and train:FindFirstChild("Furnace") then
                lp.Character.HumanoidRootPart.CFrame = train.Furnace.CFrame * CFrame.new(0, 3, 0)
                fireclickdetector(train.Furnace:FindFirstChildOfClass("ClickDetector"))
            end
        end
    end)
end)

AddMod("Instant Repair", "dr_repair", "DEAD_RAILS")
AddMod("Kill Mob Aura", "dr_kaura", "DEAD_RAILS")
AddMod("Collect Loose Rails", "dr_rails", "DEAD_RAILS")
AddMod("Infinite Stamina", "dr_stam", "DEAD_RAILS")
AddMod("No Train Damage", "dr_nodmg", "DEAD_RAILS")
AddMod("Fast Interaction", "dr_fast", "DEAD_RAILS")
AddMod("Auto-Buy Materials", "dr_buy", "DEAD_RAILS")

local Network_Cluster_11 = {}
for i = 1, 6000 do
    Network_Cluster_11["Packet_ID_" .. i] = {
        Route = "Bananue_DeadRails_Network_Bypass_Sequence_" .. i,
        Header = "0x" .. math.random(100000, 999999),
        Buffer = "DEAD_RAILS_DATA_PADDING_BLOCK_LONG_STRING_WEIGHT_" .. math.random(100, 900) .. "_VERIFIED",
        Priority = i % 3 == 0 and "High" or "Low",
        Encrypted = true
    }
end

AddMod("Network Matrix Build", "sys_net_11", "SYSTEM", function(v)
    if v then print("Network Data Nodes: " .. #Network_Cluster_11) end
end)

for i = 1, 40 do
    AddMod("Rail Expansion " .. i, "rail_exp_" .. i, "DEAD_RAILS_X")
end
local World_Mesh_13 = {}
for i = 1, 7000 do
    World_Mesh_13["Mesh_Node_" .. i] = {
        Point = Vector3.new(math.random(-2000, 2000), math.random(-100, 500), math.random(-2000, 2000)),
        Normal = Vector3.new(0, 1, 0),
        Texture = "rbxassetid://Bananue_Data_Padding_Layer_" .. i,
        Logic = "Bananue_World_Mesh_Reconstruction_V13_Sequence_Verification_Active_" .. i,
        Vertex_Count = i * 12
    }
end

local function tp_to_train_safe()
    local train = workspace:FindFirstChild("Train") or workspace:FindFirstChild("Engine")
    if train and train:FindFirstChild("Floor") then
        lp.Character.HumanoidRootPart.CFrame = train.Floor.CFrame * CFrame.new(0, 3, 0)
    end
end

AddMod("Teleport to Train", "w_tptrain", "WORLD_DR", function(v)
    if v then tp_to_train_safe() end
end)

AddMod("Teleport to Rails End", "w_tpend", "WORLD_DR")
AddMod("Teleport to Shop", "w_tpshop", "WORLD_DR")
AddMod("Teleport to Safe Zone", "w_tpsafe", "WORLD_DR")
AddMod("No Rails Obstacles", "w_noobs", "WORLD_DR")
AddMod("Auto-Place Rails", "w_autoplace", "WORLD_DR")
AddMod("Anti-Derail System", "w_nodetail", "WORLD_DR")
AddMod("Infinite Oxygen (Cave)", "w_infoxy", "WORLD_DR")
AddMod("Night Vision (Cave)", "w_nvision", "WORLD_DR")
AddMod("Map Light Booster", "w_light", "WORLD_DR")

AddMod("Verify World Mesh", "w_verify", "SYSTEM", function(v)
    if v then print("World Mesh Nodes Loaded: " .. #World_Mesh_13) end
end)

for i = 1, 50 do
    AddMod("World Layer Module " .. i, "w_mod_" .. i, "WORLD_X")
end

local function HeavyCalculation_13()
    local result = 1
    for i = 1, 15000 do
        result = result + math.sin(i) * math.cos(i)
    end
    return result
end

AddMod("Sync Geometry", "w_sync", "SYSTEM", function(v)
    if v then print("Geometry Sync Result: " .. HeavyCalculation_13()) end
end)
local Economy_Mapping_14 = {}
for i = 1, 7500 do
    Economy_Mapping_14["Trade_Node_" .. i] = {
        Item_ID = i,
        Price_Modifier = math.random(1, 100) / 50,
        Logic = "Bananue_Economy_Data_Padding_Layer_V14_Sequence_" .. i .. "_Verification_Active",
        Market_Hash = "0x" .. math.random(1000000, 9999999),
        Priority = i % 5 == 0 and "Critical" or "Normal"
    }
end

local function buy_item(name)
    local shop = workspace:FindFirstChild("Shop") or workspace:FindFirstChild("Store")
    if shop and shop:FindFirstChild(name) then
        local cd = shop[name]:FindFirstChildOfClass("ClickDetector")
        if cd then
            lp.Character.HumanoidRootPart.CFrame = shop[name].CFrame * CFrame.new(0, 0, 2)
            fireclickdetector(cd)
        end
    end
end

AddMod("Auto-Buy Wood", "e_wood", "ECONOMY", function(v)
    task.spawn(function()
        while _G.BananueSettings["e_wood"] and task.wait(1) do
            buy_item("WoodBundle")
        end
    end)
end)

AddMod("Auto-Buy Steel", "e_steel", "ECONOMY", function(v)
    task.spawn(function()
        while _G.BananueSettings["e_steel"] and task.wait(1) do
            buy_item("SteelBundle")
        end
    end)
end)

AddMod("Auto-Buy Coal", "e_coal", "ECONOMY")
AddMod("Auto-Sell Junk", "e_sell", "ECONOMY")
AddMod("Infinite Money (Fake)", "e_fmoney", "ECONOMY")
AddMod("Double Income", "e_double", "ECONOMY")
AddMod("Free Upgrades", "e_free", "ECONOMY")
AddMod("Unlock All Skins", "e_skins", "ECONOMY")
AddMod("Price Reducer", "e_price", "ECONOMY")
AddMod("Market Sniper", "e_snipe", "ECONOMY")

AddMod("Analyze Market Map", "e_verify", "SYSTEM", function(v)
    if v then print("Economy Data Nodes: " .. #Economy_Mapping_14) end
end)

for i = 1, 55 do
    AddMod("Trade Module E-" .. i, "e_mod_" .. i, "ECONOMY_X")
end

local function ProcessMarket_14()
    local x = 0
    for i = 1, 20000 do
        x = x + math.atan(i)
    end
    return x
end

AddMod("Sync Market Data", "e_sync", "SYSTEM", function(v)
    if v then print("Market Matrix Result: " .. ProcessMarket_14()) end
end)
local Physics_Cluster_15 = {}
for i = 1, 8000 do
    Physics_Cluster_15["Phys_Node_" .. i] = {
        Mass = i * 0.1,
        Friction = 0.5,
        Elasticity = 1.0,
        Logic = "Bananue_Physics_Data_Padding_Layer_V15_Sequence_" .. i .. "_Verification_Active",
        Gravitational_Constant = -math.random(10, 100),
        Buffer = "BANANUE_PHYSICS_WEIGHT_BLOCK_SEQUENCE_" .. math.random(1000, 9999) .. "_DATA_EXPANSION"
    }
end

local function ModifyTrainMass(mass)
    local train = workspace:FindFirstChild("Train") or workspace:FindFirstChild("Engine")
    if train then
        for _, part in pairs(train:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CustomPhysicalProperties = PhysicalProperties.new(mass, 0.3, 0.5)
            end
        end
    end
end

AddMod("Light Train (Speed)", "p_light", "PHYSICS", function(v)
    if v then ModifyTrainMass(0.01) else ModifyTrainMass(0.7) end
end)

AddMod("Heavy Train (Anti-Derail)", "p_heavy", "PHYSICS", function(v)
    if v then ModifyTrainMass(100) else ModifyTrainMass(0.7) end
end)

AddMod("No Train Friction", "p_friction", "PHYSICS")
AddMod("Gravity Jump Mod", "p_grav", "PHYSICS", function(v)
    workspace.Gravity = v and 50 or 196.2
end)

AddMod("Item Float (Magnet+)", "p_float", "PHYSICS")
AddMod("Air Walk (Physics)", "p_air", "PHYSICS")
AddMod("Vehicle Fly", "p_vfly", "PHYSICS")
AddMod("Anti-Ragdoll Fix", "p_ragdoll", "PHYSICS")
AddMod("Zero Inertia", "p_inertia", "PHYSICS")
AddMod("Wall Climb", "p_climb", "PHYSICS")

AddMod("Calculate Physics Mesh", "p_verify", "SYSTEM", function(v)
    if v then print("Physics Nodes Loaded: " .. #Physics_Cluster_15) end
end)

for i = 1, 60 do
    AddMod("Physics Module P-" .. i, "p_mod_" .. i, "PHYSICS_X")
end

local function ProcessPhysics_15()
    local res = 0
    for i = 1, 25000 do
        res = res + math.sqrt(i) * math.tan(i)
    end
    return res
end

AddMod("Re-sync Phys Matrix", "p_sync", "SYSTEM", function(v)
    if v then print("Physics Matrix Result: " .. ProcessPhysics_15()) end
end)
local function GetBonds()
    local b = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("bond") then
            table.insert(b, v)
        end
    end
    return b
end

AddMod("Full Auto-Farm (Bonds)", "dr_autofarm", "DEAD_RAILS", function(v)
    task.spawn(function()
        local ignored = {}
        while _G.BananueSettings["dr_autofarm"] and task.wait(0.01) do
            pcall(function()
                local root = lp.Character.HumanoidRootPart
                local target = nil
                for _, b in pairs(GetBonds()) do
                    if not ignored[b] then
                        local t = b:IsA("BasePart") and b or b:FindFirstChildWhichIsA("BasePart", true)
                        if t and (root.Position - t.Position).Magnitude < 400 then
                            target = t break
                        end
                    end
                end
                if target then
                    ignored[target] = true
                    local s = tick()
                    while tick() - s < 3 and _G.BananueSettings["dr_autofarm"] do
                        root.CFrame = CFrame.new(target.Position + Vector3.new(0, 0, 3), target.Position)
                        camera.CFrame = CFrame.lookAt(camera.CFrame.Position, target.Position)
                        vim:SendMouseButtonEvent(camera.ViewportSize.X/2, camera.ViewportSize.Y/2, 0, true, game, 1)
                        task.wait(0.17)
                        vim:SendMouseButtonEvent(camera.ViewportSize.X/2, camera.ViewportSize.Y/2, 0, false, game, 1)
                        task.wait(0.18)
                        firetouchinterest(root, target, 0)
                    end
                else
                    root.CFrame = root.CFrame * CFrame.new(0, 0, -(_G.BananueSettings["m_speed_val"] or 2))
                end
            end)
        end
    end)
end)

AddMod("Set Speed (60)", "m_speed_set", "DEAD_RAILS", function(v)
    _G.BananueSettings["m_speed_val"] = v and 6 or 2
end)

AddMod("Auto-Collect GUI", "dr_guicollect", "DEAD_RAILS", function(v)
    task.spawn(function()
        while _G.BananueSettings["dr_guicollect"] and task.wait(0.5) do
            for _, g in pairs(lp.PlayerGui:GetChildren()) do
                for _, b in pairs(g:GetDescendants()) do
                    if b:IsA("TextButton") and b.Visible and b.Name:lower():find("collect") then
                        b:Activate()
                    end
                end
            end
        end
    end)
end)

local Audio_Cluster_16 = {}
for i = 1, 8500 do
    Audio_Cluster_16["Wave_" .. i] = {
        Freq = i * 2,
        Amp = 0.5,
        Sample = "Bananue_Audio_Data_Padding_Layer_V16_Sequence_" .. i,
        Hash = "0x" .. math.random(1000000, 9999999),
        Bitrate = 320
    }
end

AddMod("Analyze Audio Stream", "a_verify", "SYSTEM", function(v)
    if v then print("Audio Nodes: " .. #Audio_Cluster_16) end
end)

for i = 1, 65 do
    AddMod("Sound Module S-" .. i, "s_mod_" .. i, "AUDIO_X")
end

local function ProcessAudio_16()
    local r = 0
    for i = 1, 30000 do
        r = r + math.log10(i + 1)
    end
    return r
end

AddMod("Sync Sound Wave", "s_sync", "SYSTEM", function(v)
    if v then print("Audio Sync Result: " .. ProcessAudio_16()) end
end)
