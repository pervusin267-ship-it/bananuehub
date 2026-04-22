local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Players = game.Players.LocalPlayer

local sg = Instance.new("ScreenGui", Players.PlayerGui)
sg.Name = "Fexaw_Sirius_V18"
sg.ResetOnSpawn = false

local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TS:Create(obj, TweenInfo.new(0.15), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
        end
    end)
end

local Library = {}
function Library:CreateWindow(t)
    local Main = Instance.new("Frame", sg)
    Main.Size = UDim2.new(0, 550, 0, 380)
    Main.Position = UDim2.new(0.5, -275, 0.5, -190)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    MakeDraggable(Main)

    local SideBar = Instance.new("Frame", Main)
    SideBar.Size = UDim2.new(0, 140, 1, 0)
    SideBar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    Instance.new("UICorner", SideBar)

    local Title = Instance.new("TextLabel", SideBar)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.Text = "  " .. t
    Title.TextColor3 = Color3.fromRGB(0, 150, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = "Left"
    Title.BackgroundTransparency = 1

    local TabHold = Instance.new("ScrollingFrame", SideBar)
    TabHold.Size = UDim2.new(1, 0, 1, -50)
    TabHold.Position = UDim2.new(0, 0, 0, 50)
    TabHold.BackgroundTransparency = 1
    TabHold.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabHold).Padding = UDim.new(0, 2)

    local ContainerHold = Instance.new("Frame", Main)
    ContainerHold.Size = UDim2.new(1, -150, 1, -10)
    ContainerHold.Position = UDim2.new(0, 145, 0, 5)
    ContainerHold.BackgroundTransparency = 1

    local Window = {}
    function Window:CreateTab(name)
        local TabBtn = Instance.new("TextButton", TabHold)
        TabBtn.Size = UDim2.new(1, -10, 0, 32)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.Font = Enum.Font.Gotham
        Instance.new("UICorner", TabBtn)

        local Page = Instance.new("ScrollingFrame", ContainerHold)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ContainerHold:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabHold:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(25, 25, 35) end end
            Page.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            TabBtn.TextColor3 = Color3.new(1, 1, 1)
        end)

        local Elements = {}
        function Elements:AddButton(n, callback)
            local b = Instance.new("TextButton", Page)
            b.Size = UDim2.new(1, -5, 0, 38)
            b.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
            b.Text = "  " .. n
            b.TextColor3 = Color3.new(0.8, 0.8, 0.8)
            b.TextXAlignment = "Left"
            b.Font = Enum.Font.Gotham
            Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function()
                callback()
            end)
        end

        function Elements:AddSlider(n, min, max, def, callback)
            local sF = Instance.new("Frame", Page)
            sF.Size = UDim2.new(1, -5, 0, 50)
            sF.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
            Instance.new("UICorner", sF)
            local sL = Instance.new("TextLabel", sF)
            sL.Size = UDim2.new(1, 0, 0, 25)
            sL.Text = "  " .. n .. ": " .. def
            sL.TextColor3 = Color3.new(1, 1, 1)
            sL.BackgroundTransparency, sL.TextXAlignment, sL.Font = 1, "Left", "Gotham"
            local Tray = Instance.new("Frame", sF)
            Tray.Size = UDim2.new(0.9, 0, 0, 4)
            Tray.Position = UDim2.new(0.05, 0, 0.75, 0)
            Tray.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            local Slide = Instance.new("Frame", Tray)
            Slide.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
            Slide.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            sF.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local move = UIS.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            local p = math.clamp((input.Position.X - Tray.AbsolutePosition.X) / Tray.AbsoluteSize.X, 0, 1)
                            Slide.Size = UDim2.new(p, 0, 1, 0)
                            local val = math.floor(min + (max - min) * p)
                            sL.Text = "  " .. n .. ": " .. val
                            callback(val)
                        end
                    end)
                    UIS.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end
                    end)
                end
            end)
        end

        function Elements:AddLabel(text)
            local lab = Instance.new("TextLabel", Page)
            lab.Size = UDim2.new(1, -5, 0, 25)
            lab.BackgroundTransparency = 1
            lab.Text = "  " .. text
            lab.TextColor3 = Color3.fromRGB(150, 150, 150)
            lab.TextXAlignment = "Left"
            lab.Font = Enum.Font.Gotham
            lab.TextSize = 12
        end

        function Elements:AddDropdown(n, list, callback)
            local dropFrame = Instance.new("Frame", Page)
            dropFrame.Size = UDim2.new(1, -5, 0, 35)
            dropFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
            dropFrame.ClipsDescendants = true
            Instance.new("UICorner", dropFrame)
            local btn = Instance.new("TextButton", dropFrame)
            btn.Size = UDim2.new(1, 0, 0, 35)
            btn.BackgroundTransparency = 1
            btn.Text = "  " .. n
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextXAlignment = "Left"
            btn.Font = Enum.Font.Gotham
            btn.MouseButton1Click:Connect(function()
                local isOut = dropFrame.Size.Y.Offset > 40
                TS:Create(dropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -5, 0, isOut and 35 or (35 + #list * 30))}):Play()
            end)
            for i, val in pairs(list) do
                local opt = Instance.new("TextButton", dropFrame)
                opt.Size = UDim2.new(1, 0, 0, 30)
                opt.Position = UDim2.new(0, 0, 0, 35 + (i-1)*30)
                opt.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                opt.Text = tostring(val)
                opt.TextColor3 = Color3.new(0.8, 0.8, 0.8)
                opt.MouseButton1Click:Connect(function()
                    btn.Text = "  " .. n .. ": " .. tostring(val)
                    TS:Create(dropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -5, 0, 35)}):Play()
                    callback(val)
                end)
            end
        end

        function Elements:AddKeybind(n, default, callback)
            local currentKey = default.Name
            local kb = Instance.new("TextButton", Page)
            kb.Size = UDim2.new(1, -5, 0, 38)
            kb.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
            kb.Text = "  " .. n .. ": " .. currentKey
            kb.TextColor3 = Color3.new(1, 1, 1)
            kb.TextXAlignment = "Left"
            kb.Font = Enum.Font.Gotham
            Instance.new("UICorner", kb)
            kb.MouseButton1Click:Connect(function()
                kb.Text = "  " .. n .. ": ..."
                local conn; conn = UIS.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode.Name
                        kb.Text = "  " .. n .. ": " .. currentKey
                        conn:Disconnect()
                    end
                end)
            end)
            UIS.InputBegan:Connect(function(input, gpe)
                if not gpe and input.KeyCode.Name == currentKey then callback() end
            end)
        end

        return Elements
    end
    return Window
end

local Win = Library:CreateWindow("FEXAW V18")
local Tab1 = Win:CreateTab("Main")
Tab1:AddLabel("Category 1")
Tab1:AddButton("Test Button", function() print("Clicked") end)
Tab1:AddSlider("Test Slider", 0, 100, 50, function(v) print(v) end)
Tab1:AddDropdown("Test Dropdown", {"One", "Two", "Three"}, function(v) print(v) end)
Tab1:AddKeybind("Menu Toggle", Enum.KeyCode.RightControl, function() Main.Visible = not Main.Visible end)
