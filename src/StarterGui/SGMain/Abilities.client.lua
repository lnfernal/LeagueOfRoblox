--the player
local Player = game.Players.LocalPlayer
--Stats
local Stats
local ABILITY_DATA
local STATUSES
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
local PlayerState = Player.Backpack:WaitForChild("PlayerState")
--this global holds the mouse-over box
local MouseOverBox = nil
local MouseOveritem = nil
--this global holds the mouse
local Mouse = Player:GetMouse()
local STUNNED = false
--this function returns the thumbnail of an asset
local getThumbnail = require(game.ReplicatedStorage.GetThumbnail)
local Online = not game:FindFirstChild("ServerStorage")
--this function returns a value from the player state
local function playerGet(key)
	local val = PlayerState:FindFirstChild(key)
	if val then
		return val.Value
	end
	return 0
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
--Handles AbilityCooldowns


--this function creates the ability guis
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
	local maxLevel = ABILITY_DATA[ability].MaxLevel
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
local function constructAbilitiesGui()
	
	--create a container frame
	local frame = Frame:Clone()
	frame.Name = "AbilitiesFrame"
	frame.Size = UDim2.new(0.275, 0, 0.13, 0)
	frame.Position = UDim2.new(0.3625, 0, 1.01 - frame.Size.Y.Scale -  0.05, 0)
	frame.BackgroundColor3 = ColorScheme.Quaternary
	frame.BorderColor3 = ColorScheme.Tertiary
	frame.Parent = ScreenGui
	Gui.Frame = frame
	
	--ability a frame
	local a = constructAbilityGui(frame, "A", UDim2.new(0.01, 0, -0.11, 0))
	--a.Text.Text = "1"
	Gui.A = a
	
	--ability b frame
	local b = constructAbilityGui(frame, "B", UDim2.new(0.26, 0, -0.11, 0))
	--b.Text.Text = "2"
	Gui.B = b
	
	--ability c frame
	local c = constructAbilityGui(frame, "C", UDim2.new(0.51, 0, -0.11, 0))
	--c.Text.Text = "3"
	Gui.C = c
	
	--ability d frame
	local d = constructAbilityGui(frame, "D", UDim2.new(0.76, 0, -0.11, 0))
	--d.Text.Text = "4"
	Gui.D = d
	
	--done with math, perform insets
	inset(frame, 2)
	
	--object orientation
	--this table holds a shortcut
	Gui.FrameTexts = {
		A = ABILITY_DATA["A"].Name.."\n1",
		B = ABILITY_DATA["B"].Name.."\n2",
		C =ABILITY_DATA["C"].Name.."\n3",
		D = ABILITY_DATA["D"].Name.."\n4",
	}
	
	--this method updates each of the ability frames
	
end
function Update(dt)

		
		for _, ltr in pairs{"A", "B", "C", "D"} do
			--gather some information
			local id = "Ability"..ltr
			local frame = Gui[ltr]
			local abilityPoints = playerGet("AbilityPoints")
			local ability = Stats.Stats.Abilities[ltr]
			local maxLevel = ABILITY_DATA[ltr].MaxLevel
			local level = ability.Level or 0
			
			--perform cooldown duties
			if ability.OnCooldown then
				frame.Text.TextColor3 = ColorScheme.HealthLow
				
				--get the text
				local cd = ability.CooldownLeft
				local text = tostring(trunc(cd, 1))
				frame.cooldown.BackgroundTransparency = 0.3
				frame.cooldown.BorderSizePixel = 1
				frame.cooldown.Size = UDim2.new(1, 0,0-(1 * trunc(cd, 1) / trunc((ability.Cooldown), 0)))
				local text = tostring(trunc(cd, 1))
				if not text:find("%.") then
					text = text..".0"
				end
				frame.Text.Text = text
				if trunc(cd, 1) == 0 then
				frame.cooldown.BackgroundTransparency = 1
				frame.cooldown.BorderSizePixel = 1	
				frame.Text.Text = ""
				end
			elseif frame.Image == "" then
				frame.Text.TextColor3 = Color3.new(255,255,255)
				frame.Text.Text = Gui.FrameTexts[ltr]
			else
				frame.cooldown.BackgroundTransparency = 1
				frame.cooldown.BorderSizePixel = 1	
				frame.Text.Text = ""
			end
			
			--show the level with dots
			for number = 1, maxLevel do
				local dot = frame[number]
				if number <= level then
					dot.BackgroundColor3 = ColorScheme.Primary
				else
					dot.BackgroundColor3 = ColorScheme.Dark
				end
			end
			
			--show the level up button
		
			frame.Button.Visible = abilityPoints > 0 and level < maxLevel
		end
		end

function update(dt)
	Update(dt)
	for index, ability in pairs(Stats.Stats.Abilities) do
		if ability.OnCooldown and Online then
			ability.CooldownLeft = ability.CooldownLeft - dt
			if ability.CooldownLeft <= 0 then
				ability.CooldownLeft = 0
				ability.OnCooldown = false
			end
		end
	end
end
local function startUpdateLoop()
	game:GetService("RunService").RenderStepped:connect(update)
end

function main()
Stats =  require(game.ReplicatedStorage.PlayerStats:WaitForChild(game.Players.LocalPlayer.Character.Name))
repeat wait() until Stats and ABILITY_DATA and playerGet("CharMods") ~= 0

constructAbilitiesGui()
startUpdateLoop()
end

--begin execution
function requestAbilityData(data)
	ABILITY_DATA = data
end

game.ReplicatedStorage.Remotes.UpdateData.OnClientEvent:connect(requestAbilityData)


main()

local STATS = Stats.Stats



if Online then
function AbilityCooldown(ability, cooldown)
	if STATS.Abilities[ability].OnCooldown == true then
	STATS.Abilities[ability].OnCooldown = true
	STATS.Abilities[ability].CooldownLeft = math.max(STATS.Abilities[ability].CooldownLeft, cooldown)
	STATS.Abilities[ability].Cooldown = STATS.Abilities[ability].CooldownLeft + cooldown	
	else
	STATS.Abilities[ability].OnCooldown = true
	STATS.Abilities[ability].CooldownLeft = math.max(STATS.Abilities[ability].CooldownLeft, cooldown)
	STATS.Abilities[ability].Cooldown = cooldown
	end
end

function AbilityCooldownReduce(ability, reduction)
	local ability = STATS.Abilities[ability]
	ability.CooldownLeft = ability.CooldownLeft - reduction
	if ability.CooldownLeft <= 0 then
		ability.CooldownLeft = 0
		ability.OnCooldown = false
	end
end

function AbilityCooldownLag(ability, increase)
	local ability = STATS.Abilities[ability]
	ability.CooldownLeft = ability.CooldownLeft
	if ability.CooldownLeft < increase then
		ability.CooldownLeft = increase
		ability.Cooldown = increase
		ability.OnCooldown = true
	end
	end

function AbilityLevelUp(ability)
	if playerGet("AbilityPoints") >= 1 then
		local ability = STATS.Abilities[ability]
		if ability.Level < ABILITY_DATA[ability.Id].MaxLevel then
			
			ability.Level = ability.Level + 1
			
		end
	end
end

--Hookup
game.ReplicatedStorage.Remotes.AbilityLevelUp.OnClientEvent:connect(AbilityLevelUp)

game.ReplicatedStorage.Remotes.AbilityCooldownLag.OnClientEvent:connect(AbilityCooldownLag)

game.ReplicatedStorage.Remotes.AbilityCooldownReduce.OnClientEvent:connect(AbilityCooldownReduce)

game.ReplicatedStorage.Remotes.AbilityCooldown.OnClientEvent:connect(AbilityCooldown)

 end

STATUSES = Player.Character:WaitForChild("Statuses")

