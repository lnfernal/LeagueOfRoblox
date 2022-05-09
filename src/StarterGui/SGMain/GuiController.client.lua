--the player
local Player = game.Players.LocalPlayer
--Stats
local Stats
--our screen gui
local ScreenGui = script.Parent
--remotes
local R = game.ReplicatedStorage.Remotes
--game state
local gameState = game.ReplicatedStorage.GameState
--base guis
local Frame, Text, Button = unpack(require(game.ReplicatedStorage.BaseGuis))
--the color scheme
local ColorScheme = require(game.ReplicatedStorage.ColorScheme)
--this container holds all of the gui elements
local Gui = {}
--this global holds a position offset for anything in the bottom-left corner
local BottomLeftOffset = UDim2.new(0, 0, 0, -50)
--this global holds the player state, and remains empty until acquired
local PlayerState
--this global holds the mouse-over box
local MouseOverBox = nil
local MouseOveritem = nil
--this global holds the mouse
local Mouse = Player:GetMouse()

--this function returns the thumbnail of an asset
local getThumbnail = require(game.ReplicatedStorage.GetThumbnail)

--this function returns a value from the player state
local function playerGet(key)
	local val = PlayerState:FindFirstChild(key)
	if val then
		return val.Value
	end
	return nil
end
--Get stats that can be buffed
local function getStat(stat)
	return Stats.StatsGet(stat)
end
--Normal Stats itself
local function getStatNormal(stat)
	local STATS = Stats.Stats
	return Stats.BaseStatGet(stat)
end

--this function lerps between a and b
local function lerp(a, b, p)
	return a + (b - a) * p
end

--this function lerps a color
local function lerpColor(a, b, p)
	a = Vector3.new(a.r, a.g, a.b)
	b = Vector3.new(b.r, b.g, b.b)
	local l = lerp(a, b, p)
	l = Color3.new(l.x, l.y, l.z)
	return l
end

--this function truncates a value to a certain number of places
local function trunc(num, places)
	num = num or 0
	places = places or 0
	
	return math.floor(num * 10 ^ places) / 10 ^ places
end

--this function returns a string from a time
function getTimeString(t)
	local minutes = math.floor(t / 60)
	local seconds = math.floor(t - minutes * 60)
	if seconds < 10 then
		seconds = "0"..seconds
	end
	
	return minutes..":"..seconds
end

--this function insets a gui object
local function inset(element, amount)
	element.Position = element.Position + UDim2.new(0, amount, 0, amount)
	element.Size = element.Size + UDim2.new(0, -(amount * 2), 0, -(amount * 2))
end

--this function clears the mouse over box
local function endMouseOver()
	if MouseOverBox then
		MouseOverBox:Destroy()
	end
end

--this function returns whether or not a table contains a value
local function contains(t, v)
	for _, val in pairs(t) do
		if val == v then
			return true
		end
	end
	return false
end

--this function generates a new mouse over box
local function startMouseOver(x, y, t)
	endMouseOver()
	
	local frame = Frame:Clone()
	frame.Size = UDim2.new(0.3, 0, 0.2, 0)
	local dy = -(ScreenGui.AbsoluteSize.Y * frame.Size.Y.Scale)
	frame.Position = UDim2.new(0, x, 0, y + dy)
	frame.BackgroundColor3 = ColorScheme.Quaternary
	frame.BorderColor3 = ColorScheme.Dark
	frame.ZIndex = 10
	MouseOverBox = frame
	frame.Parent = ScreenGui
	
	local text = Text:Clone()
	text.TextXAlignment = Enum.TextXAlignment.Left
	text.Text = t
	text.Size = UDim2.new(1, 0, 1, 0)
	text.ZIndex = 10
	text.Parent = frame
	inset(text, 4)
		
	if frame.AbsolutePosition.X + frame.AbsoluteSize.X > ScreenGui.AbsoluteSize.X then
		frame.Position = frame.Position + UDim2.new(0, -frame.AbsoluteSize.X, 0, 0)
	end
end
--Just for items a copy of the said functions
local function endMouseOver2()
	if MouseOveritem then
		MouseOveritem:Destroy()
	end
end
local function startMouseOver2(x, y, t)
	endMouseOver2()
	
	local frame = Frame:Clone()
	frame.Size = UDim2.new(0.3, 0, 0.2, 0)
	local dy = -(ScreenGui.AbsoluteSize.Y * frame.Size.Y.Scale)
	frame.Position = UDim2.new(0, x, 0, y + dy)
	frame.BackgroundColor3 = ColorScheme.Quaternary
	frame.BorderColor3 = ColorScheme.Dark
	frame.ZIndex = 10
	MouseOveritem = frame
	frame.Parent = ScreenGui
	
	local text = Text:Clone()
	text.TextXAlignment = Enum.TextXAlignment.Left
	text.Text = t
	text.Size = UDim2.new(1, 0, 1, 0)
	text.ZIndex = 10
	text.Parent = frame
	inset(text, 4)
		
	if frame.AbsolutePosition.X + frame.AbsoluteSize.X > ScreenGui.AbsoluteSize.X then
		frame.Position = frame.Position + UDim2.new(0, -frame.AbsoluteSize.X, 0, 0)
	end
end
local function mouseOver2(element, moved)
	element.MouseMoved:connect(moved)
	element.MouseLeave:connect(endMouseOver2)
end
--this function tailors a mouse over event for a gui element
local function mouseOver(element, moved)
	element.MouseMoved:connect(moved)
	element.MouseLeave:connect(endMouseOver)
end

--this function constructs a single stat gui, ready for positioning and filling out
local function constructStatGui(container, position)
	--create the container frame, which we will return
	local frame = Frame:Clone()
	frame.Size = UDim2.new(0.5, 0, 1/3, 0)
	frame.Position = position
	frame.BackgroundColor3 = ColorScheme.Tertiary
	frame.BorderColor3 = ColorScheme.Quaternary
	frame.Parent = container
	inset(frame, 2)
		
	--create an image label
	local image = Instance.new("ImageLabel")
	image.Name = "Image"
	image.Size = UDim2.new(1, 0, 1, 0)
	image.SizeConstraint = Enum.SizeConstraint.RelativeYY
	image.BackgroundTransparency = 1
	image.Parent = frame
	
	--create text to fill in the rest
	local text = Text:Clone()
	text.Name = "Text"
	text.Size = UDim2.new(1, -image.AbsoluteSize.X, 1, 0)
	text.Position = UDim2.new(0, image.AbsoluteSize.X, 0, 0)
	text.Parent = frame
	
	--now that math is done, inset these
	inset(image, 2)
	inset(text, 2)
	
	--all done, return the construct
	return frame
end

--this function constructs the stats gui
local function constructStatsGui()
	--prep the stats container
	Gui.Stats = {}
	
	--first, create a frame in which to place each block
	local frame = Frame:Clone()
	frame.Name = "StatsFrame"
	frame.Size = UDim2.new(0.2, 0, 0.125, 0)
	frame.Position = UDim2.new(0.02, 0, .925, 0) + BottomLeftOffset
	frame.BackgroundColor3 = ColorScheme.Tertiary
	frame.BorderColor3 = ColorScheme.Quaternary
	frame.Parent = ScreenGui
	Gui.Stats.Frame = frame
		
	--create a skillz block
	local skillz = constructStatGui(frame, UDim2.new())
	skillz.Image.Image = "rbxassetid://155541519"
	Gui.Stats.Skillz = skillz
	
	--create a h4x block
	local h4x = constructStatGui(frame, UDim2.new(0, 0, 1/3, 0))
	h4x.Image.Image = "rbxassetid://155646619"
	Gui.Stats.H4x = h4x
	
	--create a toughness block
	local toughness = constructStatGui(frame, UDim2.new(0.5, 0, 0, 0))
	toughness.Image.Image = "rbxassetid://156086074"
	Gui.Stats.Toughness = toughness
	
	--create a resistance block
	local resistance = constructStatGui(frame, UDim2.new(0.5, 0, 1/3, 0))
	resistance.Image.Image = "rbxassetid://156213588"
	Gui.Stats.Resistance = resistance
	
	--create a speed block
	local speed = constructStatGui(frame, UDim2.new(0, 0, 2/3, 0))
	speed.Image.Image = "rbxassetid://156213625"
	Gui.Stats.Speed = speed
	
	--create a tix block
	local tix = constructStatGui(frame, UDim2.new(0.5, 0, 2/3, 0))
	tix.Image.Image = "rbxassetid://17959786"
	Gui.Stats.Tix = tix
	
	--create some object-oriented methods/variables for stats
	--this method updates a single stat block
	function Gui.Stats.UpdateStat(stat, value, places)
		places = places or 1
		
		Gui.Stats[stat].Text.Text = trunc(value, places)
	end
	
	--this method updates all of the stat blocks, for readability
	function Gui.Stats.Update()
		local speed = Player.Character.Humanoid.WalkSpeed
		Gui.Stats.UpdateStat("Skillz", getStat"Skillz")
		Gui.Stats.UpdateStat("H4x", getStat"H4x")
		Gui.Stats.UpdateStat("Toughness", getStat"Toughness")
		Gui.Stats.UpdateStat("Resistance", getStat"Resistance")
		Gui.Stats.UpdateStat("Speed", speed)
		Gui.Stats.UpdateStat("Tix", getStatNormal"Tix", 0)
	end
end

--this function constructs portrait and name gui (fairly simple)
local function constructPortraitGui()
	--prepare a container
	Gui.Portrait = {}
	
	--construct a frame to contain the image
	local frame = Frame:Clone()
	frame.Name = "PortraitFrame"
	frame.Size = UDim2.new(0.1, 0, 0.1, 0)
	frame.SizeConstraint = Enum.SizeConstraint.RelativeYY
	frame.Position = Gui.Stats.Frame.Position + UDim2.new(0, 0, -0.1, 0)
	frame.BorderColor3 = playerGet"TeamColor".Color
	frame.BorderSizePixel = 3
	frame.BackgroundColor3 = ColorScheme.Tertiary
	frame.Parent = ScreenGui
	Gui.Portrait.Frame = frame
	
	--insert an image into the frame
	local image = Instance.new("ImageLabel")
	image.Name = "Image"
	image.Size = UDim2.new(1, 0, 1, 0)
	image.BackgroundTransparency = 1
	image.Image = playerGet"CharacterPortrait"
	image.Parent = frame
	Gui.Portrait.Image = image
	
	--insert a bordered frame to contain the level of the player
	local levelFrame = Frame:Clone()
	levelFrame.Size = UDim2.new(0.45, 0, 0.45, 0)
	levelFrame.Position = UDim2.new(0.775, 0, -0.225, 0)
	levelFrame.BackgroundColor3 = ColorScheme.Tertiary
	levelFrame.BorderColor3 = ColorScheme.Dark
	levelFrame.Parent = frame
	
	--insert the level tracker
	local levelText = Text:Clone()
	levelText.Size = UDim2.new(1, 0, 1, 0)
	levelText.Parent = levelFrame
	Gui.Portrait.LevelText = levelText
	

	
	--finished with math, perform insets
	inset(frame, 6)
	inset(image, 2)
	
	--object orientation
	--this method updates the portrait gui, basically sets the level text
	function Gui.Portrait.Update()
		Gui.Portrait.LevelText.Text = getStatNormal"Level"
	end
end

--this function creates the 'bar' gui (health and exp)
local function constructBarsGui()
	--create a container
	Gui.Bars = {}
	
	--create the container frame
	local frame = Frame:Clone()
	frame.Name = "BarsFrame"
	frame.Size = UDim2.new(0.3, 0, 0.05, 0)
	frame.Position = UDim2.new(0.35, 0, 0.95, 0)
	frame.Parent = ScreenGui
	frame.BackgroundColor3 = ColorScheme.Quaternary
	frame.BorderColor3 = ColorScheme.Tertiary
	frame.ZIndex = 2
	Gui.Bars.Frame = frame
	
	--create the health frame
	local healthFrame = Frame:Clone()
	healthFrame.Size = UDim2.new(1, 0, 0.5, 0)
	healthFrame.BackgroundColor3 = ColorScheme.Dark
	healthFrame.BorderColor3 = ColorScheme.Dark
	healthFrame.BorderSizePixel = 2
	healthFrame.Parent = frame
	healthFrame.ZIndex = 2
	Gui.Bars.HealthFrame = healthFrame
	
	--create the health bar
	local healthBar = Frame:Clone()
	healthBar.Size = UDim2.new(1, 0, 1, 0)
	healthBar.BorderSizePixel = 0
	healthBar.Parent = healthFrame
	healthBar.ZIndex = 2
	Gui.Bars.HealthBar = healthBar
	
	--create the health label
	local healthText = Text:Clone()
	healthText.Size = UDim2.new(1, 0, 1, 0)
	healthText.Parent = healthFrame
	healthText.ZIndex = 2
	healthText.TextScaled = false
	Gui.Bars.HealthText = healthText
	--Shield Frame
	local shieldBar = Frame:Clone()
	shieldBar.Size = UDim2.new(0, 0, 1, 0)
	shieldBar.BorderSizePixel = 0
	shieldBar.Parent = healthFrame
	shieldBar.ZIndex = 2
	Gui.Bars.shieldBar = shieldBar
	
	--create the shield label
	local shieldText = Text:Clone()
	shieldText.Size = UDim2.new(1, 0, 1, 0)
	shieldText.Parent = healthFrame
	shieldText.ZIndex = 2
	shieldText.TextScaled = false
	shieldText.TextXAlignment = "Right"
	Gui.Bars.shieldText = shieldText
	--create the exp frame
	local expFrame = Frame:Clone()
	expFrame.Size = UDim2.new(1, 0, 0.5, 0)
	expFrame.Position = UDim2.new(0, 0, 0.5, 0)
	expFrame.BackgroundColor3 = ColorScheme.Dark
	expFrame.BorderColor3 = ColorScheme.Dark
	expFrame.BorderSizePixel = 2
	expFrame.Parent = frame
	expFrame.ZIndex = 2
	Gui.Bars.ExpFrame = expFrame
	
	--create the exp bar
	local expBar = Frame:Clone()
	expBar.Size = UDim2.new(1, 0, 1, 0)
	expBar.BackgroundColor3 = ColorScheme.Tertiary
	expBar.BorderSizePixel = 0
	expBar.Parent = expFrame
	expBar.ZIndex = 2
	Gui.Bars.ExpBar = expBar
	
	--create the exp text
	local expText = Text:Clone()
	expText.Size = UDim2.new(1, 0, 1, 0)
	expText.Parent = expFrame
	expText.ZIndex = 2
	expText.TextScaled = false
	Gui.Bars.ExpText = expText
	
	--insets
	inset(frame, 4)
	inset(healthFrame, 4)
	inset(expFrame, 4)
	
	--create object-oriented methods for ease
	--this method updates the health bar
	function Gui.Bars.UpdateHealth()
		local health = Player.Character.Humanoid.Health
		local max = Player.Character.Humanoid.MaxHealth
		local shields = Player.Character:WaitForChild("Shield").Value
		local p = health / (max + shields)
		local d = shields/ (max + shields)
		local c = lerpColor(ColorScheme.HealthLow, ColorScheme.HealthFull, p)
		Gui.Bars.HealthBar.Size = UDim2.new(p, 0, 1, 0)
		Gui.Bars.HealthBar.BackgroundColor3 = c
		Gui.Bars.HealthText.Text = "Health: "..trunc(health, 0).." / "..trunc(max, 0)..(" (+ "..trunc(getStat("HealthRegen"),3).." s)")
		Gui.Bars.shieldBar.Size = UDim2.new(d, 0, 1, 0)
		Gui.Bars.shieldBar.Position = UDim2.new(p, 0, 0, 0)
		Gui.Bars.shieldText.Text = ("Shield: "..trunc(shields, 0))
	end
	
	--this method updates the exp bar
	function Gui.Bars.UpdateExp()
		local MaxXp = getStatNormal"Level" * 4
		local p = getStatNormal"Experience" / MaxXp
		Gui.Bars.ExpBar.Size = UDim2.new(p, 0, 1, 0)
		Gui.Bars.ExpText.Text = "Experience: "..trunc(getStatNormal"Experience", 0).." / "..MaxXp
	end
	
	--this method updates the bars
	function Gui.Bars.Update()
		Gui.Bars.UpdateHealth()
		Gui.Bars.UpdateExp()
	end
end

--this function creates an ability gui
local function constructAbilityGui(container, ability, position)
	--a quick reference string 
	local id = "Ability"..ability
	
	--create a container frame, which is what we'll return
	local frame = Instance.new("ImageLabel")
	frame.Image = playerGet("Abilityicon"..ability)
	frame.Name = ability.."Frame"
	frame.Size = UDim2.new(0.23, 0, 0.23, 0)
	frame.SizeConstraint = Enum.SizeConstraint.RelativeXX
	frame.Position = position
	frame.BackgroundColor3 = ColorScheme.Quaternary
	frame.BorderColor3 = ColorScheme.Dark
	frame.Parent = container
	local cooldown = Frame:Clone()
	cooldown.Name = "cooldown"
	cooldown.Size = UDim2.new(1, 0, 1, 0)
	cooldown.BackgroundColor3 = ColorScheme.HealthLow
	cooldown.BorderColor3 = ColorScheme.HealthLow
	cooldown.BackgroundTransparency = 1
	cooldown.BorderSizePixel = 0
	cooldown.Parent = frame
	cooldown.Position = UDim2.new(0, 0, 1, 0)
	mouseOver(frame, function(x, y)
		startMouseOver(x, y, playerGet(id.."Name").."\n\n"..playerGet(id.."Description"))
	end)
	
	--shift the frame so that its base is along the base of its container
	local dy = container.AbsoluteSize.Y - frame.AbsoluteSize.Y
	frame.Position = frame.Position + UDim2.new(0, 0, 0, dy)
	
	--create a text
	local text = Text:Clone()
	text.Name = "Text"
	text.Size = UDim2.new(1, 0, 0.8, 0)
	text.Parent = frame
	text.Text = ""
	inset(text, 6)
	
	--create dots for showing what level the ability is
	local maxLevel = playerGet(id.."MaxLevel")
	for number = 1, maxLevel do
		local dot = Frame:Clone()
		dot.Name = tostring(number)
		dot.BorderSizePixel = 0
		dot.Size = UDim2.new(1 / maxLevel, 0, 0.2, 0)
		dot.Position = UDim2.new(dot.Size.X.Scale * (number - 1), 0, 1.01, 0)
		dot.BackgroundColor3 = ColorScheme.Dark
		dot.Parent = frame
		
		inset(dot, 2)
	end
	
	--create a level-up button
	local button = Button:Clone()
	button.Name = "Button"
	button.Size = UDim2.new(1, 0, 1, 0)
	button.Position = UDim2.new((1-button.Size.X.Scale)/2, 0, -button.Size.Y.Scale, 0)
	button.Text = "+"
	button.BorderColor3 = ColorScheme.Dark
	button.Parent = frame
	
	button.MouseButton1Click:connect(function()
		R.LevelUpAbility:InvokeServer(ability)
	end)
	
	--math's done, time to inset
	inset(frame, 8)
	inset(button, 16)
	
	return frame
end



--this functions returns the items in the shop
local function getShopItems()
	return game.ReplicatedStorage.Shop:GetChildren()
end

--this function extracts all possible categories from the items
local function getCategories()
	local items = getShopItems()
	local categories = {"Recommended","Skillz","H4x","AttackSpeed","Health","Toughness","Resistance","Hybrid Defense","Speed","Utility","Consumables"}	
	for _, item in pairs(items) do
		for _, obj in pairs(item:GetChildren()) do
			if obj.Name == "Category" and not contains(categories, obj.Value) then
				table.insert(categories, obj.Value)
			end
		end
	end
	return categories
end
--Without Recommended
local function getCategoriesNoReccomend()
	local items = getShopItems()
	local categories = {"Skillz","H4x","AttackSpeed","Health","Toughness","Resistance","Hybrid Defense","Speed","Utility","Consumables"}	
	for _, item in pairs(items) do
		for _, obj in pairs(item:GetChildren()) do
			if obj.Name == "Category" and not contains(categories, obj.Value) then
				table.insert(categories, obj.Value)
			end
		end
	end
	return categories
end
--this function extracts all possible builds for a specific item
local function getBuilds(item)
	local items = getShopItems()
	local builds = {}
	for i,v in pairs(items) do
		if v:FindFirstChild("Req") then	
			for i,req in pairs(v.Req:GetChildren()) do
				if req.Name == item.Name then
				local frame = script.Parent.ShopFrame.Stuff.Items:FindFirstChild(req.Parent.Parent.Name)
				table.insert(builds,frame)
				if game.ReplicatedStorage.Shop:FindFirstChild(req.Parent.Parent.Name):FindFirstChild("Req") then
				local extras = getBuilds(req.Parent.Parent)
				for i,z in pairs(extras) do
					table.insert(builds,z)
				end
						end
				end
			end
		end
	end
	--remove duplicates
	local hash = {}
local realbuilds = {}

for _,v in ipairs(builds) do
   if (not hash[v]) then
       realbuilds[#realbuilds+1] = v 
       hash[v] = true
   end
end
	return realbuilds
end

--this function extracts all possible requirements
local function getrequirements(item)
	local builds = {}
	
	if item:FindFirstChild("Req") then
		for i,req in pairs(item.Req:GetChildren()) do
			table.insert(builds,req.Name)
		end
	end
return builds
end
--this function finds all items with a specific category
local function getItemsWithCategory(categoryz)
	local items = getShopItems()
	local itemsWithCategory = {}
	for _, item in pairs(items) do
		for _, obj in pairs(item:GetChildren()) do
			for _,category in pairs(categoryz) do
			if obj.Name == "Category" and obj.Value == category then
				local frame = script.Parent.ShopFrame.Stuff.Items:FindFirstChild(item.Name)
				table.insert(itemsWithCategory,frame)
			elseif category == "Recommended" and obj.Name == "Category" then
				local charname = playerGet("CharMods")
				local playingchar = game.ReplicatedStorage.Characters:FindFirstChild(charname)
				if string.lower(playingchar.Class.Value):match("durable") then
					if  obj.Value == "Hybrid Defense" or obj.Value == "Health" or obj.Value == "Toughness" or obj.Value == "Resistance" or obj.Value == "Speed" then
					local frame = script.Parent.ShopFrame.Stuff.Items:FindFirstChild(item.Name)
					table.insert(itemsWithCategory,frame)	
					end
				end
				if string.lower(playingchar.Class.Value):match("around") then
				if playingchar.CharacterData.Skillz.PerLevel.Value == 0 then
				if  obj.Value == "Health" or obj.Value == "H4x" or obj.Value == "AttackSpeed"  or obj.Value == "Speed" then
				local frame = script.Parent.ShopFrame.Stuff.Items:FindFirstChild(item.Name)
					table.insert(itemsWithCategory,frame)		
				end
				else
				if  obj.Value == "Health" or obj.Value == "Skillz" or obj.Value == "AttackSpeed" or obj.Value == "Speed" then
				local frame = script.Parent.ShopFrame.Stuff.Items:FindFirstChild(item.Name)
					table.insert(itemsWithCategory,frame)		
				end
				end	
				end
				if string.lower(playingchar.Class.Value):match("support") then
				if playingchar.CharacterData.Skillz.PerLevel.Value == 0 then
				if  obj.Value == "Health" or obj.Value == "H4x" or obj.Value == "AttackSpeed"  or obj.Value == "Speed" then
				local frame = script.Parent.ShopFrame.Stuff.Items:FindFirstChild(item.Name)
					table.insert(itemsWithCategory,frame)		
				end
				else
				if  obj.Value == "Health" or obj.Value == "Skillz" or obj.Value == "AttackSpeed" or obj.Value == "Speed" then
				local frame = script.Parent.ShopFrame.Stuff.Items:FindFirstChild(item.Name)
					table.insert(itemsWithCategory,frame)		
				end
				end		
				end
				if string.lower(playingchar.Class.Value):match("disruptor") then
				if playingchar.CharacterData.Skillz.PerLevel.Value == 0 then
				if  obj.Value == "Health" or obj.Value == "H4x" or obj.Value == "Hybrid Defense" or obj.Value == "Toughness" or obj.Value == "Resistance" or obj.Value == "Speed" then
				local frame = script.Parent.ShopFrame.Stuff.Items:FindFirstChild(item.Name)
					table.insert(itemsWithCategory,frame)		
				end
				else
				if  obj.Value == "Health" or obj.Value == "Skillz" or obj.Value == "Hybrid Defense" or obj.Value == "Toughness" or obj.Value == "Resistance" or obj.Value == "Speed" then
				local frame = script.Parent.ShopFrame.Stuff.Items:FindFirstChild(item.Name)
					table.insert(itemsWithCategory,frame)		
				end
				end		
				end
				if string.lower(playingchar.Class.Value):match("burst") then
				if playingchar.CharacterData.Skillz.PerLevel.Value == 0 then
				if  obj.Value == "H4x" or obj.Value == "AttackSpeed"  or obj.Value == "Speed" then
				local frame = script.Parent.ShopFrame.Stuff.Items:FindFirstChild(item.Name)
					table.insert(itemsWithCategory,frame)		
				end
				else
				if  obj.Value == "Skillz" or obj.Value == "AttackSpeed" or obj.Value == "Speed" then
				local frame = script.Parent.ShopFrame.Stuff.Items:FindFirstChild(item.Name)
					table.insert(itemsWithCategory,frame)		
				end
				end		
				end
				if string.lower(playingchar.Class.Value):match("sustain") then
				if playingchar.CharacterData.Skillz.PerLevel.Value == 0 then
				if  obj.Value == "Health" or obj.Value == "H4x" or obj.Value == "AttackSpeed"  or obj.Value == "Speed" then
				local frame = script.Parent.ShopFrame.Stuff.Items:FindFirstChild(item.Name)
					table.insert(itemsWithCategory,frame)		
				end
				else
				if  obj.Value == "Health" or obj.Value == "Skillz" or obj.Value == "AttackSpeed" or obj.Value == "Speed" then
				local frame = script.Parent.ShopFrame.Stuff.Items:FindFirstChild(item.Name)
					table.insert(itemsWithCategory,frame)		
				end
				end		
				end
			end
			end
		end
	end
	return itemsWithCategory
end
--This functions finds all items except they are not frames
local function getItemsWithCategorys(categoryz)
	local items = getShopItems()
	local itemsWithCategory = {}
	for _, item in pairs(items) do
		for _, obj in pairs(item:GetChildren()) do
			for _,category in pairs(categoryz) do
			if obj.Name == "Category" and obj.Value == category then
				table.insert(itemsWithCategory,item)
			elseif category == "Recommended" and obj.Name == "Category" then
				local charname = playerGet("CharMods")
				local playingchar = game.ReplicatedStorage.Characters:FindFirstChild(charname)
				if string.lower(playingchar.Class.Value):match("durable") then
					if  obj.Value == "Hybrid Defense" or obj.Value == "Health" or obj.Value == "Toughness" or obj.Value == "Resistance" or obj.Value == "Speed" then

					table.insert(itemsWithCategory,item)	
					end
				
				elseif string.lower(playingchar.Class.Value):match("around") then
				if playingchar.CharacterData.Skillz.PerLevel.Value == 0 then
				if  obj.Value == "Health" or obj.Value == "H4x" or obj.Value == "AttackSpeed"  or obj.Value == "Speed" then

					table.insert(itemsWithCategory,item)		
				end
				else
				if  obj.Value == "Health" or obj.Value == "Skillz" or obj.Value == "AttackSpeed" or obj.Value == "Speed" then

					table.insert(itemsWithCategory,item)		
				end
				end	
				
				elseif string.lower(playingchar.Class.Value):match("support") then
				if playingchar.CharacterData.Skillz.PerLevel.Value == 0 then
				if  obj.Value == "Health" or obj.Value == "H4x" or obj.Value == "AttackSpeed"  or obj.Value == "Speed" then

					table.insert(itemsWithCategory,item)		
				end
				else
				if  obj.Value == "Health" or obj.Value == "Skillz" or obj.Value == "AttackSpeed" or obj.Value == "Speed" then

					table.insert(itemsWithCategory,item)		
				end
				end		
				
				elseif string.lower(playingchar.Class.Value):match("disruptor") then
				if playingchar.CharacterData.Skillz.PerLevel.Value == 0 then
				if  obj.Value == "Health" or obj.Value == "H4x" or obj.Value == "Hybrid Defense" or obj.Value == "Toughness" or obj.Value == "Resistance" or obj.Value == "Speed" then

					table.insert(itemsWithCategory,item)		
				end
				else
				if  obj.Value == "Health" or obj.Value == "Skillz" or obj.Value == "Hybrid Defense" or obj.Value == "Toughness" or obj.Value == "Resistance" or obj.Value == "Speed" then

					table.insert(itemsWithCategory,item)		
				end
				end		
				
				elseif string.lower(playingchar.Class.Value):match("burst") then
				if playingchar.CharacterData.Skillz.PerLevel.Value == 0 then
				if  obj.Value == "H4x" or obj.Value == "AttackSpeed"  or obj.Value == "Speed" then

					table.insert(itemsWithCategory,item)		
				end
				else
				if  obj.Value == "Skillz" or obj.Value == "AttackSpeed" or obj.Value == "Speed" then

					table.insert(itemsWithCategory,item)		
				end
				end		
				
				elseif string.lower(playingchar.Class.Value):match("sustain") then
				if playingchar.CharacterData.Skillz.PerLevel.Value == 0 then
				if  obj.Value == "Health" or obj.Value == "H4x" or obj.Value == "AttackSpeed"  or obj.Value == "Speed" then

					table.insert(itemsWithCategory,item)		
				end
				else
				if  obj.Value == "Health" or obj.Value == "Skillz" or obj.Value == "AttackSpeed" or obj.Value == "Speed" then

					table.insert(itemsWithCategory,item)		
				end
				end		
				end
			end
			end
		end
	end
	return itemsWithCategory
end
--this function creates the shop gui, complicated .-. hehehehe nu more complications here
local function constructShopGui()
	--gather some information
	local categories = getCategories()
	
	--make a data structure for it
	Gui.Shop = {}
	Gui.Shop.IsOpen = true
	Gui.Shop.Frame = script.Parent.ShopFrame
	--[[create a container frame for it all
	local frame = Frame:Clone()
	frame.Name = "ShopFrame"
	frame.Size = UDim2.new(0.8, 0, 0.7, 0)
	frame.Position = UDim2.new(0.1, 0, 0.0, 0)
	frame.BackgroundTransparency = 1
	frame.Parent = ScreenGui
	Gui.Shop.Frame = frame]]
	
	--create a button for the shop, for ease of sizing this is in Gui.Stats.Frame
	local button = Button:Clone()
	button.Name = "ShopButton"
	button.Text = "Shop"
	button.Size = UDim2.new(0.5, 0, 2/3, 0)
	button.Position = UDim2.new(3.25, 0, .4, 0)
	button.Parent = Gui.Stats.Frame
	Gui.Shop.Button = button
	
	inset(button, 6)
	
	button.MouseButton1Click:connect(function()
		if Gui.Shop.IsOpen then
			Gui.Shop.CloseButton()
		else
			Gui.Shop.OpenButton()
		end
	end)
	
	--This method creates the item tree base up to their requirements
	local function createtree(image,item)
		endMouseOver2()
		local function onItemClick(itemz,images)
		script.Parent.ShopFrame.Custom.Builds:ClearAllChildren()
			script.Parent.ShopFrame.Custom.Tree:ClearAllChildren()
			script.Parent.ShopFrame.Custom.Buttons:ClearAllChildren()
			local builds = getBuilds(itemz)
			if #builds ~= 0 then --Create possible futures
				local buildz = -1
			for i,BUILD in pairs(builds) do
			local buildframe = BUILD:Clone()
			buildframe.Size = UDim2.new(0.1/2, 0, 0.4, 0)
			buildframe.Parent = script.Parent.ShopFrame.Custom.Builds
			buildframe.Position = UDim2.new(((i-1)/10)/2 + 0.01 * i,0,0.5,0)
			buildframe.cost:Destroy()
			buildframe.Visible = true
			mouseOver2(buildframe, function(x, y)
				startMouseOver2(x, y, buildframe.Name.."\n\n"..game.ReplicatedStorage.Shop:FindFirstChild(buildframe.Name).Desc.Value)
				end)
			buildframe.MouseButton1Click:connect(function()
				onItemClick(game.ReplicatedStorage.Shop:FindFirstChild(buildframe.Name),script.Parent.ShopFrame.Stuff.Items:FindFirstChild(buildframe.Name))
			end)
			end	
			end
			script.Parent.ShopFrame.Custom.Description.Description.Text = itemz.Desc.Value
			script.Parent.ShopFrame.Custom.ItemName.Text = itemz.Name
			if itemz:FindFirstChild("Lore") then
			script.Parent.ShopFrame.Custom.Description.Description.Text = script.Parent.ShopFrame.Custom.Description.Description.Text.."\n"..itemz.Lore.Value	
			end
			createtree(images,itemz)
			local buybutton = Instance.new("TextButton")
			buybutton.Parent = script.Parent.ShopFrame.Custom.Buttons
			buybutton.Position = UDim2.new(0.6,0,0.77,0)
			buybutton.Size = UDim2.new(0.4,0,0.04,0)
			buybutton.BackgroundColor3 = Color3.fromRGB(28,28,28)
			buybutton.Text = "Buy"
			buybutton.ZIndex = 3
			buybutton.TextColor3 = Color3.new(1,1,1)
			buybutton.MouseButton1Down:connect(function()
				R.AttemptShopBuy:InvokeServer(itemz)
			end)		
			end
		local function createtreecontinue2(item,level,base)
		
		local req = getrequirements(item)
		local container = base
		for i,v in pairs(req) do
				local branch = script.Parent.ShopFrame.Stuff.Items:FindFirstChild(v):Clone()
				local branchcontainer = Instance.new("Frame")
				local branchitem = game.ReplicatedStorage.Shop:FindFirstChild(v)
				branchcontainer.Parent = script.Parent.ShopFrame.Custom.Tree
				branchcontainer.Name = v
				branchcontainer.Size = UDim2.new(0.1,0,0.2/4,0)
				branchcontainer.ZIndex = 4
				branchcontainer.BackgroundColor3 = Color3.fromRGB(45,45,45)
				branch.Size = UDim2.new(1,0,0.5,0)
				branch.Parent = script.Parent.ShopFrame.Custom.Tree
				branch.Position = UDim2.new(0, 0, 0, 0)
				branch.ZIndex = 4
				branch.Visible = true
				branch.cost.ZIndex = 4
				branch.Parent = branchcontainer
				branch.cost.Text = branchitem.Cost.Value
				branch.MouseButton1Click:connect(function()
				onItemClick(game.ReplicatedStorage.Shop:FindFirstChild(v),script.Parent.ShopFrame.Stuff.Items:FindFirstChild(v))	
				end)
				branch.MouseButton2Down:connect(function()
				R.AttemptShopBuy:InvokeServer(game.ReplicatedStorage.Shop:FindFirstChild(v))
				end)
				mouseOver2(branch, function(x, y)
				startMouseOver2(x, y, branchitem.Name.."\n\n"..branchitem.Desc.Value.."\n\nRight-click to buy.")
				end)
				if #req == 1 then
				branchcontainer.Position = UDim2.new(container.Position.X.Scale, 0, (0.1 + (.25 *level))/4, 0)
				local line = Instance.new("Frame",script.Parent.ShopFrame.Custom.Tree)
				line.ZIndex = 3
				line.Size = UDim2.new(0.01, 0, (container.AbsolutePosition - branchcontainer.AbsolutePosition).magnitude/(2 * script.Parent.ShopFrame.AbsoluteSize.Y), 0)
				line.Position = container.Position + UDim2.new(0.05,0,0,0)
				createtreecontinue2(game.ReplicatedStorage.Shop:FindFirstChild(v),4,branchcontainer)
				elseif #req == 2 then
				branchcontainer.Position = UDim2.new((container.Position.X.Scale - 0.15) + ((i-1) * 0.3), 0, (0.1 + (.25 *level))/4, 0)
				local line = Instance.new("Frame",script.Parent.ShopFrame.Custom.Tree)
				line.ZIndex = 3
				line.Size = UDim2.new(0.01, 0, (container.AbsolutePosition - branchcontainer.AbsolutePosition).magnitude/(2.5 * script.Parent.ShopFrame.AbsoluteSize.Y), 0)
				line.Position = UDim2.new((container.Position.X.Scale - 0.05) + (0.2 * (i-1)), 0, container.Position.Y.Scale + (container.AbsoluteSize.Y/2000), 0)
				line.Rotation = 45 + (-90 * (i-1))
				createtreecontinue2(game.ReplicatedStorage.Shop:FindFirstChild(v),4,branchcontainer)
				else
				branchcontainer.Position = UDim2.new((container.Position.X.Scale - 0.2) + ((i-1) * 0.2), 0, (0.1 + (.25 *level))/4, 0)
				local line = Instance.new("Frame",script.Parent.ShopFrame.Custom.Tree)
				line.ZIndex = 3
				line.Size = UDim2.new(0.01, 0, (container.AbsolutePosition - branchcontainer.AbsolutePosition).magnitude/(2.5 * script.Parent.ShopFrame.AbsoluteSize.Y), 0)
				line.Position = UDim2.new((container.Position.X.Scale - 0.05) + (0.1 * (i-1)), 0, container.Position.Y.Scale + (container.AbsoluteSize.Y/2000), 0)
				line.Rotation = 45 + (-45 * (i-1))
				createtreecontinue2(game.ReplicatedStorage.Shop:FindFirstChild(v),4,branchcontainer)
				end
			
			end
		
	end
		local function createtreecontinue(item,level,base)
		local req = getrequirements(item)
		local container = base
		for i,v in pairs(req) do
				local branch = script.Parent.ShopFrame.Stuff.Items:FindFirstChild(v):Clone()
				local branchcontainer = Instance.new("Frame",script.Parent.ShopFrame.Custom.Tree)
				local branchitem = game.ReplicatedStorage.Shop:FindFirstChild(v)
				branchcontainer.Name = v
				branchcontainer.Size = UDim2.new(0.1,0,0.2/4,0)
				branchcontainer.ZIndex = 4
				branchcontainer.BackgroundColor3 = Color3.fromRGB(45,45,45)
				branch.Size = UDim2.new(1,0,0.5,0)
				branch.Parent = script.Parent.ShopFrame.Custom.Tree
				branch.Position = UDim2.new(0, 0, 0, 0)
				branch.ZIndex = 4
				branch.Visible = true
				branch.cost.ZIndex = 4
				branch.Parent = branchcontainer
				branch.cost.Text = branchitem.Cost.Value
				branch.MouseButton1Click:connect(function()
				onItemClick(game.ReplicatedStorage.Shop:FindFirstChild(v),script.Parent.ShopFrame.Stuff.Items:FindFirstChild(v))	
				end)
				branch.MouseButton2Down:connect(function()
				R.AttemptShopBuy:InvokeServer(game.ReplicatedStorage.Shop:FindFirstChild(v))
				end)
				mouseOver2(branch, function(x, y)
				startMouseOver2(x, y, branchitem.Name.."\n\n"..branchitem.Desc.Value.."\n\nRight-click to buy.")
				end)
				if #req == 1 then
				branchcontainer.Position = UDim2.new(container.Position.X.Scale, 0, (0.1 + (.25 *level))/4, 0)
				local line = Instance.new("Frame",script.Parent.ShopFrame.Custom.Tree)
				line.ZIndex = 3
				line.Size = UDim2.new(0.01, 0, (container.AbsolutePosition - branchcontainer.AbsolutePosition).magnitude/(2 * script.Parent.ShopFrame.AbsoluteSize.Y), 0)
				line.Position = container.Position + UDim2.new(0.05,0,0,0)
				createtreecontinue2(game.ReplicatedStorage.Shop:FindFirstChild(v),3,branchcontainer)
				elseif #req == 2 then
				branchcontainer.Position = UDim2.new((container.Position.X.Scale - 0.15) + ((i-1) * 0.3), 0, (0.1 + (.25 *level))/4, 0)
				local line = Instance.new("Frame",script.Parent.ShopFrame.Custom.Tree)
				line.ZIndex = 3
				line.Size = UDim2.new(0.01, 0, (container.AbsolutePosition - branchcontainer.AbsolutePosition).magnitude/(2.5 * script.Parent.ShopFrame.AbsoluteSize.Y), 0)
				line.Position = UDim2.new((container.Position.X.Scale - 0.05) + (0.2 * (i-1)), 0, container.Position.Y.Scale + (container.AbsoluteSize.Y/2000), 0)
				line.Rotation = 45 + (-90 * (i-1))
				createtreecontinue2(game.ReplicatedStorage.Shop:FindFirstChild(v),3,branchcontainer)
				else
				branchcontainer.Position = UDim2.new((container.Position.X.Scale - 0.2) + ((i-1) * 0.2), 0, (0.1 + (.25 *level))/4, 0)
				local line = Instance.new("Frame",script.Parent.ShopFrame.Custom.Tree)
				line.ZIndex = 3
				line.Size = UDim2.new(0.01, 0, (container.AbsolutePosition - branchcontainer.AbsolutePosition).magnitude/(2.5 * script.Parent.ShopFrame.AbsoluteSize.Y), 0)
				line.Position = UDim2.new((container.Position.X.Scale - 0.05) + (0.1 * (i-1)), 0, container.Position.Y.Scale + (container.AbsoluteSize.Y/2000), 0)
				line.Rotation = 45 + (-45 * (i-1))
				createtreecontinue2(game.ReplicatedStorage.Shop:FindFirstChild(v),3,branchcontainer)
				end
			
			end
		
	end
		local req = getrequirements(item)
		local container = Instance.new("Frame",script.Parent.ShopFrame.Custom.Tree)
		container.Name = item.Name
		container.Size = UDim2.new(0.1,0,0.2/4,0)
		container.ZIndex = 4
		container.BackgroundColor3 = Color3.fromRGB(45,45,45)
		container.Position = UDim2.new(0.45, 0, 0.1/4, 0)
		local hightree = image:Clone()
		hightree.Size = UDim2.new(1,0,0.5,0)
		hightree.Position = UDim2.new(0, 0, 0, 0)
		hightree.ZIndex = 4
		hightree.Parent = container
		hightree.cost.Text = item.Cost.Value
		hightree.cost.Size = UDim2.new(1,0,0.5,0)
		hightree.cost.Position = UDim2.new(0, 0, 1.2, 0)
		hightree.cost.ZIndex = 4
		hightree.Visible = true
		hightree.MouseButton2Down:connect(function()
				R.AttemptShopBuy:InvokeServer(item)
		end)	
		mouseOver2(hightree, function(x, y)
				startMouseOver2(x, y, hightree.Name.."\n\n"..item.Desc.Value.."\n\nRight-click to buy.")
				end)
		for i,v in pairs(req) do
				local branch = script.Parent.ShopFrame.Stuff.Items:FindFirstChild(v):Clone()
				local branchcontainer = Instance.new("Frame",script.Parent.ShopFrame.Custom.Tree)
				local branchitem = game.ReplicatedStorage.Shop:FindFirstChild(v)
				branchcontainer.Name = v
				branchcontainer.Size = UDim2.new(0.1,0,0.2/4,0)
				branchcontainer.ZIndex = 4
				branchcontainer.BackgroundColor3 = Color3.fromRGB(45,45,45)
				branch.Size = UDim2.new(1,0,0.5,0)
				branch.Parent = script.Parent.ShopFrame.Custom.Tree
				branch.Position = UDim2.new(0, 0, 0, 0)
				branch.ZIndex = 4
				branch.Visible = true
				branch.cost.ZIndex = 4
				branch.Parent = branchcontainer
				branch.cost.Text = branchitem.Cost.Value
				branch.MouseButton1Click:connect(function()
				onItemClick(game.ReplicatedStorage.Shop:FindFirstChild(v),script.Parent.ShopFrame.Stuff.Items:FindFirstChild(v))	
				end)
				branch.MouseButton2Down:connect(function()
				R.AttemptShopBuy:InvokeServer(game.ReplicatedStorage.Shop:FindFirstChild(v))
			end)
				mouseOver2(branch, function(x, y)
				startMouseOver2(x, y, branchitem.Name.."\n\n"..branchitem.Desc.Value.."\n\nRight-click to buy.")
				end)
				if #req == 1 then
				branchcontainer.Position = UDim2.new(0.45, 0, 0.35/4, 0)
				local line = Instance.new("Frame",script.Parent.ShopFrame.Custom.Tree)
				line.ZIndex = 3
				line.Size = UDim2.new(0.01, 0, (container.AbsolutePosition - branchcontainer.AbsolutePosition).magnitude/(2 * script.Parent.ShopFrame.AbsoluteSize.Y), 0)
				line.Position = UDim2.new(0.5, 0, 0.1/4, 0)
				createtreecontinue(game.ReplicatedStorage.Shop:FindFirstChild(v),2,branchcontainer)	
				
				elseif #req == 2 then
					branchcontainer.Position = UDim2.new(0.25 + ((i-1) * 0.4), 0, 0.35/4, 0)
				local line = Instance.new("Frame",script.Parent.ShopFrame.Custom.Tree)
				line.ZIndex = 3
				line.Size = UDim2.new(0.01, 0, (container.AbsolutePosition - branchcontainer.AbsolutePosition).magnitude/(2 * script.Parent.ShopFrame.AbsoluteSize.Y), 0)
				line.Position = UDim2.new(0.4 + (0.2 * (i-1)), 0, 0.1/4, 0)
				line.Rotation = 45 + (-90 * (i-1))
				createtreecontinue(game.ReplicatedStorage.Shop:FindFirstChild(v),2,branchcontainer)
				else
				branchcontainer.Position = UDim2.new(0.25 + ((i-1) * 0.2), 0, 0.35/4, 0)
				local line = Instance.new("Frame",script.Parent.ShopFrame.Custom.Tree)
				line.ZIndex = 3
				line.Size = UDim2.new(0.01, 0, (container.AbsolutePosition - branchcontainer.AbsolutePosition).magnitude/(2 * script.Parent.ShopFrame.AbsoluteSize.Y), 0)
				line.Position = UDim2.new(0.4 + (0.1 * (i-1)), 0, 0.1/4, 0)
				line.Rotation = 45 + (-45 * (i-1))
				createtreecontinue(game.ReplicatedStorage.Shop:FindFirstChild(v),2,branchcontainer)
				end
			
			end
		
	end
	--Handles the click
	local function onItemClick(itemz,image)
		endMouseOver2()
		script.Parent.ShopFrame.Custom.Builds:ClearAllChildren()
			script.Parent.ShopFrame.Custom.Tree:ClearAllChildren()
			script.Parent.ShopFrame.Custom.Buttons:ClearAllChildren()
			local builds = getBuilds(itemz)
			if #builds ~= 0 then --Create possible futures
				local buildz = -1
			for i,BUILD in pairs(builds) do
			local buildframe = BUILD:Clone()
			buildframe.Size = UDim2.new(0.1/2, 0, 0.4, 0)
			buildframe.Parent = script.Parent.ShopFrame.Custom.Builds
			buildframe.Position = UDim2.new(((i-1)/10)/2 + 0.01 * i,0,0.5,0)
			buildframe.cost:Destroy()
			buildframe.Visible = true
			mouseOver2(buildframe, function(x, y)
				startMouseOver2(x, y, buildframe.Name.."\n\n"..game.ReplicatedStorage.Shop:FindFirstChild(buildframe.Name).Desc.Value)
				end)
			buildframe.MouseButton1Click:connect(function()
				onItemClick(game.ReplicatedStorage.Shop:FindFirstChild(buildframe.Name),script.Parent.ShopFrame.Stuff.Items:FindFirstChild(buildframe.Name))
			end)
			end	
			end
			script.Parent.ShopFrame.Custom.Description.Description.Text = itemz.Desc.Value
			script.Parent.ShopFrame.Custom.ItemName.Text = itemz.Name
			if itemz:FindFirstChild("Lore") then
			script.Parent.ShopFrame.Custom.Description.Description.Text = script.Parent.ShopFrame.Custom.Description.Description.Text.."\n"..itemz.Lore.Value	
			end
			createtree(image,itemz)	
			local buybutton = Instance.new("TextButton")
			buybutton.Parent = script.Parent.ShopFrame.Custom.Buttons
			buybutton.ZIndex = 3
			buybutton.Position = UDim2.new(0.6,0,0.77,0)
			buybutton.Size = UDim2.new(0.4,0,0.04,0)
			buybutton.Text = "Buy"
			buybutton.TextColor3 = Color3.new(1,1,1)
			buybutton.BackgroundColor3 = Color3.fromRGB(28,28,28)
			buybutton.MouseButton1Down:connect(function()
				R.AttemptShopBuy:InvokeServer(itemz)
			end)
			end
	--This method is to find the real price of the item
	local function checkcost(item)
	local builds = {}
	local cost = 0
	cost = item.Cost.Value
	if item:FindFirstChild("Req") then
		for i,req in pairs(item.Req:GetChildren()) do
			table.insert(builds,game.ReplicatedStorage.Shop:FindFirstChild(req.Name).Cost.Value)
			if game.ReplicatedStorage.Shop:FindFirstChild(req.Name):FindFirstChild("Req") then
				local others = checkcost(game.ReplicatedStorage.Shop:FindFirstChild(req.Name))
				for i,v in pairs(others) do
					table.insert(builds,v)
				end
			end
		end
	end
	for i,v in pairs(builds) do
		cost = cost + v
	end
return builds,cost
end
	--This method will list all the possible items
	local function createitems() --Where every item is generated
	local rows = 0.5
	local items = -1
	local pick = getShopItems()
	for index,item in pairs(pick) do
		items = items + 1
		local image = Instance.new("ImageButton")
			image.BackgroundTransparency = 0
			image.Size = UDim2.new(0.1, 0, 0.015, 0)
			image.SizeConstraint = Enum.SizeConstraint.RelativeXY
			image.Image = item.Image.Value
			image.Parent = script.Parent.ShopFrame.Stuff.Items
			image.ZIndex = 3
			image.Name = item.Name
			--Handles the shop buying
			mouseOver2(image, function(x, y)
				startMouseOver2(x, y, image.Name.."\n\n"..item.Desc.Value)
				end)
			--//Handles the clicking of the item
			if items > 4 then
				rows = rows + 1
				items = 0
				image.Position = UDim2.new(items/10 + 0.09 * items,0,rows/100 + 0.035 * rows,0) 
				
			else
				image.Position = UDim2.new(items/10 + 0.09 * items,0,rows/100 + 0.035 * rows,0) 
			end
		local Text = Instance.new("TextLabel",image)
		Text.Size = UDim2.new(1, 0, 1, 0)
		Text.Position =  UDim2.new(0, 0, 1, 0)
		Text.ZIndex = 3
		Text.BackgroundTransparency = 1
		Text.TextColor3 = Color3.new(255,255,255)
		Text.Name = "cost"
		local _,cost = checkcost(item)
		
	Text.Text = cost
	image.MouseButton1Click:connect(function()
		onItemClick(item,image)
	end)
	end
	end
	createitems()
	--This method reorganizes items based on what categories are highlighted
	local function arrangeitems(pick)
	local rows = 0.5
	local items = -1
	for index,item in pairs(script.Parent.ShopFrame.Stuff.Items:GetChildren()) do --Hide every other thing
	item.Visible = false
	end
	for index,item in pairs(pick) do --show the only ones and rearrange them
		items = items + 1
			item.Visible = true
			if items > 4 then
				rows = rows + 1
				items = 0
				item.Position = UDim2.new(items/10 + 0.09 * items,0,rows/100 + 0.035 * rows,0) 
			else
				item.Position = UDim2.new(items/10 + 0.09 * items,0,rows/100 + 0.035 * rows,0) 
			end
	end
	end
	--create a tab for each category
	for idx, category in pairs(getCategoriesNoReccomend()) do
	local button = Instance.new("TextButton")
			button.Active = false
			button.BackgroundTransparency = 0
			button.Size = UDim2.new(1, 0, 0.06, 0)
			button.SizeConstraint = Enum.SizeConstraint.RelativeXY
			button.Parent = script.Parent.ShopFrame.Stuff.ItemTypes
			button.Position = UDim2.new(0,0,(-1/11 + idx/11)+ 0.01 * (idx),0) 
			button.ZIndex = 3
			button.Name = category	
			button.Text = category
			
			button.MouseButton1Click:connect(function()
			script.Parent.ShopFrame.Stuff.Items.CanvasPosition = Vector2.new(0,0)
			local saved = {}

			if button.Active then
				button.Active = false
			else
				button.Active = true
			end
			local ticks = {}
				for idx,tabs in pairs(script.Parent.ShopFrame.Stuff.ItemTypes:GetChildren()) do
				if tabs.Active == true then
				table.insert(ticks,tabs.Name)
			end	
				end
				if #ticks ~= 0 then
				local items = getItemsWithCategory(ticks)
				arrangeitems(items)
				else
				arrangeitems(script.Parent.ShopFrame.Stuff.Items:GetChildren())
				end
			end)
			
	end
	--Tab for each category for not all items
	for idx, category in pairs(categories) do
	local button = Instance.new("TextButton")
			button.Active = false
			button.BackgroundTransparency = 0
			button.Size = UDim2.new(1, 0, 0.06, 0)
			button.SizeConstraint = Enum.SizeConstraint.RelativeXY
			button.Parent = script.Parent.ShopFrame.Stuff.ItemTypesCategories
			button.Position = UDim2.new(0,0,(-1/12 + idx/12)+ 0.01 * (idx),0) 
			button.ZIndex = 3
			button.Name = category	
			button.Text = category
			button.MouseButton1Click:connect(function()
			local tabl = {category}
			Gui.Shop.ShowTab(tabl)
			end)
	end
	--Create Frames for each individual item
	function Gui.Shop.ShowTab(category)
		--clear out the item frame
		script.Parent.ShopFrame.Stuff.ItemsTab2:ClearAllChildren()
		script.Parent.ShopFrame.Stuff.ItemsTab2.CanvasPosition = Vector2.new(0,0)
		--acquire all items that have this category, create frames for each
		local items = getItemsWithCategorys(category)
		for idx, item in pairs(items) do
			--most common case, more than three items
			
			--create a container frame
			local frame = Instance.new("TextButton")
			frame.Size = UDim2.new(0.98, 0, (0.02), 0)
			frame.Position = UDim2.new(0, 0, 0.02 * (idx - 1), 0)
			frame.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
			frame.BorderColor3 = ColorScheme.Quaternary
			frame.Parent = script.Parent.ShopFrame.Stuff.ItemsTab2
			frame.Text = ""
			frame.ZIndex = 3
			--create an image for it
			local image = Instance.new("ImageButton")
			image.BackgroundTransparency = 1
			image.Size = UDim2.new(0.13, 0,1, 0)
			image.Image = item.Image.Value
			image.Parent = frame
			image.ZIndex = 3
			
			--create the item Name
			local text = Instance.new("TextLabel")
			text.Size = UDim2.new(0.87, 0, 1, 0)
			text.Position = UDim2.new(0.135, 0, 0, 0)
			text.Text = item.Name
			text.TextXAlignment = Enum.TextXAlignment.Left
			text.Parent = frame
			text.ZIndex = 3
			text.TextColor3 = Color3.new(1,1,1)
			text.FontSize = Enum.FontSize.Size12
			text.BackgroundTransparency = 1
			--create the item cost
			local _,cost = checkcost(item)
			local COST = Instance.new("TextLabel")
			COST.Size = UDim2.new(0.87, 0, 1, 0)
			COST.Position = UDim2.new(0.13, 0, 0, 0)
			COST.Text = cost
			COST.TextXAlignment = Enum.TextXAlignment.Right
			COST.Parent = frame
			COST.ZIndex = 3
			COST.TextColor3 = Color3.new(1,1,1)
			COST.BackgroundTransparency = 1
			COST.FontSize = Enum.FontSize.Size12
			frame.MouseButton1Down:connect(function()
				local z = script.Parent.ShopFrame.Stuff.Items:FindFirstChild(item.Name)
				onItemClick(item,z)
			end)
		end
	end
	--This method handles the shop search features
	local search = script.Parent.ShopFrame.Stuff.Search.Search
	search.Changed:connect(function(property)
	if property == "Text" then
		script.Parent.ShopFrame.Stuff.Items.CanvasPosition = Vector2.new(0,0)
		if search.Text == "" or search.Text == "Search" or search.Text == " " then
			arrangeitems(script.Parent.ShopFrame.Stuff.Items:GetChildren())
		else
		local showthese = {}
		for i,items in pairs(script.Parent.ShopFrame.Stuff.Items:GetChildren()) do
			if string.lower(items.Name):match(string.lower(search.Text))  then
			table.insert(showthese,items)	
			end
		end	
		if #showthese ~= 0 then
				arrangeitems(showthese)
				for idx,tabs in pairs(script.Parent.ShopFrame.Stuff.ItemTypes:GetChildren()) do
				tabs.Active = false
				end
				else
				arrangeitems(script.Parent.ShopFrame.Stuff.Items:GetChildren())
				end
		end
		
	end	
	
	end)
	search.Focused:connect(function()
		search.Text =""
	end)
	--This handles switching from classic shop or the all item shop
	local classic = script.Parent.ShopFrame.Stuff.Search.ShopButton
	local new = script.Parent.ShopFrame.Stuff.Search.AllItemButton
	new.MouseButton1Click:connect(function()
		classic.Active = false
		new.Active = true
		search.Visible = true
		script.Parent.ShopFrame.Stuff.ItemsTab2.Visible = false
		script.Parent.ShopFrame.Stuff.ItemTypesCategories.Visible = false
		script.Parent.ShopFrame.Stuff.Items.Visible = true
		script.Parent.ShopFrame.Stuff.ItemTypes.Visible = true
	end)
	classic.MouseButton1Click:connect(function()
		new.Active = false
		classic.Active = true
		search.Visible = false
		script.Parent.ShopFrame.Stuff.ItemsTab2.Visible = true
		script.Parent.ShopFrame.Stuff.ItemTypesCategories.Visible = true
		script.Parent.ShopFrame.Stuff.Items.Visible = false
		script.Parent.ShopFrame.Stuff.ItemTypes.Visible = false
	end)
	--this method opens the shop
	function Gui.Shop.Open()
		endMouseOver2()
		Gui.Shop.Frame.Visible = true
		Gui.Shop.IsOpen = true
	end
	
	function Gui.Shop.OpenButton()
		endMouseOver2()
		Gui.Shop.Frame.Visible = true
		Gui.Shop.IsOpen = true
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
	end
	
	--this method closes the shop
	function Gui.Shop.Close()
		endMouseOver2()
		Gui.Shop.Frame.Visible = false
		Gui.Shop.IsOpen = false
		
	end
	
	function Gui.Shop.CloseButton()
		endMouseOver2()
		Gui.Shop.Frame.Visible = false
		Gui.Shop.IsOpen = false
		local chat = game.StarterGui:GetCoreGuiEnabled("Chat")
		if chat == false then
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
		end
	end
	--handle closing the shop if out of range
	function Gui.Shop.Update()
		Gui.Shop.Button.Visible = playerGet"InShopRange"
		if not Gui.Shop.Button.Visible then
			Gui.Shop.Close()
		end
		
		if Gui.Leaderboard.Frame.Visible then
			Gui.Shop.CloseButton()
		end
	end
	
	Gui.Shop.Close()
end

--this function creates the backpack gui
local function constructBackpackGui()
	--data structure
	Gui.Backpack = {}
	Gui.Backpack.Elements = {}
	
	--object orientation
	--this method clears all objects in the backpack
	function Gui.Backpack.Clear()
		for _, element in pairs(Gui.Backpack.Elements) do
			element:Destroy()
		end
	end
	
	--this method updates the backpack
	function Gui.Backpack.Update()
		Gui.Backpack.Clear()
		endMouseOver()
		
		--acquire the inventory
		local inventory = Player.Character:FindFirstChild("Inventory", true)
		if inventory then			
			local x = 0
			local y = 0
			for idx, item in pairs(inventory:GetChildren()) do
				--create a container frame
				local frame = Frame:Clone()
				frame.Size = UDim2.new(0.05, 0, 0.05, 0)
				frame.SizeConstraint = Enum.SizeConstraint.RelativeYY
				frame.Position = Gui.Stats.Frame.Position + UDim2.new(Gui.Stats.Frame.Size.X.Scale, 4, frame.Size.Y.Scale * (.85*y), 0)
				frame.Parent = ScreenGui
				frame.Position = frame.Position + UDim2.new(0, frame.AbsoluteSize.X * x, 0, 0)
				frame.BorderColor3 = ColorScheme.Dark
				frame.BorderSizePixel = 2
				table.insert(Gui.Backpack.Elements, frame)
				
				mouseOver(frame, function(x, y)
					startMouseOver(x, y, Gui.Backpack.MouseOverText(item))
				end)
				
				inset(frame, 4)
				
				--create an image
				local image = Instance.new("ImageButton")
				image.BackgroundTransparency = 1
				image.Size = UDim2.new(1, 0, 1, 0)
				image.Image = item.Image.Value
				image.Parent = frame
				
				image.MouseButton2Click:connect(function()
					R.AttemptShopSell:InvokeServer(item)
				end)
				
				--if we've got a hotkey, tell the player what it is
				if item:FindFirstChild("Hotkey") then
					--insert a bordered frame to contain the level of the player
					local hFrame = Frame:Clone()
					hFrame.Size = UDim2.new(0.45, 0, 0.45, 0)
					hFrame.Position = UDim2.new(0.55, 0, 0.55, 0)
					hFrame.BackgroundColor3 = ColorScheme.Tertiary
					hFrame.BorderColor3 = ColorScheme.Dark
					hFrame.Parent = frame
					
					--insert the level tracker
					local hText = Text:Clone()
					hText.Size = UDim2.new(1, 0, 1, 0)
					hText.Text = item.Hotkey.Value
					hText.Parent = hFrame
				end
				
				--advance the counters
				y = y + 1
				if y >= 3 then
					y = 0
					x = x + 1
				end
			end
		end
	end
	
	function Gui.Backpack.MouseOverText(item)
		local str = ""
		
		str = str..item.Name.."\n\n"
		str = str..item.Desc.Value
		
		if playerGet"InShopRange" then
			str = str.."\n\nRight-click to sell."
		end
		
		return str
	end
	
	R.UpdateBackpack.OnClientEvent:connect(Gui.Backpack.Update)
end

--this function attempts to extract data from a different player state
local function otherGet(ps, key)
	local v = ps:FindFirstChild(key)
	if v then
		return v.Value
	end
	return 0
end

--this function creates the leaderboard gui
local function constructLeaderboardGui()
	--data structure
	Gui.Leaderboard = {}
	Gui.Leaderboard.IsOpen = true
	
	--container frame
	local frame = Frame:Clone()
	frame.Size = UDim2.new(0.6, 0, 0.6, 0)
	frame.Position = UDim2.new(0.2, 0, 0.05, 0)
	frame.BackgroundTransparency = 1
	frame.Parent = ScreenGui
	Gui.Leaderboard.Frame = frame
	
	--object orientation
	--this method updates the leaderboard
	function Gui.Leaderboard.Update()
		if not Gui.Leaderboard.Frame.Visible then return end
		
		Gui.Leaderboard.Frame:ClearAllChildren()
		
		local myY = 0
		local enY = 0
		
		for _, player in pairs(game.Players:GetPlayers()) do
			local ps = player:FindFirstChild("PlayerState", true)
			if ps then

				--gather some information
				local cPict = otherGet(ps, "CharacterPortrait")
				local cName = otherGet(ps, "CharacterName")
				local kills = otherGet(ps, "Kills")
				local deaths = otherGet(ps, "Deaths")
				local assists = otherGet(ps, "Assists")
				local teamName = otherGet(ps, "TeamName")
				local teamColor = otherGet(ps, "TeamColor")
				
				--special processing
				if teamColor == 0 then
					teamColor = Color3.new(0.5, 0.5, 0.5)
				else
					teamColor = teamColor.Color
				end
				if teamName ~= 0 then
				--team specific stuff
				local onMyTeam = teamName == playerGet"TeamName"
				local y
				local x
				if onMyTeam then
					y = myY
					x = 0
					myY = myY + 1
				else
					y = enY
					x = 1
					enY = enY + 1
				end
				
				--create the container
				local frame = Frame:Clone()
				frame.Size = UDim2.new(0.5, 0, 0.2, 0)
				frame.Position = UDim2.new(frame.Size.X.Scale * x, 0, frame.Size.Y.Scale * y, 0)
				frame.BackgroundColor3 = ColorScheme.Tertiary
				frame.BorderColor3 = teamColor
				frame.BorderSizePixel = 2
				frame.Parent = Gui.Leaderboard.Frame
				inset(frame, 4)
				
				--create the portrait image
				local image = Instance.new("ImageLabel")
				image.Size = UDim2.new(1, 0, 1, 0)
				image.SizeConstraint = Enum.SizeConstraint.RelativeYY
				image.Image = cPict
				image.Parent = frame
				
				--create the k/d/a text
				local kText = Text:Clone()
				kText.Size = UDim2.new(0.5, 0, 1, 0)
				kText.Position = UDim2.new(0.5, 0, 0, 0)
				kText.Text = kills.." / "..deaths.." / "..assists
				kText.Parent = frame
				
				--create the player label
				local pText = Text:Clone()
				pText.Size = UDim2.new(0.5, -image.AbsoluteSize.X, 0.5, 0)
				pText.Position = UDim2.new(0, image.AbsoluteSize.X, 0, 0)
				pText.Text = player.Name
				pText.TextXAlignment = Enum.TextXAlignment.Left
				pText.Parent = frame
				
				--create the character label
				local cText = Text:Clone()
				cText.Size = pText.Size
				cText.Position = pText.Position + UDim2.new(0, 0, 0.5, 0)
				cText.Text = cName
				cText.TextXAlignment = Enum.TextXAlignment.Left
				cText.Parent = frame
				
				--math all done, do insets
				inset(image, 4)
				inset(kText, 8)
				inset(pText, 8)
				inset(cText, 8)
				end
			end
		end
	end
	
	function Gui.Leaderboard.Open()
		Gui.Leaderboard.Frame.Visible = true
	end
	
	function Gui.Leaderboard.Close()
		Gui.Leaderboard.Frame.Visible = false
	end
	
	--open with e down, close with e up
	Mouse.KeyDown:connect(function(key)
		if key == "e" then
			Gui.Leaderboard.Open()
		end
	end)
	Gui.Leaderboard.ExitConnection = Mouse.KeyUp:connect(function(key)
		if key == "e" then
			Gui.Leaderboard.Close()
		end
	end)
	
	--close it to start
	Gui.Leaderboard.Close()
end

--this function constructs the death timer gui
local function constructDeathGui()
	--data structure
	Gui.Death = {}
	
	--object orientation
	--this method creates a death timer
	function Gui.Death.Create(t)
		--create a holding frame
		local frame = Frame:Clone()
		frame.Size = UDim2.new(0.35, 0, 0.4, 0)
		frame.Position = UDim2.new(0.325, 0, 0.1, 0)
		frame.BackgroundColor3 = ColorScheme.Tertiary
		frame.BorderColor3 = ColorScheme.Quaternary
		frame.Parent = ScreenGui
		Gui.Death.Frame = frame
		
		--create a timer text
		local timer = Text:Clone()
		timer.Size = UDim2.new(1, 0, 0.25, 0)
		timer.Text = "You have died. Respawn in: "..getTimeString(t)
		timer.Parent = frame
		
		--if we found a killer, display stuff
		local char = Player.Character
		local kill = char:FindFirstChild("KillCredit", true)
		if kill and kill.Value then
			local ps = kill.Value:FindFirstChild("PlayerState", true)
			if ps then
				local charName = otherGet(ps, "CharMods")
				local tips = game.ReplicatedStorage.Characters:FindFirstChild(charName).CounterTips.Value
				--create a text
				local text = Text:Clone()
				text.Size = UDim2.new(1, 0, 0.75, 0)
				text.Position = UDim2.new(0, 0, 0.25, 0)
				text.TextXAlignment = Enum.TextXAlignment.Left
				text.Text = "You were killed by "..charName..".\n\n"..tips
				text.Parent = frame
			end
		end
		
		--start the timer
		Spawn(function()
			while t > 0 do
				t = t - wait()
				timer.Text = "You have died. Respawn in: "..getTimeString(t)
			end
			frame:Destroy()
		end)
	end
	
	--this method updates the death timer to hide it behind stuff
	function Gui.Death.Update()
		if not Gui.Death.Frame then return end
		
		if Gui.Leaderboard.Frame.Visible or Gui.Shop.Frame.Visible then
			Gui.Death.Frame.Visible = false
		else
			Gui.Death.Frame.Visible = true
		end
	end
	
	--hook up the death message!
	R.ShowDeathTimer.OnClientEvent:connect(Gui.Death.Create)
end

--this function constructs the endgame gui
local function constructEndgameGui()
	--data structure
	Gui.Endgame = {}
	
	--object orientation
	--this method forces the leaderboard to stay open and that's it
	function Gui.Endgame.Begin()
		Gui.Leaderboard.ExitConnection:disconnect()
		Gui.Leaderboard.Open()
		
		--create a frame to show persistant stats
		local frame = Frame:Clone()
		frame.Size = UDim2.new(0.7, 0, 0.2, 0)
		frame.Position = UDim2.new(0.15, 0, 0.05, 0)
		frame.BackgroundColor3 = ColorScheme.Tertiary
		frame.BorderColor3 = ColorScheme.Quaternary
		frame.Visible = true
		frame.Parent = ScreenGui
		Gui.Leaderboard.Frame.Size = Gui.Leaderboard.Frame.Size - UDim2.new(0, 0, 0.25, 0)
		Gui.Leaderboard.Frame.Position = frame.Position + UDim2.new(0, 0, frame.Size.Y.Scale, 0)
		Gui.Leaderboard.Frame.Visible = true
		inset(frame, 8)
		
		--level notifier
		local level = Text:Clone()
		level.Size = UDim2.new(0.5, 0, 0.5, 0)
		level.Text = "Player level: "..playerGet"PlayerLevel"
		level.TextXAlignment = Enum.TextXAlignment.Left
		level.Parent = frame
		level.Visible = true
		inset(level, 4)
		
		--exp frame
		local expFrame = Frame:Clone()
		expFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
		expFrame.Position = UDim2.new(0, 0, 0.5, 0)
		expFrame.BackgroundColor3 = ColorScheme.Dark
		expFrame.BorderColor3 = ColorScheme.Dark
		expFrame.BorderSizePixel = 2
		expFrame.Parent = frame
		expFrame.Visible = true
		inset(expFrame, 4)
		
		--exp bar
		local p = playerGet"PlayerExperience" / playerGet"PlayerExperienceRequired"
		local expBar = Frame:Clone()
		expBar.Size = UDim2.new(p, 0, 1, 0)
		expBar.BackgroundColor3 = ColorScheme.Quaternary
		expBar.BorderSizePixel = 0
		expBar.Visible = true
		expBar.Parent = expFrame
		
		--exp label
		local expText = Text:Clone()
		expText.Size = UDim2.new(1, 0, 1, 0)
		expText.Text = "Experience: "..playerGet"PlayerExperience".." / "..playerGet"PlayerExperienceRequired"
		expText.Visible = true
		expText.Parent = expFrame
		
		--lifetime notices
		local stats = Text:Clone()
		stats.Size = UDim2.new(0.5, 0, 1, 0)
		stats.Position = UDim2.new(0.5, 0, 0, 0)
		stats.Text = "Lifetime kills: "..playerGet"LifetimeKills".."\n\nLifetime wins: "..playerGet"LifetimeWins"
		stats.TextXAlignment = Enum.TextXAlignment.Left
		stats.Visible = true
		stats.Parent = frame
		inset(stats, 4)
		
		local waypoints = workspace.Map:FindFirstChild("CameraWaypoints")
		if workspace.Map:FindFirstChild("CameraWaypoints") then
			local camera = Instance.new("Camera")
			camera.CameraType = Enum.CameraType.Scriptable
			camera.Parent = workspace
			workspace.CurrentCamera = camera
			
			while true do
				for _, val in pairs(waypoints:GetChildren()) do
					local cframe = val.Value
					
					camera:Interpolate(cframe, cframe * CFrame.new(0, 0, -256), 3)
					wait(4)
				end
				wait(4)
			end
		end
	end	
	
	--hook up the remote!
	R.Endgame.OnClientEvent:connect(Gui.Endgame.Begin)
end

--this function constructs the timer and k/d/a gui
local function constructTimerGui()
	--data structure
	Gui.Timer = {}
	
	--create the container frame
	local frame = Frame:Clone()
	frame.Name = "TimerFrame"
	frame.Size = UDim2.new(0.125, 0, 0.125, 0)
	frame.Position = UDim2.new(0.8, 0, .925, 0) + BottomLeftOffset
	frame.BackgroundColor3 = ColorScheme.Tertiary
	frame.BorderColor3 = ColorScheme.Quaternary
	frame.Parent = ScreenGui
	inset(frame, 4)
	Gui.Timer.Frame = frame
	
	--create a timer text
	local text = Text:Clone()
	text.Size = UDim2.new(1, 0, 0.5, 0)
	text.Parent = frame
	Gui.Timer.Text = text
	
	--create a my team kills
	local myKills = Text:Clone()
	myKills.Size = UDim2.new(1/3, 0, 0.5, 0)
	myKills.Position = UDim2.new(0, 0, 0.5, 0)
	myKills.TextStrokeColor3 = playerGet"TeamColor".Color
	myKills.Parent = frame
	inset(myKills, 4)
	Gui.Timer.MyKills = myKills
	
	--create an en team kills
	local enKills = Text:Clone()
	enKills.Size = UDim2.new(1/3, 0, 0.5, 0)
	enKills.Position = UDim2.new(2/3, 0, 0.5, 0)
	enKills.TextStrokeColor3 = playerGet"EnTeamColor".Color
	enKills.Parent = frame
	inset(enKills, 4)
	Gui.Timer.EnKills = enKills
	
	--create a kda
	local kda = Text:Clone()
	kda.Size = UDim2.new(1/3, 0, 0.5, 0)
	kda.Position = UDim2.new(1/3, 0, 0.5, 0)
	kda.Parent = frame
	Gui.Timer.KDA = kda
	
	--object orientation
	--this method updates
	function Gui.Timer.Update()
		Gui.Timer.Text.Text = "Match time: "..gameState.TimeString.Value
		Gui.Timer.MyKills.Text = playerGet"TeamKills"
		Gui.Timer.EnKills.Text = playerGet"EnTeamKills"
		Gui.Timer.KDA.Text = "K / D / A\n"..getStatNormal"Kills".." / "..getStatNormal"Deaths".." / "..getStatNormal"Assists"
	end
end

--this is our construction function, which builds our entire gui and stores the data
local function constructGui()
	--pause to allow absolutesize to properly initiate
	wait(1.5)
	
	--now begin the construction
	constructStatsGui()
	constructPortraitGui()
	constructBarsGui()
	--constructAbilitiesGui()
	constructShopGui()
	constructBackpackGui()
	constructLeaderboardGui()
	constructDeathGui()
	constructEndgameGui()
	constructTimerGui()
end

--this is our main update loop, which updates each part of the gui in order to display up-to-date information
local function update()
	--update everything
	Gui.Stats.Update()
	Gui.Portrait.Update()
	Gui.Bars.Update()
	--Gui.Abilities.Update()
	Gui.Shop.Update()
	Gui.Leaderboard.Update()
	Gui.Death.Update()
	Gui.Timer.Update()
end

--this function begins our main update loop using renderstepped
local function startUpdateLoop()
	game:GetService("RunService").RenderStepped:connect(update)
end

--this function yields until the player state is acquired, and until a character has been selected
local function acquirePlayerState()
	local backpack = Player:WaitForChild("Backpack")
	repeat wait() until backpack:FindFirstChild("PlayerState")
	PlayerState = backpack.PlayerState
	PlayerState:WaitForChild("CharacterName")
	PlayerState:WaitForChild("AbilityAName")
end

--this function performs pregame tasks for us such as map voting and confirming load
local function pregame()
	if gameState:FindFirstChild("GamemodeVotes") then
		--create a data structure
		Gui.GamemodeVote = {}
		
		--create a static label
		local text = Text:Clone()
		text.Size = UDim2.new(1, 0, 0.05, 0)
		text.Position = UDim2.new(0, 0, 0.05, 0)
		text.Text = "Vote for the gamemode to play!"
		text.Parent = ScreenGui
		table.insert(Gui.GamemodeVote, text)
		
		--create a timer
		local t = Text:Clone()
		t.Size = UDim2.new(1, 0, 0.05, 0)
		t.Position = UDim2.new(0, 0, 0.1, 0)
		
		gameState.GamemodeVoteTimer.Changed:connect(function()
			if gameState:FindFirstChild("GamemodeVoteTimer") then
			t.Text = gameState:FindFirstChild("GamemodeVoteTimer").Value
			end
		end)
		
		t.Parent = ScreenGui
		table.insert(Gui.GamemodeVote, t)
		
		--create a frame to contain each button
		local frame = Frame:Clone()
		frame.Size = UDim2.new(2/3, 0, 1/3, 0)
		frame.Position = UDim2.new((1 - 2/3) / 6, 0, 0.15, 0)
		frame.BackgroundTransparency = 1
		frame.Parent = ScreenGui
		table.insert(Gui.GamemodeVote, frame)
		
		--create buttons/counters for each map
		for idx, gamemode in pairs(gameState.GamemodeVotes:GetChildren()) do
			--create a counter
			local count = Text:Clone()
			count.Size = UDim2.new(1/3, 0, 1/5, 0)
			count.Position = UDim2.new(count.Size.X.Scale * (idx - 1), 0, 0, 0)
			count.Text = gamemode.Value
			local gamemodename = Text:Clone()
			gamemodename.Size = UDim2.new(1/3, 0, 1/5, 0)
			gamemodename.Position = UDim2.new(count.Size.X.Scale * (idx - 1), 0, 1.5, 0)
			gamemodename.Text = gamemode.Name
			gamemode.Changed:connect(function()
				count.Text = gamemode.Value
			end)
			
			count.Parent = frame
			gamemodename.Parent = frame
			--create a button
			local button = Instance.new("ImageButton")
			button.Size = UDim2.new(1/3, 0, 1/3, 0)
			button.SizeConstraint = Enum.SizeConstraint.RelativeXX
			button.Position = count.Position + UDim2.new(0, 0, count.Size.Y.Scale, 0)
			button.BackgroundColor3 = ColorScheme.Tertiary
			button.BorderColor3 = ColorScheme.Quaternary
			button.Image = getThumbnail(gamemode.Picture.Value)
			button.MouseButton1Click:connect(function()
				R.VoteOnGamemode:FireServer(gamemode.Name)
			end)
			
			button.Parent = frame
			inset(button, 8)
		end
		
		repeat wait() until not gameState:FindFirstChild("GamemodeVotes")
		
		for _, element in pairs(Gui.GamemodeVote) do
			element:Destroy()
		end
	end
	--gameState:WaitForChild("MapVotes")
	if gameState:FindFirstChild("MapVotes") then
		--create a data structure
		Gui.MapVote = {}
		
		--create a static label
		local text = Text:Clone()
		text.Size = UDim2.new(1, 0, 0.05, 0)
		text.Position = UDim2.new(0, 0, 0.05, 0)
		text.Text = "Vote for the map to play on!"
		text.Parent = ScreenGui
		table.insert(Gui.MapVote, text)
		
		--create a timer
		local t = Text:Clone()
		t.Size = UDim2.new(1, 0, 0.05, 0)
		t.Position = UDim2.new(0, 0, 0.1, 0)
		
		gameState.MapVoteTimer.Changed:connect(function()
			t.Text = gameState.MapVoteTimer.Value
		end)
		
		t.Parent = ScreenGui
		table.insert(Gui.MapVote, t)
		
		--create a frame to contain each button
		local frame = Frame:Clone()
		frame.Size = UDim2.new(2/3, 0, 1/3, 0)
		frame.Position = UDim2.new((1 - 2/3) / 6, 0, 0.15, 0)
		frame.BackgroundTransparency = 1
		frame.Parent = ScreenGui
		table.insert(Gui.MapVote, frame)
		
		--create buttons/counters for each map
		for idx, map in pairs(gameState.MapVotes:GetChildren()) do
			--create a counter
			local count = Text:Clone()
			count.Size = UDim2.new(1/3, 0, 1/5, 0)
			count.Position = UDim2.new(count.Size.X.Scale * (idx - 1), 0, 0, 0)
			count.Text = map.Value
			
			map.Changed:connect(function()
				count.Text = map.Value
			end)
			
			count.Parent = frame
			
			--create a button
			local button = Instance.new("ImageButton")
			button.Size = UDim2.new(1/3, 0, 1/3, 0)
			button.SizeConstraint = Enum.SizeConstraint.RelativeXX
			button.Position = count.Position + UDim2.new(0, 0, count.Size.Y.Scale, 0)
			button.Image = getThumbnail(map.Name)
			button.BackgroundColor3 = ColorScheme.Tertiary
			button.BorderColor3 = ColorScheme.Quaternary
			
			button.MouseButton1Click:connect(function()
				R.VoteOnMap:FireServer(map.Name)
			end)
			
			button.Parent = frame
			inset(button, 8)
		end
		
		repeat wait() until not gameState:FindFirstChild("MapVotes")
		
		for _, element in pairs(Gui.MapVote) do
			element:Destroy()
		end
	end
	
	--create a join button
	local join = Button:Clone()
	join.Size = UDim2.new(1/5, 0, 1/10, 0)
	join.Position = UDim2.new((1 - join.Size.X.Scale) / 2, 0, (1 - join.Size.Y.Scale) / 2, 0)
	join.Text = "Join the battle!"
	
	join.MouseButton1Click:connect(function()
		R.RequestTeam:FireServer()
		R.UnlockSkins:FireServer()
		join:Destroy()
		game.Workspace.Camera:ClearAllChildren()
	end)
	
	join.Parent = ScreenGui
	
	local update = Text:Clone()
	update.Size = UDim2.new(2.5, 0, 1, 0)
	update.Position = UDim2.new(-0.75, 0, 1, 16)
	update.Text = "Updates are in progress!\nClick Update Log in the bottom right corner to see the complete list."
	update.Parent = join
end

--this is our main function, which directs initial execution
local function main()
	
	pregame()
	script.Parent.GamemodeStatic.Text = "The Gamemode is "..gameState.Gamemode.Value
	gameState.Gamemode.Changed:connect(function(NewValue)
	script.Parent.GamemodeStatic.Text = "The Gamemode is "..NewValue
	end)
	acquirePlayerState()
	constructGui()
	Stats =  require(game.ReplicatedStorage.PlayerStats:WaitForChild(game.Players.LocalPlayer.Character.Name))
	startUpdateLoop()
	
	game.Workspace.Camera:ClearAllChildren()
end

--begin execution
main()
function setstat(statName,value)
	local STATS = Stats.Stats
	STATS[statName] = value
end
game.ReplicatedStorage.Remotes.UpdatePlayerStatGui.OnClientEvent:connect(setstat)

