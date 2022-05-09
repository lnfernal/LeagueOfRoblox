local SG = script.Parent
local PLAYER = SG.Parent.Parent
local INFO = SG.InfoFrame.ExtraInfoFrame
local INFO_LABEL_BASE = INFO.ExtraInfoLabelBase:Clone()
local INFO_DEFAULTS = {Position = INFO.Position, Size = INFO.Size}

local R = game.ReplicatedStorage.Remotes

local GS = Game.ReplicatedStorage.GameState

local Frame, Text, Button = unpack(require(Game.ReplicatedStorage.BaseGuis))
local GetThumbnail = require(Game.ReplicatedStorage.GetThumbnail)

--lerp
local function lerp(a, b, p)
	return a + (b - a) * p
end

local function trunc(num, places)
	return math.floor(num * (10 ^ places)) / (10 ^ places)
end

local function lerpColor(a, b, p)
	local c = lerp(a, b, p) / 255
	return Color3.new(c.x, c.y, c.z)
end

--this function connects each gui element to its player state variable
local function startPlayerStateHandling()
	local bp = PLAYER:WaitForChild("Backpack")
	local ps repeat ps = bp:FindFirstChild("PlayerState") wait() until ps
	local gui = SG.InfoFrame
	
	local function g(n)
		return gui:FindFirstChild(n, true)
	end
	
	local function v(n)
		return ps[n].Value
	end
	
	local function gv(n)
		return GS[n].Value
	end
	
	local function c()
		return Game:GetService("RunService").Heartbeat
	end
	
	--one-time gui changes
	g"TeamKillsLabel".TextColor3 = v"TeamColor".Color
	g"EnTeamKillsLabel".TextColor3 = v"EnTeamColor".Color
	
	--complex sets
	c():connect(function()
		local p = v"Health" / v"MaxHealth"
		g"HealthBar".Size = UDim2.new(p, 0, 1, 0)
		g"HealthLabel".Text = trunc(v"Health", 0).."/"..v"MaxHealth"
	end)
	
	c():connect(function()
		local p = v"Exp" / v"MaxExp"
		g"ExpBar".Size = UDim2.new(p, 0, 1, 0)
		g"ExpLabel".Text = trunc(v"Exp", 0).."/"..v"MaxExp"
	end)
	
	c():connect(function()
		g"MyKillLabel".Text = v"Kills".." / "..v"Deaths".." / "..v"Assists"
	end)
	
	c():connect(function()
		g"TimeLabel".Text = gv"TimeString"
	end)
	
	--ability sets
	for _, ltr in pairs{"A", "B", "C", "D"} do
		local id = "Ability"..ltr
		c():connect(function()
			local p = 1 - v(id.."Cooldown")/v(id.."MaxCooldown")
			g(ltr.."Bar").Size = UDim2.new(p, 0, 1, 0)
			g(ltr.."Bar").BackgroundColor3 = lerpColor(
				Vector3.new(0, 0, 0),
				Vector3.new(127, 127, 127),
				p
			)
			if v(id.."Cooldown") == 0 then
				g(ltr.."Bar").BackgroundColor3 = Color3.new(1, 1, 1)
			end
		end)
	end
	
	--simple sets
	local sets = "Speed Skillz H4x Toughness Resistance Level Tix TeamKills EnTeamKills"
	for var in string.gmatch(sets, "%w+") do
		c():connect(function()
			g(var.."Label").Text = trunc(v(var), 1)
		end)
	end
	
	--this handles game state stuff
	
end

function apply(obj, props)
	if not obj then return end
	
	for propName, propValue in pairs(props) do
		obj[propName] = propValue
	end
end

function setupMouseOver(element)
	element.MouseMoved:connect(function()
		INFO:ClearAllChildren()
		INFO.Size = INFO_DEFAULTS.Size
		INFO.Position = INFO_DEFAULTS.Position
		
		local rows = {}
		table.insert(rows, element.Desc.Value)
		for _, extraDesc in pairs(element.Desc:GetChildren()) do
			table.insert(rows, extraDesc.Value)
		end
		
		local yIncrease = (#rows - 1) * 0.1
		local sizeIncrease = UDim2.new(0, 0, yIncrease, 0)
		INFO.Size = INFO.Size + sizeIncrease
		INFO.Position = INFO.Position - sizeIncrease
		
		local y = 0
		local sizeY = 1 / (#rows + 1)
		local first = true
		for _, row in pairs(rows) do
			local newLabel = INFO_LABEL_BASE:Clone()
			newLabel.Text = row
			newLabel.Size = UDim2.new(1, -4, sizeY, -4)
			newLabel.Position = UDim2.new(0, 2, y * sizeY, 2)
			newLabel.Parent = INFO
			y = y + 1
			
			if first then
				newLabel.Size = newLabel.Size + UDim2.new(0, 0, sizeY, 0)
				y = y + 1
				first = false
			end
		end
		
		INFO.Visible = true
	end)
	element.MouseLeave:connect(function()
		INFO.Visible = false
		INFO:ClearAllChildren()
	end)
end

R.UpdateGuiObj.OnClientInvoke = function(objectName, props)
	apply(SG:FindFirstChild(objectName, true), props)
end

R.UpdateGui.OnClientEvent:connect(function(update)
	for objName, props in pairs(update) do
		apply(SG:FindFirstChild(objName, true), props)
	end
end)

R.Describe.OnClientEvent:connect(function(objectName, description, ...)
	local obj = SG:FindFirstChild(objectName, true)
	if obj then
		local desc = obj:FindFirstChild("Desc")
		if not desc then
			desc = Instance.new("StringValue")
			desc.Name = "Desc"
			desc.Parent = obj
			
			setupMouseOver(obj)
		end
		desc.Value = description
		
		desc:ClearAllChildren()
		for _, extraDescription in pairs{...} do
			local extraDesc = Instance.new("StringValue", desc)
			extraDesc.Name = "ExtraDesc"
			extraDesc.Value = extraDescription
		end
	end
end)

function setupDescriptions(root)
	for _, child in pairs(root:GetChildren()) do
		if child.Name == "Desc" then
			setupMouseOver(child.Parent)
		end
		setupDescriptions(child)
	end
end
setupDescriptions(SG)

--music stuff
function stopMusic()
	if CURRENT_MUSIC then
		CURRENT_MUSIC:Destroy()
	end
end

function playMusic(soundId)
	stopMusic()
	
	local sound = Instance.new("Sound")
	sound.SoundId = "http://www.roblox.com/asset/?id="..soundId
	sound.Volume = 0.3
	sound.Looped = true
	sound.Parent = workspace
	sound:Play()
	
	CURRENT_MUSIC = sound
end

function changeMusicVolume(delta)
	CURRENT_MUSIC.Volume = CURRENT_MUSIC.Volume + delta
end

local SONGS = {
	CharacterSelect = 162680885,
	Victory = 144525054,
	Defeat = 134047059,
	Battle = 144396704,
}

script.PlayMusic.OnInvoke = playMusic
script.ChangeVolume.OnInvoke = changeMusicVolume
script.GetSongs.OnInvoke = function()
	return SONGS
end

local vFrame = SG:WaitForChild("VolumeFrame")
vFrame.UpButton.MouseButton1Click:connect(function()
	changeMusicVolume(0.1)
end)
vFrame.DownButton.MouseButton1Click:connect(function()
	changeMusicVolume(-0.1)
end)
while not PLAYER.Character do wait() end
PLAYER.Character:WaitForChild("Humanoid").Died:connect(function()
	stopMusic()
end)
--/music stuff

--level up buttons stuff
function levelUpButtons()
	local buttons = {}
	
	local function hideButtons()
		for _, button in pairs(buttons) do
			button.Visible = false
		end
	end
	
	for _, abilityName in pairs({"A", "B", "C", "D"}) do
		table.insert(buttons, SG.InfoFrame.AbilitiesFrame[abilityName][abilityName.."LevelUp"])
	end
	
	for _, button in pairs(buttons) do
		button.MouseButton1Click:connect(function()
			hideButtons()
			R.LevelUpAbility:InvokeServer(button.Name:sub(1, 1))
		end)
	end
end
levelUpButtons()
--/level up buttons stuff

--shop stuff
function createShop()
	local shop = game.ReplicatedStorage.Shop
	local frame = SG.ShopFrame
	local base = game.ReplicatedStorage.ItemFrameBase:clone()
	local info = frame.ShopDesc
	
	local tabs = {}
	
	local function hideTabs()
		for _, tab in pairs(tabs) do
			tab.Frame.Visible = false
		end
	end
	
	local function resizeTabButtons()
		local sizeX = 1 / #tabs
		local posX = 0
		for _, tab in pairs(tabs) do
			tab.Button.Size = UDim2.new(sizeX, -4, 0.1, -4)
			tab.Button.Position = UDim2.new(posX, 2, 0, 2)
			
			posX = posX + sizeX
		end
	end
	
	local function createTab(name)
		local tabFrame = Instance.new("Frame")
		tabFrame.BackgroundTransparency = 1
		tabFrame.Size = UDim2.new(1, 0, 0.9, 0)
		tabFrame.Position = UDim2.new(0, 0, 0.1, 0)
		tabFrame.Name = name
		tabFrame.Visible = false
		tabFrame.Parent = frame
		
		local tabButton = base.BuyButton:clone()
		tabButton.Text = name
		tabButton.Name = name.."TabButton"
		tabButton.MouseButton1Click:connect(function()
			hideTabs()
			tabFrame.Visible = true
		end)
		tabButton.Parent = frame
		
		local function addItemFrame(newItemFrame)
			local itemFrames = tabFrame:GetChildren()
			table.insert(itemFrames, newItemFrame)
			local sizeY = 1 / #itemFrames
			local posY = 0
			for _, itemFrame in pairs(itemFrames) do
				itemFrame.Size = UDim2.new(1, -4, sizeY, -4)
				itemFrame.Position = UDim2.new(0, 2, posY, 2)
				itemFrame.Parent = tabFrame
				
				posY = posY + sizeY
			end
		end
		
		local tab = {Name = name, Frame = tabFrame, Button = tabButton, AddItemFrame = addItemFrame}
		table.insert(tabs, tab)
		
		resizeTabButtons()
		
		return tab
	end

	local function getTab(name)
		for _, tab in pairs(tabs) do
			if tab.Name == name then
				return tab
			end
		end
		return createTab(name)
	end
	
	local function getCategories(item)
		local categories = {}
		for _, child in pairs(item:GetChildren()) do
			if child.Name == "Category" then
				table.insert(categories, child.Value)
			end
		end
		return categories
	end
	
	local function shopFrame(item, y)
		local categories = getCategories(item)
		
		for _, category in pairs(categories) do
			local tab = getTab(category)
			
			local new = base:clone()
			new.Visible = true
			new.Position = UDim2.new(0, 0, new.Size.Y.Scale * y, 0)
			new.BuyButton.Text = item.Name
			new.CostFrame.Label.Text = item.Cost.Value
			new.DescFrame.Label.Text = item.Desc.Value
			new.Image.Image = item.Image.Value
			
			local reqItems = item:FindFirstChild("Req")
			if reqItems then
				new.ReqWarning.Visible = true
				
				local x = 0
				local reqBase = new.RequiredItemBase:clone()
				for _, reqItem in pairs(reqItems:GetChildren()) do
					local reqFrame = reqBase:clone()
					reqFrame.Label.Text = reqItem.Name
					reqFrame.Position = reqFrame.Position - UDim2.new(reqFrame.Size.X.Scale * x, 0, 0, 0)
					reqFrame.Visible = true
					reqFrame.Parent = new
					
					x = x + 1
				end
			end
			
			new.BuyButton.MouseButton1Down:connect(function()
				R.AttemptShopBuy:InvokeServer(item)
			end)
			new.MouseMoved:connect(function()
				info.Text = item.Desc.Value
			end)
			new.MouseLeave:connect(function()
				info.Text = ""
			end)
			
			tab.AddItemFrame(new)
		end
	end
	
	local y = 0
	for _, item in pairs(shop:GetChildren()) do
		shopFrame(item, y)
		
		y = y + 1
	end
	
	SG.InfoFrame.ShopButton.MouseButton1Click:connect(function()
		frame.Visible = not frame.Visible
	end)
end
createShop()
--/shop stuff

--endgame stuff
local CUSTOM_CAM = Instance.new("Camera")
CUSTOM_CAM.CameraType = "Scriptable"

function startZooming()	
	CUSTOM_CAM.Parent = workspace
	workspace.CurrentCamera = CUSTOM_CAM
	
	while workspace.CurrentCamera == CUSTOM_CAM do
		for _, cframe in pairs(workspace.Map.CameraWaypoints:GetChildren()) do
			cframe = cframe.Value
			
			CUSTOM_CAM:Interpolate(cframe, cframe * CFrame.new(0, 0, -256), 3)
			wait(4.5)
		end
	end
end

function endgame(data)
	SG.InfoFrame.Visible = false
	
	local egf = game.ReplicatedStorage.EndgameFrame:clone()
	
	local function get(name)
		return egf:FindFirstChild(name, true)
	end
	
	if data.WinnerName == data.MyTeamName then
		playMusic(SONGS.Victory)
	else
		playMusic(SONGS.Defeat)
	end
	
	--display the winner
	get("WinnerLabel").Text = data.WinnerName.." Wins!"
	get("WinnerLabel").TextColor3 = data.WinnerColor
	
	--display my team
	get("LeftTeamLabel").Text = data.MyTeamName
	get("LeftTeamLabel").TextColor3 = data.MyTeamColor
	
	--display enemy team
	get("RightTeamLabel").Text = data.EnTeamName
	get("RightTeamLabel").TextColor3 = data.EnTeamColor
	
	--set my lifetime kills/wins
	get("LifetimeKillsLabel").Text = data.LifetimeKills
	get("LifetimeWinsLabel").Text = data.LifetimeWins
	
	--set my player level and exp
	get("PlayerLevelLabel").Text = data.PlayerLevel
	get("PlayerExpBar").Size = UDim2.new(data.PlayerProgress, 0, 1, 0)
	
	--tackle the player list
	local leftY = 0.2
	local rightY = 0.2
	for _, playerData in pairs(data.PlayerData) do
		local plf = egf.PlayerFrame:clone()
		plf.Visible = true
		plf.NameLabel.Text = playerData.Name
		plf.CharacterLabel.Text = playerData.Character
		plf.KillsDeathsLabel.Text = playerData.KillsDeaths
		if playerData.Ally then
			plf.Position = UDim2.new(0, 2, leftY, 2)
			leftY = leftY + 0.1
		else
			plf.Position = UDim2.new(0.5, 2, rightY, 2)
			rightY = rightY + 0.1
		end
		plf.Parent = egf
	end
	
	egf.Parent = SG
	
	startZooming()
end
R.Endgame.OnClientInvoke = endgame
--/endgame stuff

--item render stuff
local itemConnections = {}
function renderItems(items)
	items = items:GetChildren()
	
	--clear all the old frames
	local frame = SG.InfoFrame
	for _, element in pairs(frame:GetChildren()) do
		if element.Name == "ItemFrame" then
			element:Destroy()
		end
	end
	
	--disconnect everything
	for _, connection in pairs(itemConnections) do
		connection:disconnect()
	end
	
	local base = frame.BaseItemFrame:clone()
	base.Visible = true
	base.Name = "ItemFrame"
	
	local y = 0
	for _, item in pairs(items) do
		local new = base:clone()
		
		--show the name of the item
		new.Label.Text = item.Name
		if item:FindFirstChild("Hotkey") then
			new.Label.Text = new.Label.Text.." ("..item.Hotkey.Value..")"
		end
		
		--let people sell
		table.insert(itemConnections,
			new.SellButton.MouseButton1Click:connect(function()
				new.SellButton.Visible = false
				R.AttemptShopSell:InvokeServer(item)
			end)
		)
		new.SellButton.Visible = SG.InfoFrame.ShopButton.Visible
		
		--ensure you can only sell when in range of shop
		table.insert(itemConnections,
			frame.ShopButton.Changed:connect(function()
				new.SellButton.Visible = frame.ShopButton.Visible
			end)
		)
		
		--describe the item and setup mouseover
		local desc = Instance.new("StringValue")
		desc.Name = "Desc"
		desc.Value = item.Desc.Value
		desc.Parent = new
		setupMouseOver(new)
		
		--place it
		new.Position = base.Position + UDim2.new(0, 0, y, 0)
		
		--parent that
		new.Parent = frame
		
		--increment y
		y = y - base.Size.Y.Scale
	end
end
R.RenderItems.OnClientInvoke = renderItems
--/item render stuff

SG:WaitForChild("VolumeFrame"):WaitForChild("HelpButton").MouseButton1Click:connect(function()
	if SG:FindFirstChild("TutorialFrame") then return end
	
	local tutorialFrame = game.ReplicatedStorage.TutorialFrame:Clone()
	tutorialFrame.Parent = SG
end)

--death timer stuff
function showDeathTimer(deathTime)
	local function numToTime(t)
		local minutes = math.floor(t / 60)
		local seconds = math.floor(t - minutes * 60)
		if seconds < 10 then
			seconds = "0"..seconds
		end
		return minutes..":"..seconds
	end
	
	local newTimer = game.ReplicatedStorage.DeathTimer:Clone()
	newTimer.Parent = SG
	
	--tips stuff
	local tipsFrame = newTimer.TipsFrame
	local killerLabel = tipsFrame.KillerLabel
	local tipsLabel = tipsFrame.TipsLabel
	local char = PLAYER.Character
	tipsFrame.Visible = false
	if char then
		local kc = char:FindFirstChild("KillCredit", true)
		if kc then
			local killer = kc.Value
			if killer then
				local charNameVal = killer:FindFirstChild("CharacterName", true)
				if charNameVal then
					local char = game.ReplicatedStorage.Characters:FindFirstChild(charNameVal.Value)
					if char then
						tipsFrame.Visible = true
						killerLabel.Text = char.Name.." killed you."
						tipsLabel.Text = char.CounterTips.Value
					end
				end
			end
		end
	end
	
	local timeLabel = newTimer.TimeLabel
	local renderStepped = game:GetService("RunService").RenderStepped
	while deathTime > 0 do
		deathTime = deathTime - wait()
		
		timeLabel.Text = numToTime(deathTime)
		
		newTimer.Visible = not SG.ShopFrame.Visible
	end
	newTimer:Destroy()
end
R.ShowDeathTimer.OnClientEvent:connect(showDeathTimer)
--/death timer stuff

--status effect stuff
function showEffect(effectMessage)
	local function r()
		return math.random(-40, 40)
	end
	
	local newEffect = game.ReplicatedStorage.EffectPopup:Clone()
	newEffect.EffectLabel.Text = effectMessage
	
	local siz = newEffect.Size
	local del = UDim2.new(siz.X.Scale / 2, 0, siz.Y.Scale / 2, 0)
	local pos = newEffect.Position + del + UDim2.new(0, r(), 0, r())
	local lab = newEffect.EffectLabel
	
	newEffect.Position = pos
	newEffect.Size = UDim2.new(0, 0, 0, 0)
	newEffect.Parent = SG
	
	newEffect:TweenSizeAndPosition(siz, pos - del, nil, nil, 0.2)
	wait(0.2)
	
	local trans = 0
	local transSpeed = 1 / 0.2
	while trans < 1 do
		trans = trans + transSpeed * wait()
		lab.TextTransparency = trans
		lab.TextStrokeTransparency = trans
	end
	
	newEffect:Destroy()
end
R.ShowEffect.OnClientEvent:connect(showEffect)
--/status effect stuff

--damage flash stuff
function damageFlash()
	local flash = Instance.new("Frame")
	flash.BackgroundColor3 = Color3.new(0.8, 0, 0)
	flash.Size = UDim2.new(2, 0, 2, 0)
	flash.Position = UDim2.new(-0.5, 0, -0.5, 0)
	
	local trans = 0.5
	local transSpeed = 0.5 / 0.15
	
	flash.Transparency = trans
	flash.Parent = SG
	
	while trans < 1 do
		trans = trans + transSpeed * wait()
		flash.BackgroundTransparency = trans
	end
	flash:Destroy()
end
R.DamageFlash.OnClientEvent:connect(damageFlash)
--/damage flash stuff

--leaderboard stuff
function leaderboard(data)
	stopLeaderboard()
		
	local lbf = game.ReplicatedStorage.LeaderboardFrame:Clone()
	
	local function get(name)
		return lbf:FindFirstChild(name, true)
	end
	
	--display my team
	get("LeftTeamLabel").Text = data.MyTeamName
	get("LeftTeamLabel").TextColor3 = data.MyTeamColor
	
	--display enemy team
	get("RightTeamLabel").Text = data.EnTeamName
	get("RightTeamLabel").TextColor3 = data.EnTeamColor
	
	--tackle the player list
	local leftY = 0.1
	local rightY = 0.1
	for _, playerData in pairs(data.PlayerData) do
		local plf = lbf.PlayerFrame:clone()
		plf.Visible = true
		plf.NameLabel.Text = playerData.Name
		plf.CharacterLabel.Text = playerData.Character
		plf.KillsDeathsLabel.Text = playerData.KillsDeaths
		if playerData.Ally then
			plf.Position = UDim2.new(0, 2, leftY, 2)
			leftY = leftY + 0.1
		else
			plf.Position = UDim2.new(0.5, 2, rightY, 2)
			rightY = rightY + 0.1
		end
		plf.Parent = lbf
	end
	
	lbf.Parent = SG
end
R.Leaderboard.OnClientEvent:connect(leaderboard)

function stopLeaderboard()
	for _, obj in pairs(SG:GetChildren()) do
		if obj.Name == "LeaderboardFrame" then
			obj:Destroy()
		end
	end
end
R.StopLeaderboard.OnClientEvent:connect(stopLeaderboard)
--/leaderboard stuff

--join game stuff
local joinButton = SG.JoinButton
function joinGame()
	R.RequestTeam:FireServer()
	joinButton:Destroy()
end
joinButton.MouseButton1Click:connect(joinGame)

if GS:FindFirstChild("MapVotes") then
	joinButton.Visible = false
	
	--container for easy deletion	
	local mapVoteGuis = {}
	
	--an easy label
	local label = Text:Clone()
	label.Size = UDim2.new(1, 0, 0.05, 0)
	label.Position = UDim2.new(0, 0, 0.1, 0)
	label.Text = "Vote for the map you would like to play!"
	label.Parent = SG
	table.insert(mapVoteGuis, label)
	
	--make a timer
	local timer = Text:Clone()
	timer.Size = UDim2.new(1, 0, 0.1, 0)
	timer.Position = UDim2.new(0, 0, 0.15, 0)
	timer.Text = GS.MapVoteTimer.Value
	timer.Parent = SG
	GS.MapVoteTimer.Changed:connect(function()
		timer.Text = GS.MapVoteTimer.Value
		if GS.MapVoteTimer.Value <= 5 then
			timer.TextColor3 = Color3.new(1, 0, 0)
		end
	end)
	table.insert(mapVoteGuis, timer)
	
	--button and counter for each map chosen this round
	for idx, mapVotes in pairs(GS.MapVotes:GetChildren()) do
		local id = mapVotes.Name
		local pos = idx - 2
		
		local votes = Text:Clone()
		votes.Size = UDim2.new(0.2, 0, 0.05, 0)
		votes.Position = UDim2.new(0.4 - votes.Size.X.Scale * pos, 0, 0.25, 0)
		votes.Text = mapVotes.Value
		votes.Parent = SG
		
		mapVotes.Changed:connect(function()
			votes.Text = mapVotes.Value
		end)
		
		local imgFrame = Frame:Clone()
		imgFrame.Size = UDim2.new(votes.Size.X.Scale, -16, votes.Size.X.Scale, -16)
		imgFrame.SizeConstraint = Enum.SizeConstraint.RelativeXX
		imgFrame.Position = votes.Position + UDim2.new(0, 8, votes.Size.Y.Scale, 8)
		imgFrame.Parent = SG
		
		local img = Instance.new("ImageButton")
		img.BackgroundTransparency = 1
		img.Image = GetThumbnail(id)
		img.Size = UDim2.new(1, 0, 1, 0)
		img.Parent = imgFrame
		
		img.MouseButton1Click:connect(function()
			R.VoteOnMap:FireServer(id)
		end)
		
		table.insert(mapVoteGuis, votes)
		table.insert(mapVoteGuis, imgFrame)
	end

	--pause until MapVotes is removed
	local e = Instance.new("BindableEvent")
	GS.ChildRemoved:connect(function(obj)
		if obj.Name == "MapVotes" then
			e:Fire()
		end
	end)
	e.Event:wait()
	
	--destroy all the guis
	for _, gui in pairs(mapVoteGuis) do
		gui:Destroy()
	end
	
	--restore the join button
	joinButton.Visible = true
end
--/join game stuff

--final stuff to do
startPlayerStateHandling()