local UIS = game:GetService("UserInputService")
local p = game.Players.LocalPlayer
local rs = game:GetService("RunService")

local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle = handle or frame
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local selectorGui = Instance.new("ScreenGui", p.PlayerGui)
selectorGui.Name = "GameSelector"

local selectFrame = Instance.new("Frame", selectorGui)
selectFrame.Size = UDim2.new(0, 350, 0, 200)
selectFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
selectFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", selectFrame)
makeDraggable(selectFrame)

local title = Instance.new("TextLabel", selectFrame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "ВЫБЕРИТЕ ПОЖАЛУЙСТА ИГРУ"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local function createMenu(gameName)
    selectorGui:Destroy()
    local sg = Instance.new("ScreenGui", p.PlayerGui)
    sg.Name = "RB_Final_Menu"
    sg.ResetOnSpawn = false

    local openBtn = Instance.new("TextButton", sg)
    openBtn.Size, openBtn.Position = UDim2.new(0, 55, 0, 55), UDim2.new(1, -70, 0.7, 0)
    openBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    openBtn.Text, openBtn.TextColor3, openBtn.TextSize = "RB", Color3.new(1, 1, 1), 16
    openBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
    local btnStroke = Instance.new("UIStroke", openBtn)
    btnStroke.Thickness = 3
    makeDraggable(openBtn)

    local main = Instance.new("Frame", sg)
    main.Size, main.Position = UDim2.new(0, 400, 0, 350), UDim2.new(0.5, -200, 0.5, -175)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    main.Visible = false
    Instance.new("UICorner", main)
    local mS = Instance.new("UIStroke", main)
    mS.Thickness = 2
    makeDraggable(main)

    local sidebar = Instance.new("Frame", main)
    sidebar.Size, sidebar.BackgroundColor3 = UDim2.new(0, 100, 1, 0), Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", sidebar)

    local container = Instance.new("Frame", main)
    container.Position, container.Size = UDim2.new(0, 110, 0, 10), UDim2.new(1, -120, 1, -20)
    container.BackgroundTransparency = 1

    local mainPage = Instance.new("Frame", container)
    mainPage.Size, mainPage.Visible, mainPage.BackgroundTransparency = UDim2.new(1, 0, 1, 0), true, 1
    Instance.new("UIListLayout", mainPage).Padding = UDim.new(0, 10)

    local basePage = Instance.new("Frame", container)
    basePage.Size, basePage.Visible, basePage.BackgroundTransparency = UDim2.new(1, 0, 1, 0), false, 1
    Instance.new("UIListLayout", basePage).Padding = UDim.new(0, 10)

    local function createTab(name, pos, page)
        local btn = Instance.new("TextButton", sidebar)
        btn.Size, btn.Position = UDim2.new(0.9, 0, 0, 40), UDim2.new(0.05, 0, 0, pos)
        btn.Text, btn.BackgroundColor3 = name, Color3.fromRGB(30, 30, 30)
        btn.TextColor3, btn.Font = Color3.new(1, 1, 1), Enum.Font.GothamBold
        Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function()
            mainPage.Visible, basePage.Visible = false, false
            page.Visible = true
        end)
    end

    createTab("Main", 10, mainPage)
    if gameName == "Brainrot" then createTab("Base", 60, basePage) end

    task.spawn(function()
        while task.wait() do
            local color = Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
            btnStroke.Color, mS.Color, openBtn.TextColor3 = color, color, color
        end
    end)

    openBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

    local speedInput = Instance.new("TextBox", mainPage)
    speedInput.Size, speedInput.BackgroundColor3 = UDim2.new(1, 0, 0, 40), Color3.fromRGB(30, 30, 30)
    speedInput.PlaceholderText = "СКОРОСТЬ (1-400)"
    speedInput.Text, speedInput.TextColor3 = "", Color3.new(1, 1, 1)
    Instance.new("UICorner", speedInput)
    speedInput.FocusLost:Connect(function()
        local num = tonumber(speedInput.Text)
        if num and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid.WalkSpeed = math.clamp(num, 1, 400)
        end
    end)

    if gameName == "Brainrot" then
        local baseBtn = Instance.new("TextButton", basePage)
        baseBtn.Size, baseBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 40), Color3.fromRGB(40, 40, 40)
        baseBtn.Text, baseBtn.TextColor3 = "АКТИВИРОВАТЬ БАЗУ", Color3.new(1, 1, 1)
        Instance.new("UICorner", baseBtn)
        baseBtn.MouseButton1Click:Connect(function()
            loadstring(game:HttpGet('https://sirius.menu'))()
        end)

        local cloneBtn = Instance.new("TextButton", mainPage)
        cloneBtn.Size, cloneBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 40), Color3.fromRGB(30, 30, 30)
        cloneBtn.Text, cloneBtn.TextColor3 = "FAKE CLONE: OFF", Color3.new(1, 1, 1)
        Instance.new("UICorner", cloneBtn)
        local fakeClone = nil
        _G.CloneActive = false
        cloneBtn.MouseButton1Click:Connect(function()
            _G.CloneActive = not _G.CloneActive
            cloneBtn.Text = "FAKE CLONE: " .. (_G.CloneActive and "ON" or "OFF")
            if _G.CloneActive then
                p.Character.Archivable = true
                fakeClone = p.Character:Clone()
                fakeClone.Parent = workspace
                p.Character.HumanoidRootPart.Anchored = true
                workspace.CurrentCamera.CameraSubject = fakeClone.Humanoid
            else
                if fakeClone then fakeClone:Destroy() end
                p.Character.HumanoidRootPart.Anchored = false
                workspace.CurrentCamera.CameraSubject = p.Character.Humanoid
            end
        end)
    elseif gameName == "DeadRails" then
        local staticVacBtn = Instance.new("TextButton", mainPage)
        staticVacBtn.Size, staticVacBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 50), Color3.fromRGB(30, 30, 30)
        staticVacBtn.Text, staticVacBtn.TextColor3 = "AUTO BOND FARM: OFF", Color3.new(1, 1, 1)
        Instance.new("UICorner", staticVacBtn)
        _G.StaticVac = false
        staticVacBtn.MouseButton1Click:Connect(function()
            _G.StaticVac = not _G.StaticVac
            staticVacBtn.Text = "AUTO BOND FARM: " .. (_G.StaticVac and "ON" or "OFF")
            task.spawn(function()
                while _G.StaticVac do
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v.Name:lower():find("bond") and v:IsA("BasePart") then
                            v.CFrame = p.Character.HumanoidRootPart.CFrame
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end)
    end
end

local bBtn = Instance.new("TextButton", selectFrame)
bBtn.Size, bBtn.Position = UDim2.new(0.9, 0, 0, 50), UDim2.new(0.05, 0, 0.3, 0)
bBtn.BackgroundColor3, bBtn.Text, bBtn.TextColor3 = Color3.fromRGB(0, 120, 255), "Укради Брайанрот", Color3.new(1,1,1)
Instance.new("UICorner", bBtn)
bBtn.MouseButton1Click:Connect(function() createMenu("Brainrot") end)

local dBtn = Instance.new("TextButton", selectFrame)
dBtn.Size, dBtn.Position = UDim2.new(0.9, 0, 0, 50), UDim2.new(0.05, 0, 0.6, 0)
dBtn.BackgroundColor3, dBtn.Text, dBtn.TextColor3 = Color3.fromRGB(200, 0, 0), "Dead Rails (Мертвые рельсы)", Color3.new(1,1,1)
Instance.new("UICorner", dBtn)
dBtn.MouseButton1Click:Connect(function() createMenu("DeadRails") end)
