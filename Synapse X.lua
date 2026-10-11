-- // Delta / Synapse X Compatible Advanced UI Library
-- // Complete Edition with HUD, Notifications, Configs, Themes & More

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Library = {}
Library.__index = Library

-- Текущая цветовая схема (Тема по умолчанию)
Library.Theme = {
    Background = Color3.fromRGB(24, 24, 28),
    TopBar = Color3.fromRGB(20, 20, 24),
    Accent = Color3.fromRGB(88, 101, 242),
    Text = Color3.fromRGB(240, 240, 245),
    DarkText = Color3.fromRGB(160, 160, 175),
    Element = Color3.fromRGB(30, 30, 38)
}

function Library.new(titleText)
    local self = setmetatable({}, Library)
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AdvancedCompactUI"
    ScreenGui.ResetOnSpawn = false
    
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        pcall(function() ScreenGui.Parent = CoreGui end)
        if ScreenGui.Parent ~= CoreGui then
            ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
    end
    
    self.Gui = ScreenGui

    -- Контейнер для уведомлений
    local NotifContainer = Instance.new("Frame")
    NotifContainer.Name = "NotifContainer"
    NotifContainer.Parent = ScreenGui
    NotifContainer.BackgroundTransparency = 1
    NotifContainer.Position = UDim2.new(1, -230, 1, -20)
    NotifContainer.Size = UDim2.new(0, 220, 0, 0)
    
    local NotifLayout = Instance.new("UIListLayout")
    NotifLayout.Parent = NotifContainer
    NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifLayout.Padding = UDim.new(0, 8)

    -- Главное окно
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Library.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -235, 0.5, -170)
    MainFrame.Size = UDim2.new(0, 470, 0, 340)
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(45, 45, 55)
    UIStroke.Thickness = 1
    UIStroke.Parent = MainFrame

    -- Верхняя панель
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Library.Theme.TopBar
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar
    
    local FixCover = Instance.new("Frame")
    FixCover.Parent = TopBar
    FixCover.BackgroundColor3 = Library.Theme.TopBar
    FixCover.BorderSizePixel = 0
    FixCover.Position = UDim2.new(0, 0, 1, -5)
    FixCover.Size = UDim2.new(1, 0, 0, 5)

    local Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = titleText or "UI Library"
    Title.TextColor3 = Library.Theme.Text
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Parent = TopBar
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Position = UDim2.new(1, -35, 0, 0)
    MinimizeBtn.Size = UDim2.new(0, 35, 1, 0)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Library.Theme.DarkText
    MinimizeBtn.TextSize = 16

    -- Панель вкладок
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = MainFrame
    TabContainer.Active = true
    TabContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 10, 0, 45)
    TabContainer.Size = UDim2.new(0, 110, 0, 285)
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ScrollBarThickness = 2
    
    Instance.new("UICorner", TabContainer).CornerRadius = UDim.new(0, 6)
    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)

    -- Контейнер страниц
    local PagesContainer = Instance.new("Frame")
    PagesContainer.Parent = MainFrame
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.Position = UDim2.new(0, 130, 0, 45)
    PagesContainer.Size = UDim2.new(0, 330, 0, 285)

    -- Перемещение окна
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    TopBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Сворачивание
    local minimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        TabContainer.Visible = not minimized
        PagesContainer.Visible = not minimized
        MinimizeBtn.Text = minimized and "+" or "-"
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = minimized and UDim2.new(0, 470, 0, 35) or UDim2.new(0, 470, 0, 340)}):Play()
    end)

    -- Система уведомлений
    function self:SendNotification(title, text, duration)
        duration = duration or 3
        local Notif = Instance.new("Frame")
        Notif.Parent = NotifContainer
        Notif.BackgroundColor3 = Library.Theme.Background
        Notif.Size = UDim2.new(1, 0, 0, 50)
        Notif.Position = UDim2.new(1, 50, 0, 0)
        Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 6)
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Library.Theme.Accent
        Stroke.Thickness = 1
        Stroke.Parent = Notif

        local NTitle = Instance.new("TextLabel")
        NTitle.Parent = Notif
        NTitle.BackgroundTransparency = 1
        NTitle.Position = UDim2.new(0, 10, 0, 5)
        NTitle.Size = UDim2.new(1, -20, 0, 18)
        NTitle.Font = Enum.Font.GothamBold
        NTitle.Text = title
        NTitle.TextColor3 = Library.Theme.Text
        NTitle.TextSize = 12
        NTitle.TextXAlignment = Enum.TextXAlignment.Left

        local NText = Instance.new("TextLabel")
        NText.Parent = Notif
        NText.BackgroundTransparency = 1
        NText.Position = UDim2.new(0, 10, 0, 23)
        NText.Size = UDim2.new(1, -20, 0, 22)
        NText.Font = Enum.Font.Gotham
        NText.Text = text
        NText.TextColor3 = Library.Theme.DarkText
        NText.TextSize = 11
        NText.TextXAlignment = Enum.TextXAlignment.Left
        NText.TextWrapped = true

        TweenService:Create(Notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        task.delay(duration, function()
            TweenService:Create(Notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 50, 0, 0)}):Play()
            task.wait(0.3)
            Notif:Destroy()
        end)
    end

    -- Статистика (Stats HUD)
    function self:CreateStatsHUD()
        local HUD = Instance.new("ScreenGui")
        HUD.Name = "StatsHUD"
        HUD.Parent = ScreenGui
        
        local Frame = Instance.new("Frame")
        Frame.Parent = HUD
        Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        Frame.Position = UDim2.new(0, 15, 0, 15)
        Frame.Size = UDim2.new(0, 160, 0, 75)
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Color3.fromRGB(45, 45, 55)
        Stroke.Parent = Frame

        local Label = Instance.new("TextLabel")
        Label.Parent = Frame
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 8, 0, 5)
        Label.Size = UDim2.new(1, -16, 1, -10)
        Label.Font = Enum.Font.GothamMedium
        Label.TextColor3 = Library.Theme.Text
        Label.TextSize = 11
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.TextYAlignment = Enum.TextYAlignment.Top

        local startTime = tick()
        RunService.RenderStepped:Connect(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
            local uptime = math.floor(tick() - startTime)
            local mem = math.floor(gcinfo() / 1024)
            Label.Text = string.Format("FPS: %d | Ping: %dms\nMem: %dMB | Time: %ds", fps, ping, mem, uptime)
        end)
    end

    self.TabContainer = TabContainer
    self.PagesContainer = PagesContainer
    self.FirstTab = true
    return self
end

-- Создание вкладки
function Library:CreateTab(tabName)
    local tabSelf = {}

    local TabButton = Instance.new("TextButton")
    TabButton.Parent = self.TabContainer
    TabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(1, -6, 0, 30)
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.Text = tabName
    TabButton.TextColor3 = Library.Theme.DarkText
    TabButton.TextSize = 12
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 5)

    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Parent = self.PagesContainer
    TabPage.Active = true
    TabPage.BackgroundTransparency = 1
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabPage.ScrollBarThickness = 2
    TabPage.Visible = false

    local PageList = Instance.new("UIListLayout")
    PageList.Parent = TabPage
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.Padding = UDim.new(0, 6)

    if self.FirstTab then
        self.FirstTab = false
        TabPage.Visible = true
        TabButton.TextColor3 = Library.Theme.Text
        TabButton.BackgroundColor3 = Library.Theme.Accent
    end

    TabButton.MouseButton1Click:Connect(function()
        for _, child in pairs(self.PagesContainer:GetChildren()) do if child:IsA("ScrollingFrame") then child.Visible = false end end
        for _, child in pairs(self.TabContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child.TextColor3 = Library.Theme.DarkText
                child.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
            end
        end
        TabPage.Visible = true
        TabButton.TextColor3 = Library.Theme.Text
        TabButton.BackgroundColor3 = Library.Theme.Accent
    end)

    PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabPage.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 10)
    end)

    -- Кнопка
    function tabSelf:CreateButton(text, callback)
        local Btn = Instance.new("TextButton")
        Btn.Parent = TabPage
        Btn.BackgroundColor3 = Library.Theme.Element
        Btn.Size = UDim2.new(1, -6, 0, 32)
        Btn.Font = Enum.Font.GothamMedium
        Btn.Text = "  " .. text
        Btn.TextColor3 = Library.Theme.Text
        Btn.TextSize = 12
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
        Btn.MouseButton1Click:Connect(function() pcall(callback) end)
    end

    -- Переключатель (Toggle)
    function tabSelf:CreateToggle(text, default, callback)
        local toggled = default or false
        local Toggle = Instance.new("TextButton")
        Toggle.Parent = TabPage
        Toggle.BackgroundColor3 = Library.Theme.Element
        Toggle.Size = UDim2.new(1, -6, 0, 32)
        Toggle.Font = Enum.Font.GothamMedium
        Toggle.Text = "  " .. text
        Toggle.TextColor3 = Library.Theme.Text
        Toggle.TextSize = 12
        Toggle.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 5)

        local Indicator = Instance.new("Frame")
        Indicator.Parent = Toggle
        Indicator.AnchorPoint = Vector2.new(1, 0.5)
        Indicator.BackgroundColor3 = toggled and Library.Theme.Accent or Color3.fromRGB(60, 60, 75)
        Indicator.Position = UDim2.new(1, -10, 0.5, 0)
        Indicator.Size = UDim2.new(0, 16, 0, 16)
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

        Toggle.MouseButton1Click:Connect(function()
            toggled = not toggled
            Indicator.BackgroundColor3 = toggled and Library.Theme.Accent or Color3.fromRGB(60, 60, 75)
            pcall(function() callback(toggled) end)
        end)
    end

    -- Слайдер (Slider)
    function tabSelf:CreateSlider(text, min, max, default, callback)
        local val = default or min
        local Slider = Instance.new("Frame")
        Slider.Parent = TabPage
        Slider.BackgroundColor3 = Library.Theme.Element
        Slider.Size = UDim2.new(1, -6, 0, 45)
        Instance.new("UICorner", Slider).CornerRadius = UDim.new(0, 5)

        local Label = Instance.new("TextLabel")
        Label.Parent = Slider
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 10, 0, 6)
        Label.Size = UDim2.new(1, -20, 0, 16)
        Label.Font = Enum.Font.GothamMedium
        Label.Text = text .. ": " .. tostring(val)
        Label.TextColor3 = Library.Theme.Text
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left

        local Bar = Instance.new("Frame")
        Bar.Parent = Slider
        Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        Bar.Position = UDim2.new(0, 10, 0, 28)
        Bar.Size = UDim2.new(1, -20, 0, 6)
        Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

        local Fill = Instance.new("Frame")
        Fill.Parent = Bar
        Fill.BackgroundColor3 = Library.Theme.Accent
        Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
        Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

        local draggingSlider = false
        Bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = true
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                val = math.floor(min + ((max - min) * pos))
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                Label.Text = text .. ": " .. tostring(val)
                pcall(function() callback(val) end)
            end
        end)
    end

    -- Поле ввода (TextBox)
    function tabSelf:CreateTextBox(text, placeholder, callback)
        local BoxFrame = Instance.new("Frame")
        BoxFrame.Parent = TabPage
        BoxFrame.BackgroundColor3 = Library.Theme.Element
        BoxFrame.Size = UDim2.new(1, -6, 0, 36)
        Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 5)

        local Label = Instance.new("TextLabel")
        Label.Parent = BoxFrame
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.Size = UDim2.new(0, 150, 1, 0)
        Label.Font = Enum.Font.GothamMedium
        Label.Text = text
        Label.TextColor3 = Library.Theme.Text
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left

        local TextBox = Instance.new("TextBox")
        TextBox.Parent = BoxFrame
        TextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        TextBox.Position = UDim2.new(1, -150, 0.5, -12)
        TextBox.Size = UDim2.new(0, 140, 0, 24)
        TextBox.Font = Enum.Font.Gotham
        TextBox.PlaceholderText = placeholder or ""
        TextBox.Text = ""
        TextBox.TextColor3 = Library.Theme.Text
        TextBox.TextSize = 11
        Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 4)

        TextBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                pcall(function() callback(TextBox.Text) end)
            end
        end)
    end

    -- Бинды (Keybind)
    function tabSelf:CreateKeybind(text, defaultKey, callback)
        local key = defaultKey or Enum.KeyCode.F
        local KbFrame = Instance.new("Frame")
        KbFrame.Parent = TabPage
        KbFrame.BackgroundColor3 = Library.Theme.Element
        KbFrame.Size = UDim2.new(1, -6, 0, 32)
        Instance.new("UICorner", KbFrame).CornerRadius = UDim.new(0, 5)

        local Label = Instance.new("TextLabel")
        Label.Parent = KbFrame
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.Size = UDim2.new(1, -100, 1, 0)
        Label.Font = Enum.Font.GothamMedium
        Label.Text = "  " .. text
        Label.TextColor3 = Library.Theme.Text
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left

        local KeyBtn = Instance.new("TextButton")
        KeyBtn.Parent = KbFrame
        KeyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        KeyBtn.AnchorPoint = Vector2.new(1, 0.5)
        KeyBtn.Position = UDim2.new(1, -10, 0.5, 0)
        KeyBtn.Size = UDim2.new(0, 75, 0, 22)
        KeyBtn.Font = Enum.Font.GothamBold
        KeyBtn.Text = key.Name
        KeyBtn.TextColor3 = Library.Theme.Accent
        KeyBtn.TextSize = 11
        Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 4)

        local binding = false
        KeyBtn.MouseButton1Click:Connect(function()
            binding = true
            KeyBtn.Text = "..."
        end)

        UserInputService.InputBegan:Connect(function(input)
            if binding then
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    key = input.KeyCode
                    KeyBtn.Text = key.Name
                    binding = false
                end
            elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key then
                pcall(callback)
            end
        end)
    end

    return tabSelf
end

return Library
