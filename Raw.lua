local UIS = game:GetService("UserInputService")
local p = game.Players.LocalPlayer
local sg = Instance.new("ScreenGui", p.PlayerGui)
sg.Name = "FexawV3_Final_Mega"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size, main.Position = UDim2.new(0, 520, 0, 340), UDim2.new(0.5, -260, 0.5, -170)
main.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
main.Visible = false
Instance.new("UICorner", main)

local dragging, dragInput, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = input.Position startPos = main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local side = Instance.new("Frame", main)
side.Size, side.BackgroundColor3 = UDim2.new(0, 160, 1, 0), Color3.fromRGB(0, 50, 150)
Instance.new("UICorner", side)

local tabLabel = Instance.new("TextLabel", side)
tabLabel.Size, tabLabel.Position = UDim2.new(1, -20, 0, 35), UDim2.new(0, 10, 0, 70)
tabLabel.BackgroundColor3, tabLabel.BackgroundTransparency = Color3.new(0,0,0), 0.5
tabLabel.Text, tabLabel.TextColor3 = "Main", Color3.new(1, 1, 1)
Instance.new("UICorner", tabLabel)

local mP = Instance.new("ScrollingFrame", main)
mP.Position, mP.Size, mP.BackgroundTransparency = UDim2.new(0, 170, 0, 10), UDim2.new(1, -180, 1, -20), 1
mP.ScrollBarThickness = 3
mP.CanvasSize = UDim2.new(0, 0, 0, 3200)
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
    btn.BackgroundColor3 = Color3.fromRGB(0, 30, 100)
    btn.Text = "v " .. name .. " v"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
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
    b.BackgroundColor3 = Color3.fromRGB(0, 50, 150)
    b.Text, b.TextColor3 = name, Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        active = not active
        b.BackgroundColor3 = active and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(0, 50, 150)
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

local ob = Instance.new("Frame", sg)
ob.Size, ob.Position = UDim2.new(0, 350, 0, 40), UDim2.new(0.5, -175, 0, 5)
ob.BackgroundColor3, ob.BackgroundTransparency = Color3.new(0,0,0), 0.4
Instance.new("UICorner", ob)

local obT = Instance.new("TextButton", ob)
obT.Size, obT.Position, obT.BackgroundTransparency = UDim2.new(1, -40, 1, 0), UDim2.new(0, 40, 0, 0), 1
obT.Text, obT.TextColor3 = "FEXAW | All Systems Online", Color3.new(1, 1, 1)

local ot = Instance.new("TextButton", ob)
ot.Size, ot.BackgroundTransparency, ot.Text, ot.TextColor3, ot.TextSize = UDim2.new(0, 40, 1, 0), 1, "÷", Color3.new(1, 1, 1), 25

local function toggle() main.Visible = not main.Visible end
ot.MouseButton1Click:Connect(toggle)
obT.MouseButton1Click:Connect(toggle)
