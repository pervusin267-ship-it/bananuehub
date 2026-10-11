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
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(ScreenGui)
            ScreenGui.Parent = CoreGui
        else
            ScreenGui.Parent = CoreGui
        end
    end)
    if ScreenGui.Parent ~= CoreGui then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
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
    local UICorner = Instance.new("UICorner", MainFrame)
    UICorner.CornerRadius = UDim.new(0, 8)
    local UIStroke = Instance.new("UIStroke", MainFrame)
    UIStroke.Color = Color3.fromRGB(45, 45, 55)
    UIStroke.Thickness = 1
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.BackgroundColor3 = Library.Theme.TopBar
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
    local Title = Instance.new("TextLabel", TopBar)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = titleText or "UI Library"
    Title.TextColor3 = Library.Theme.Text
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    local MinimizeBtn = Instance.new("TextButton", TopBar)
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Position = UDim2.new(1, -35, 0, 0)
    MinimizeBtn.Size = UDim2.new(0, 35, 1, 0)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Library.Theme.DarkText
    MinimizeBtn.TextSize = 16
    local TabContainer = Instance.new("ScrollingFrame", MainFrame)
    TabContainer.Active = true
    TabContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 10, 0, 45)
    TabContainer.Size = UDim2.new(0, 110, 0, 285)
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ScrollBarThickness = 2
    Instance.new("UICorner", TabContainer).CornerRadius = UDim.new(0, 6)
    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    local PagesContainer = Instance.new("Frame", MainFrame)
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.Position = UDim2.new(0, 130, 0, 45)
    PagesContainer.Size = UDim2.new(0, 330, 0, 285)
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
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
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    local minimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        TabContainer.Visible = not minimized
        PagesContainer.Visible = not minimized
        MinimizeBtn.Text = minimized and "+" or "-"
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = minimized and UDim2.new(0, 470, 0, 35) or UDim2.new(0, 470, 0, 340)}):Play()
    end)
    local MobileToggle = Instance.new("TextButton", ScreenGui)
    MobileToggle.BackgroundColor3 = Library.Theme.Accent
    MobileToggle.Position = UDim2.new(0, 15, 0, 15)
    MobileToggle.Size = UDim2.new(0, 40, 0, 40)
    MobileToggle.Font = Enum.Font.GothamBold
    MobileToggle.Text = "D"
    MobileToggle.TextColor3 = Library.Theme.Text
    MobileToggle.TextSize = 18
    Instance.new("UICorner", MobileToggle).CornerRadius = UDim.new(1, 0)
    MobileToggle.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)
    self.NotifContainer = NotifContainer
    self.TabContainer = TabContainer
    self.PagesContainer = PagesContainer
    self.FirstTab = true
    return self 
end
function Library:Notify(title, desc, duration)
    local NotifFrame = Instance.new("Frame", self.NotifContainer)
    NotifFrame.BackgroundColor3 = Library.Theme.Background
    NotifFrame.Size = UDim2.new(1, 0, 0, 60)
    NotifFrame.Position = UDim2.new(1, 250, 0, 0)
    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 6)
    local NS = Instance.new("UIStroke", NotifFrame) NS.Color = Library.Theme.Accent NS.Thickness = 1
    local NTitle = Instance.new("TextLabel", NotifFrame)
    NTitle.BackgroundTransparency = 1 NTitle.Position = UDim2.new(0, 10, 0, 6) NTitle.Size = UDim2.new(1, -20, 0, 15)
    NTitle.Font = Enum.Font.GothamBold NTitle.Text = title NTitle.TextColor3 = Library.Theme.Text NTitle.TextSize = 12 NTitle.TextXAlignment = Enum.TextXAlignment.Left
    local NDesc = Instance.new("TextLabel", NotifFrame)
    NDesc.BackgroundTransparency = 1 NDesc.Position = UDim2.new(0, 10, 0, 24) NDesc.Size = UDim2.new(1, -20, 0, 30)
    NDesc.Font = Enum.Font.Gotham NDesc.Text = desc NDesc.TextColor3 = Library.Theme.DarkText NDesc.TextSize = 11 NDesc.TextWrapped = true NDesc.TextXAlignment = Enum.TextXAlignment.Left NDesc.TextYAlignment = Enum.TextYAlignment.Top
    TweenService:Create(NotifFrame, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    task.spawn(function()
        task.wait(duration or 4)
        TweenService:Create(NotifFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, 250, 0, 0)}):Play()
        task.wait(0.3)
        NotifFrame:Destroy()
    end)
end
function Library:CreateTab(tabText)
    local tabSelf = {}
    local TabButton = Instance.new("TextButton", self.TabContainer)
    TabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    TabButton.Size = UDim2.new(1, -6, 0, 30)
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.Text = tabText
    TabButton.TextColor3 = Library.Theme.DarkText
    TabButton.TextSize = 12
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 5)
    local TabPage = Instance.new("ScrollingFrame", self.PagesContainer)
    TabPage.Active = true
    TabPage.BackgroundTransparency = 1
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabPage.ScrollBarThickness = 2
    TabPage.Visible = false
    local PageList = Instance.new("UIListLayout", TabPage)
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
    function tabSelf:AddButton(text, callback)
        local Button = Instance.new("TextButton", TabPage)
        Button.BackgroundColor3 = Library.Theme.Element
        Button.Size = UDim2.new(1, -6, 0, 32)
        Button.Font = Enum.Font.GothamMedium
        Button.Text = "  " .. text
        Button.TextColor3 = Library.Theme.Text
        Button.TextSize = 12
        Button.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 5)
        Button.MouseButton1Click:Connect(function() pcall(callback) end)
    end
    function tabSelf:AddDropdown(text, list, callback)
        local dropCallback = callback or function() end
        local isOpened = false
        local items = list or {}
        local DropFrame = Instance.new("TextButton", TabPage)
        DropFrame.BackgroundColor3 = Library.Theme.Element
        DropFrame.Size = UDim2.new(1, -6, 0, 35)
        DropFrame.Text = ""
        Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 5)
        local DS = Instance.new("UIStroke", DropFrame) DS.Color = Color3.fromRGB(45, 45, 52) DS.Thickness = 1
        local Label = Instance.new("TextLabel", DropFrame)
        Label.BackgroundTransparency = 1 Label.Position = UDim2.new(0, 10, 0, 0) Label.Size = UDim2.new(1, -40, 1, 0)
        Label.Font = Enum.Font.Gotham Label.Text = "  " .. text .. " : Выберите..." Label.TextColor3 = Library.Theme.Text Label.TextSize = 12 Label.TextXAlignment = Enum.TextXAlignment.Left
        local Indicator = Instance.new("TextLabel", DropFrame)
        Indicator.BackgroundTransparency = 1 Indicator.Position = UDim2.new(1, -30, 0, 0) Indicator.Size = UDim2.new(0, 20, 1, 0)
        Indicator.Font = Enum.Font.GothamBold Indicator.Text = "v" Indicator.TextColor3 = Library.Theme.DarkText Indicator.TextSize = 12
        local ItemHolder = Instance.new("Frame", TabPage)
        ItemHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 24) ItemHolder.Size = UDim2.new(1, -6, 0, 0) ItemHolder.Visible = false ItemHolder.ClipsDescendants = true
        Instance.new("UICorner", ItemHolder).CornerRadius = UDim.new(0, 5)
        local UIList = Instance.new("UIListLayout", ItemHolder) UIList.Padding = UDim.new(0, 2)
        local function toggleDropdown()
            isOpened = not isOpened
            ItemHolder.Visible = true
            Indicator.Text = isOpened and "^" or "v"
            TweenService:Create(ItemHolder, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Size = isOpened and UDim2.new(1, -6, 0, UIList.AbsoluteContentSize.Y + 4) or UDim2.new(1, -6, 0, 0)
            }):Play()
            if not isOpened then task.wait(0.2) if not isOpened then ItemHolder.Visible = false end end
        end
        DropFrame.MouseButton1Click:Connect(toggleDropdown)
        for _, v in pairs(items) do
            local ItemBtn = Instance.new("TextButton", ItemHolder)
            ItemBtn.BackgroundColor3 = Library.Theme.Element
            ItemBtn.Size = UDim2.new(1, 0, 0, 28) ItemBtn.Font = Enum.Font.Gotham ItemBtn.Text = "  " .. tostring(v) ItemBtn.TextColor3 = Library.Theme.DarkText ItemBtn.TextSize = 12 ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", ItemBtn).CornerRadius = UDim.new(0, 4)
            ItemBtn.MouseButton1Click:Connect(function()
                Label.Text = "  " .. text .. " : " .. tostring(v)
                toggleDropdown()
                pcall(dropCallback, v)
            end)
        end
    end
    return tabSelf
end
return Library
