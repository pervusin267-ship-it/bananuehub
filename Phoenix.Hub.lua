local UIS = game:GetService("UserInputService")
local p = game.Players.LocalPlayer
local rs = game:GetService("RunService")

local function BuildYinYangBase()
    local char = p.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local startPos = char.HumanoidRootPart.CFrame * CFrame.new(0, -3, -30)
    local f = Instance.new("Folder", workspace)
    f.Name = "YinYangBase"

    local function cP(cf, s, col, mat, tr)
        local part = Instance.new("Part", f)
        part.Size, part.CFrame, part.Anchored = s, cf, true
        part.Color, part.Material, part.Transparency = col, mat or Enum.Material.SmoothPlastic, tr or 0
        return part
    end

    cP(startPos, Vector3.new(40, 1, 40), Color3.new(0,0,0))
    cP(startPos * CFrame.new(0, 12, 0), Vector3.new(40, 1, 40), Color3.new(1,1,1))
    cP(startPos * CFrame.new(0, 24, 0), Vector3.new(40, 1, 40), Color3.new(0,0,0))

    local wC = {
        {p = CFrame.new(0, 6, 20), c = Color3.new(1,1,1), o = Color3.new(0,0,0)},
        {p = CFrame.new(0, 6, -20), c = Color3.new(0,0,0), o = Color3.new(1,1,1)},
        {p = CFrame.new(20, 6, 0) * CFrame.Angles(0, 1.57, 0), c = Color3.new(1,1,1), o = Color3.new(0,0,0)},
        {p = CFrame.new(-20, 6, 0) * CFrame.Angles(0, 1.57, 0), c = Color3.new(0,0,0), o = Color3.new(1,1,1)}
    }

    for _, w in pairs(wC) do
        for l = 0, 1 do
            local cp = startPos * w.p * CFrame.new(0, l * 12, 0)
            local wc = (l == 0) and w.c or w.o
            local oc = (l == 0) and w.o or w.c
            cP(cp, Vector3.new(40, 12, 1), wc)
            cP(cp * CFrame.new(0, 5.5, 0.6), Vector3.new(40, 1, 1.2), oc)
            cP(cp * CFrame.new(0, -5.5, 0.6), Vector3.new(40, 1, 1.2), oc)
            cP(cp, Vector3.new(32, 8, 1.1), Color3.fromRGB(163, 162, 165), Enum.Material.Glass, 0.5)
        end
    end

    for i = -18, 18, 4 do
        cP(startPos * CFrame.new(i, 6, 19.4), Vector3.new(0.3, 11, 0.3), Color3.new(1,0,0), Enum.Material.Neon)
    end

    for i = 1, 24 do
        cP(startPos * CFrame.new(16, i * 0.5, i - 15), Vector3.new(8, 0.5, 2), Color3.new(1,1,1))
    end
end

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
selectorGui.Name = "PhoenixSelector"

local selectFrame = Instance.new("Frame", selectorGui)
selectFrame.Size = UDim2.new(0, 350, 0, 200)
selectFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
selectFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", selectFrame)
makeDraggable(selectFrame)

local title = Instance.new("TextLabel", selectFrame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "PHOENIX HUB: SELECT GAME"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local function createMenu(gameName)
    selectorGui:Destroy()
    local sg = Instance.new("ScreenGui", p.PlayerGui)
    sg.Name = "PhoenixHub"
    sg.ResetOnSpawn = false

    local openBtn = Instance.new("TextButton", sg)
    openBtn.Size, openBtn.Position = UDim2.new(0, 55, 0, 55), UDim2.new(1, -70, 0.7, 0)
    openBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    openBtn.Text, openBtn.TextColor3, openBtn.TextSize = "PH", Color3.new(1, 1, 1), 16
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

    _G.Noclip = false
    rs.Stepped:Connect(function()
        if _G.Noclip and p.Character then
            for _, v in pairs(p.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end
    end)

    local noclipBtn = Instance.new("TextButton", mainPage)
    noclipBtn.Size, noclipBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 40), Color3.fromRGB(30, 30, 30)
    noclipBtn.Text, noclipBtn.TextColor3 = "NOCLIP: OFF (N)", Color3.new(1, 1, 1)
    Instance.new("UICorner", noclipBtn)
    noclipBtn.MouseButton1Click:Connect(function()
        _G.Noclip = not _G.Noclip
        noclipBtn.Text = "NOCLIP: " .. (_G.Noclip and "ON" or "OFF") .. " (N)"
    end)

    UIS.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.N then
            _G.Noclip = not _G.Noclip
            noclipBtn.Text = "NOCLIP: " .. (_G.Noclip and "ON" or "OFF") .. " (N)"
        end
    end)

    task.spawn(function()
        while task.wait() do
            local color = Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
            btnStroke.Color, mS.Color, openBtn.TextColor3 = color, color, color
        end
    end)

    openBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

    local speedInput = Instance.new("TextBox", mainPage)
    speedInput.Size, speedInput.BackgroundColor3 = UDim2.new(1, 0, 0, 40), Color3.fromRGB(30, 30, 30)
    speedInput.PlaceholderText = "WALKSPEED (1-400)"
    speedInput.Text, speedInput.TextColor3 = "", Color3.new(1, 1, 1)
    Instance.new("UICorner", speedInput)
    speedInput.FocusLost:Connect(function()
        local num = tonumber(speedInput.Text)
        if num and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid.WalkSpeed = math.clamp(num, 1, 400)
        end
    end)

    if gameName == "Brainrot" then
        local rbBtn = Instance.new("TextButton", basePage)
        rbBtn.Size, rbBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 40), Color3.fromRGB(40, 40, 40)
        rbBtn.Text, rbBtn.TextColor3 = "ACTIVATE RAINBOW BASE", Color3.new(1, 1, 1)
        Instance.new("UICorner", rbBtn)
        rbBtn.MouseButton1Click:Connect(function()
            loadstring(game:HttpGet('https://sirius.menu'))()
        end)

        local yyBtn = Instance.new("TextButton", basePage)
        yyBtn.Size, yyBtn.BackgroundColor3 = UDim2.new(1, 0, 0, 40), Color3.fromRGB(20, 20, 20)
        yyBtn.Text, yyBtn.TextColor3 = "YIN YANG BASE", Color3.new(1, 1, 1)
        yyBtn.Font = Enum.Font.GothamBold
        Instance.new("UICorner", yyBtn)
        local yStroke = Instance.new("UIStroke", yyBtn)
        yStroke.Thickness, yStroke.Color = 2, Color3.new(1, 1, 1)
        yyBtn.MouseButton1Click:Connect(function() BuildYinYangBase() end)

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
bBtn.BackgroundColor3, bBtn.Text, bBtn.TextColor3 = Color3.fromRGB(0, 120, 255), "Steal Brainrot", Color3.new(1,1,1)
Instance.new("UICorner", bBtn)
bBtn.MouseButton1Click:Connect(function() createMenu("Brainrot") end)

local dBtn = Instance.new("TextButton", selectFrame)
dBtn.Size, dBtn.Position = UDim2.new(0.9, 0, 0, 50), UDim2.new(0.05, 0, 0.6, 0)
dBtn.BackgroundColor3, dBtn.Text, dBtn.TextColor3 = Color3.fromRGB(200, 0, 0), "Dead Rails", Color3.new(1,1,1)
Instance.new("UICorner", dBtn)
dBtn.MouseButton1Click:Connect(function() createMenu("DeadRails") end)
