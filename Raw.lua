local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local p = game.Players.LocalPlayer
local sg = Instance.new("ScreenGui", p.PlayerGui)
sg.Name = "FexawV3_Final_Mega"
sg.ResetOnSpawn = false

local targetHeight = 380
local targetWidth = 520

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 0, 0, 0) 
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Visible = false
main.ClipsDescendants = true 
Instance.new("UICorner", main)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Thickness = 3
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local side = Instance.new("Frame", main)
side.Size, side.BackgroundColor3 = UDim2.new(0, 160, 1, 0), Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", side)

local sideStroke = Instance.new("UIStroke", side)
sideStroke.Thickness = 2
sideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local ob = Instance.new("Frame", sg)
ob.Size, ob.Position = UDim2.new(0, 350, 0, 40), UDim2.new(0.5, -175, 0.2, 0)
ob.BackgroundColor3, ob.BackgroundTransparency = Color3.fromRGB(15, 15, 15), 0.2
Instance.new("UICorner", ob)

local obStroke = Instance.new("UIStroke", ob)
obStroke.Thickness = 2
obStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

task.spawn(function()
    local hue = 0
    while true do
        local color = Color3.fromHSV(hue, 1, 1)
        mainStroke.Color = color
        sideStroke.Color = color
        obStroke.Color = color
        hue = hue + 0.005
        if hue > 1 then hue = 0 end
        task.wait(0.01)
    end
end)

local dragBtn = Instance.new("TextButton", ob)
dragBtn.Size = UDim2.new(0, 60, 1, 0)
dragBtn.BackgroundTransparency = 1
dragBtn.Text = "÷  |"
dragBtn.TextColor3 = Color3.new(1, 1, 1)
dragBtn.TextSize = 22
dragBtn.Font = Enum.Font.SourceSansBold

local openBtn = Instance.new("TextButton", ob)
openBtn.Size = UDim2.new(1, -65, 1, 0)
openBtn.Position = UDim2.new(0, 65, 0, 0)
openBtn.BackgroundTransparency = 1
openBtn.Text = "FEXAW | All Systems Online"
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.TextXAlignment = Enum.TextXAlignment.Left

local dragging, dragStart, startPos, startPosMain
local function update(input)
    local delta = input.Position - dragStart
    ob.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    main.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y)
end

dragBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ob.Position
        startPosMain = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        update(input)
    end
end)

local function toggle()
    if not main.Visible then
        main.Visible = true
        TS:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, targetWidth, 0, targetHeight)}):Play()
    else
        local tw = TS:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        tw:Play()
        tw.Completed:Connect(function() if main.Size.Y.Offset < 10 then main.Visible = false end end)
    end
end

openBtn.MouseButton1Click:Connect(toggle)

local mP = Instance.new("ScrollingFrame", main)
mP.Position, mP.Size, mP.BackgroundTransparency = UDim2.new(0, 170, 0, 10), UDim2.new(1, -180, 1, -20), 1
mP.ScrollBarThickness = 3
mP.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIListLayout", mP).Padding = UDim.new(0, 5)

local GE = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents")
local sRem = GE:WaitForChild("BuySeedStock")
local eRem = GE:WaitForChild("BuyEventShopStock")
local gRem = GE:WaitForChild("BuyGearStock")
local pRem = GE:WaitForChild("BuyPetEgg")

local function CreateCategory(name)
    local frame = Instance.new("Frame", mP)
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = "v " .. name .. " v"
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn)
    local container = Instance.new("Frame", mP)
    container.Size = UDim2.new(1, -10, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.Visible = false
    Instance.new("UIListLayout", container).Padding = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(function()
        container.Visible = not container.Visible
        btn.Text = (container.Visible and "^ " or "v ") .. name .. (container.Visible and " ^" or " v")
    end)
    return container
end

local function AddToggle(parent, name, type)
    local active = false
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.Text, b.TextColor3 = name, Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        active = not active
        TS:Create(b, TweenInfo.new(0.3), {BackgroundColor3 = active and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(40, 40, 40)}):Play()
        task.spawn(function()
            while active do
                pcall(function() 
                    if type == "Seed" then sRem:FireServer("Shop", name)
                    elseif type == "Event" then eRem:FireServer(name, "Easter Seed Shop")
                    elseif type == "Gear" then gRem:FireServer(name)
                    elseif type == "Egg" then pRem:FireServer(name) end
                end)
                task.wait(0.3)
            end
        end)
    end)
end

local sC = CreateCategory("SEED SHOP")
local seeds = {"Carrot", "Strawberry", "Blueberry Buttercup", "Tomato", "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "MangoGrape", "Mushroom", "Pepper", "Cacao", "Sunflower", "Beanstalk", "Ember Lily", "Sugar Apple", "Burning Bud", "Giant Pinecone", "Elder Strawberry", "Romanesco", "Crimson Thorn", "Zebrazinkle", "Octobloom", "Alien Apple", "Eggsnapper"}
for _, s in pairs(seeds) do AddToggle(sC, s, "Seed") end

local eC = CreateCategory("EVENT SHOP")
local evs = {"Easter Candy Carrot", "Easter Chocolate Berry", "Easter Gumball", "Easter Liquorice Beaver", "Chocolate Spinkler", "Easter Sugar Melon", "Easter Chocolate Coconut", "Gummy Bear", "Easter Gummy Cactus", "Easter Egg Melon", "Hootsie Roll", "Easter Sour Lemon", "Springtide Egg", "Easter Egg Fruit"}
for _, e in pairs(evs) do AddToggle(eC, e, "Event") end

local gC = CreateCategory("GEAR SHOP")
local gears = {"Magnifying Glass", "Pet Lead", "Trowel", "Recall Wrench", "Trading Ticket", "Friendship Pot", "Harvest Tool", "Favorite Tool", "Cleaning Pet Shard", "Cleaning Spray", "Medium Treat", "Watering Can", "Basic Sprinkler", "Advanced Sprinkler", "Gogly Sprinkler", "Master Sprinkler", "Grandmaster Sprinkler", "Medium Toy", "Levelup Lollipop"}
for _, g in pairs(gears) do AddToggle(gC, g, "Gear") end

local egC = CreateCategory("EGG SHOP")
local eggs = {"Common Egg", "Uncommon Egg", "Rare Egg", "Legendary Egg", "Mythical Egg", "Bug Egg", "Jungle Egg"}
for _, eg in pairs(eggs) do AddToggle(egC, eg, "Egg") end
