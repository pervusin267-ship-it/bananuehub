local UserInputService = game:GetService("UserInputService")local TweenService = game:GetService("TweenService")local CoreGui = game:GetService("CoreGui")local RunService = game:GetService("RunService")local Players = game:GetService("Players")local LocalPlayer = Players.LocalPlayer
local Library = {}
Library.__index = Library

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

    local PagesContainer = Instance.new("Frame")
    PagesContainer.Parent = MainFrame
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.Position = UDim2.new(0, 130, 0, 45)
    PagesContainer.Size = UDim2.new(0, 330, 0, 285)

    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(MainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.Width.Scale, startPos.Width.Offset + delta.X, startPos.Height.Scale, startPos.Height.Offset + delta.Y)
            }):Play()
        end
    end)

    local minimized = false
    local function ToggleMinimize()
        minimized = not minimized
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = minimized and UDim2.new(0, 470, 0, 35) or UDim2.new(0, 470, 0, 340)
        }):Play()
        TabContainer.Visible = not minimized
        PagesContainer.Visible = not minimized
        MinimizeBtn.Text = minimized and "+" or "-"
    end
    MinimizeBtn.MouseButton1Click:Connect(ToggleMinimize)

    local MobileToggle = Instance.new("TextButton")
    MobileToggle.Name = "MobileToggle"
    MobileToggle.Parent = ScreenGui
    MobileToggle.BackgroundColor3 = Library.Theme.Accent
    MobileToggle.Position = UDim2.new(0, 15, 0, 15)
    MobileToggle.Size = UDim2.new(0, 40, 0, 40)
    MobileToggle.Font = Enum.Font.GothamBold
    MobileToggle.Text = "D"
    MobileToggle.TextColor3 = Library.Theme.Text
    MobileToggle.TextSize = 18
    
    local MobileCorner = Instance.new("UICorner")
    MobileCorner.CornerRadius = UDim.new(1, 0)
    MobileCorner.Parent = MobileToggle
    
    local MobileStroke = Instance.new("UIStroke")
    MobileStroke.Color = Color3.fromRGB(255, 255, 255)
    MobileStroke.Thickness = 1
    MobileStroke.Transparency = 0.6
    MobileStroke.Parent = MobileToggle

    MobileToggle.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    local mobDragging, mobDragStart, mobStartPos
    MobileToggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            mobDragging = true
            mobDragStart = input.Position
            mobStartPos = MobileToggle.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then mobDragging = false end
            end)
        end
    end)
    MobileToggle.InputChanged:Connect(function(input)
        if mobDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - mobDragStart
            MobileToggle.Position = UDim2.new(mobStartPos.Width.Scale, mobStartPos.Width.Offset + delta.X, mobStartPos.Height.Scale, mobStartPos.Height.Offset + delta.Y)
        end
    end)

    self.NotifContainer = NotifContainer
    self.TabCount = 0
    self.Pages = {}
    self.Tabs = {}
    
    return self end
function Library:Notify(title, desc, duration)
    local duration = duration or 4
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.BackgroundColor3 = Library.Theme.Background
    NotifFrame.Size = UDim2.new(1, 0, 0, 60)
    NotifFrame.Position = UDim2.new(1, 250, 0, 0)
    NotifFrame.Parent = self.NotifContainer
    
    local NC = Instance.new("UICorner", NotifFrame) NC.CornerRadius = UDim.new(0, 6)
    local NS = Instance.new("UIStroke", NotifFrame) NS.Color = Library.Theme.Accent NS.Thickness = 1
    
    local NTitle = Instance.new("TextLabel", NotifFrame)
    NTitle.BackgroundTransparency = 1 NTitle.Position = UDim2.new(0, 10, 0, 6) NTitle.Size = UDim2.new(1, -20, 0, 15)
    NTitle.Font = Enum.Font.GothamBold NTitle.Text = title NTitle.TextColor3 = Library.Theme.Text NTitle.TextSize = 12 NTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local NDesc = Instance.new("TextLabel", NotifFrame)
    NDesc.BackgroundTransparency = 1 NDesc.Position = UDim2.new(0, 10, 0, 24) NDesc.Size = UDim2.new(1, -20, 0, 30)
    NDesc.Font = Enum.Font.Gotham NDesc.Text = desc NDesc.TextColor3 = Library.Theme.DarkText NDesc.TextSize = 11 NDesc.TextWrapped = true NDesc.TextXAlignment = Enum.TextXAlignment.Left NDesc.TextYAlignment = Enum.TextYAlignment.Top
    
    TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    task.spawn(function()
        task.wait(duration)

        TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 250, 0, 0)}):Play()
        task.wait(0.3)
        NotifFrame:Destroy()
    end)
end
function Library:CreateTab(tabText)
    self.TabCount = self.TabCount + 1
    local tabId = self.TabCount
    local TabButton = Instance.new("TextButton")
    TabButton.Parent = self.Gui.MainFrame.TabContainer
    TabButton.BackgroundColor3 = Library.Theme.Element
    TabButton.BackgroundTransparency = tabId == 1 and 0 or 1
    TabButton.Size = UDim2.new(1, 0, 0, 30)
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.Text = tabText
    TabButton.TextColor3 = tabId == 1 and Library.Theme.Text or Library.Theme.DarkText
    TabButton.TextSize = 12
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 5)
    local Page = Instance.new("ScrollingFrame")
    Page.Parent = self.Gui.MainFrame.PagesContainer
    Page.Active = true
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = tabId == 1
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ScrollBarThickness = 2
    local PageList = Instance.new("UIListLayout")
    PageList.Parent = Page
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.Padding = UDim.new(0, 6)
    PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 10)
    end)
    TabButton.MouseButton1Click:Connect(function()
        for id, p in pairs(self.Pages) do p.Visible = (id == tabId) end
        for id, t in pairs(self.Tabs) do
            TweenService:Create(t, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundTransparency = (id == tabId) and 0 or 1,
                TextColor3 = (id == tabId) and Library.Theme.Text or Library.Theme.DarkText
            }):Play()
        end
    end)
    self.Pages[tabId] = Page
    self.Tabs[tabId] = TabButton
    local ElementFactory = {}
    function ElementFactory:AddSection(text)
        local SecFrame = Instance.new("Frame")
        SecFrame.BackgroundTransparency = 1
        SecFrame.Size = UDim2.new(1, -5, 0, 20)
        SecFrame.Parent = Page
        local Label = Instance.new("TextLabel", SecFrame)
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.Font = Enum.Font.GothamBold
        Label.Text = string.upper(text)
        Label.TextColor3 = Library.Theme.Accent
        Label.TextSize = 10
        Label.TextXAlignment = Enum.TextXAlignment.Left
    end
    function ElementFactory:AddButton(text, callback)
        local btnCallback = callback or function() end
        local Button = Instance.new("TextButton", Page)
        Button.BackgroundColor3 = Library.Theme.Element
        Button.Size = UDim2.new(1, -5, 0, 32)
        Button.Font = Enum.Font.GothamMedium
        Button.Text = text
        Button.TextColor3 = Library.Theme.Text
        Button.TextSize = 13
        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 5)
        local BS = Instance.new("UIStroke", Button) BS.Color = Color3.fromRGB(45, 45, 52) BS.Thickness = 1
        Button.MouseButton1Click:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
            task.wait(0.1)
            TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {BackgroundColor3 = Library.Theme.Element}):Play()
            pcall(btnCallback)
        end)
    end
    function ElementFactory:AddToggle(text, callback)
        local togCallback = callback or function() end
        local toggled = false
        local ToggleFrame = Instance.new("TextButton", Page)
        ToggleFrame.BackgroundColor3 = Library.Theme.Element
        ToggleFrame.Size = UDim2.new(1, -5, 0, 35)
        ToggleFrame.Text = ""
        Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 5)
        local TS = Instance.new("UIStroke", ToggleFrame) TS.Color = Color3.fromRGB(45, 45, 52) TS.Thickness = 1
        local Label = Instance.new("TextLabel", ToggleFrame)
        Label.BackgroundTransparency = 1 Label.Position = UDim2.new(0, 10, 0, 0) Label.Size = UDim2.new(1, -50, 1, 0)
        Label.Font = Enum.Font.Gotham Label.Text = text Label.TextColor3 = Library.Theme.Text Label.TextSize = 13 Label.TextXAlignment = Enum.TextXAlignment.Left
        local Box = Instance.new("Frame", ToggleFrame)
        Box.BackgroundColor3 = Color3.fromRGB(20, 20, 24) Box.Position = UDim2.new(1, -30, 0, 8) Box.Size = UDim2.new(0, 18, 0, 18)
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
        ToggleFrame.MouseButton1Click:Connect(function()
            toggled = not toggled
            TweenService:Create(Box, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = toggled and Library.Theme.Accent or Color3.fromRGB(20, 20, 24)
            }):Play()
            pcall(togCallback, toggled)
        end)
    end
    function ElementFactory:AddSlider(text, min, max, default, callback)
        local sliderCallback = callback or function() end
        local SliderFrame = Instance.new("Frame", Page)
        SliderFrame.BackgroundColor3 = Library.Theme.Element
        SliderFrame.Size = UDim2.new(1, -5, 0, 45)
        Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 5)
        local SS = Instance.new("UIStroke", SliderFrame) SS.Color = Color3.fromRGB(45, 45, 52) SS.Thickness = 1
        local Label = Instance.new("TextLabel", SliderFrame)
        Label.BackgroundTransparency = 1 Label.Position = UDim2.new(0, 10, 0, 5) Label.Size = UDim2.new(1, -60, 0, 15)
        Label.Font = Enum.Font.Gotham Label.Text = text Label.TextColor3 = Library.Theme.Text Label.TextSize = 13 Label.TextXAlignment = Enum.TextXAlignment.Left
        local ValueLabel = Instance.new("TextLabel", SliderFrame)
        ValueLabel.BackgroundTransparency = 1 ValueLabel.Position = UDim2.new(1, -55, 0, 5) ValueLabel.Size = UDim2.new(0, 45, 0, 15)
        ValueLabel.Font = Enum.Font.GothamBold ValueLabel.Text = tostring(default) ValueLabel.TextColor3 = Library.Theme.DarkText ValueLabel.TextSize = 13 ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        local SlideBar = Instance.new("TextButton", SliderFrame)
        SlideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 24) SlideBar.Position = UDim2.new(0, 10, 0, 26) SlideBar.Size = UDim2.new(1, -20, 0, 6) SlideBar.Text = ""
        Instance.new("UICorner", SlideBar).CornerRadius = UDim.new(0, 3)
        local Fill = Instance.new("Frame", SlideBar)
        Fill.BackgroundColor3 = Library.Theme.Accent Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 3)
        local function update(input)
            local pos = math.clamp((input.Position.X - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            local value = math.floor(min + (pos * (max - min)))
            ValueLabel.Text = tostring(value)
            pcall(sliderCallback, value)
        end
        local sliding = false
        SlideBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = true update(input)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end
        end)
    end
    function ElementFactory:AddDropdown(text, list, callback)
        local dropCallback = callback or function() end
        local isOpened = false
        local items = list or {}
        local DropFrame = Instance.new("TextButton", Page)
        DropFrame.BackgroundColor3 = Library.Theme.Element
        DropFrame.Size = UDim2.new(1, -5, 0, 35)
        DropFrame.Text = ""
        Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 5)
        local DS = Instance.new("UIStroke", DropFrame) DS.Color = Color3.fromRGB(45, 45, 52) DS.Thickness = 1
        local Label = Instance.new("TextLabel", DropFrame)
        Label.BackgroundTransparency = 1 Label.Position = UDim2.new(0, 10, 0, 0) Label.Size = UDim2.new(1, -40, 1, 0)
        Label.Font = Enum.Font.Gotham Label.Text = text .. " : Выберите..." Label.TextColor3 = Library.Theme.Text Label.TextSize = 13 Label.TextXAlignment = Enum.TextXAlignment.Left
        local Indicator = Instance.new("TextLabel", DropFrame)
        Indicator.BackgroundTransparency = 1 Indicator.Position = UDim2.new(1, -30, 0, 0) Indicator.Size = UDim2.new(0, 20, 1, 0)
        Indicator.Font = Enum.Font.GothamBold Indicator.Text = "V" Indicator.TextColor3 = Library.Theme.DarkText Indicator.TextSize = 12
        local ItemHolder = Instance.new("Frame", Page)
        ItemHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 24) ItemHolder.Size = UDim2.new(1, -5, 0, 0) ItemHolder.Visible = false ItemHolder.ClipsDescendants = true
        Instance.new("UICorner", ItemHolder).CornerRadius = UDim.new(0, 5)
        local UIList = Instance.new("UIListLayout", ItemHolder) UIList.Padding = UDim.new(0, 2)
        local function toggleDropdown()
            isOpened = not isOpened
            ItemHolder.Visible = true
            Indicator.Text = isOpened and "^" or "V"
            TweenService:Create(ItemHolder, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Size = isOpened and UDim2.new(1, -5, 0, UIList.AbsoluteContentSize.Y + 4) or UDim2.new(1, -5, 0, 0)
            }):Play()
            if not isOpened then task.wait(0.2) if not isOpened then ItemHolder.Visible = false end end
        end
        DropFr
