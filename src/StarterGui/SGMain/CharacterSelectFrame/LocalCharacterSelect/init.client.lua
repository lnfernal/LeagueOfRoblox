local gameState = game.ReplicatedStorage.GameState
local GUI = script.Parent
local PLAYER = game.Players.LocalPlayer
local PLAYER_LEVEL = 0
local Event = ""
local BASE = GUI.ButtonBase
local FRAME = GUI.CharacterFrame
local MARKET = game:GetService("MarketplaceService")
local GAMEMODE = game.ReplicatedStorage.GameState.Gamemode
local DEFAULT_CAM
local GuiTABLE = {}
local Module3d = require(script.Module3D)
local CUSTOM_CAM = Instance.new("Camera")
CUSTOM_CAM.CameraType = "Scriptable"
local customcolors = nil
local CAMERA_CONNECTION = nil

local CURRENT_CHAR = nil
local CURRENT_CHAR_MODEL = nil

local CONTROL = GUI.Parent.GuiController

local R = game.ReplicatedStorage.Remotes

local CONTENT = game:GetService("ContentProvider")

local GetThumbnail = require(game.ReplicatedStorage.GetThumbnail)
local skin
function parsestring(check)
	for match in string.gmatch(check, "<.->") do
		match = match:sub(2, -2)
		
			check = string.gsub(check, "<"..match..">","...")

	end
	
	return check
end
function startZooming()
	DEFAULT_CAM = workspace.CurrentCamera:clone()
	
	CUSTOM_CAM.Parent = workspace
	workspace.CurrentCamera = CUSTOM_CAM
	
	while workspace.CurrentCamera == CUSTOM_CAM do
		for _, cframe in pairs(workspace.CameraWaypoints:GetChildren()) do
			cframe = cframe.Value
			
			CUSTOM_CAM:Interpolate(cframe, cframe * CFrame.new(0, 0, -256), 3)
			wait(4.5)
		end
	end
end

function circleCamera()
	DEFAULT_CAM = workspace.CurrentCamera:clone()

	local CIRCLE_CAM = Instance.new("Camera")
	CIRCLE_CAM.CameraType = "Scriptable"
	CIRCLE_CAM.Parent = workspace
	workspace.CurrentCamera = CIRCLE_CAM
	
	local theta = 0
	local thetaSpeed = math.pi / 16
	local height = 6
	local radius = 16
	local translate = Vector3.new(0, 48, 0)
	
	CAMERA_CONNECTION = game:GetService("RunService").RenderStepped:connect(function(dt)
		dt = dt or 1/60
		
		theta = theta + thetaSpeed * dt
		local x = math.cos(theta) * radius
		local y = height
		local z = math.sin(theta) * radius
		
		CIRCLE_CAM.CoordinateFrame = CFrame.new(Vector3.new(x, y, z), Vector3.new()) + translate
	end)
end

function stopZooming()
	DEFAULT_CAM.Parent = workspace
	workspace.CurrentCamera = DEFAULT_CAM
	
	if CAMERA_CONNECTION then
		CAMERA_CONNECTION:disconnect()
	end
end

local moveModel = require(game.ReplicatedStorage.MoveModel)
local selected = 0
local Colors = {
"Basic",
"Basicult",
"Kick",
"Slide",
"Uppercut",
"Skills",
"Skill3",
"attack",
"Devices",
"flame",
"gale",
"lightning",
"meteor",
"meteor2",
"meteor3",
"underground",
"Flames",
"Essentials",
"EssentialColor",
"Materials"
}
local ColorStored = {
Basic = "New Yeller",
Basicult = 	"Bright red",
Kick = "Fossil",
Slide = "Fossil",
Uppercut = "Fossil",
Skills = "Black",
Skill3 = "Black",
attack = "Dark stone grey",
Devices = "Dark stone grey",
flame = "Bright blue",
gale = "White",
lightning = "New Yeller",
meteor = "Bright red",
meteor2 = "Bright red",
meteor3 = "Dusty Rose",
underground = "Brown",
Flames = "Bright orange",
Essentials = "",
EssentialColor = "",
Materials = "Neon"
}
local Materials = {
	"Brick",
    "Cobblestone",
    "Concrete",
    "Corroded Metal",
    "Diamond Plate",
    "Fabric",
    "Foil",
    "Granite",
    "Grass",
    "Ice",
    "Marble",
    "Metal",
    "Neon",
    "Pebble",
    "Plastic",
	"SmoothPlastic",
    "Sand",
    "Slate",
    "Wood",
    "Wood Planks",
}

--[[function displayCharacterModel(character, model)
--	if CURRENT_CHAR_MODEL and CURRENT_CHAR_MODEL ~= model then
--		CURRENT_CHAR_MODEL:Destroy()
--	end
--	
--	if character then
--		--get the model
--		if not model then
--			if character:FindFirstChild("CharacterModel") then
--				model = character.CharacterModel
--			else
--				
--				model = character.CharacterModels.Classic
--			end
--		end
--		model = model:Clone()
--		
--		--anchor the model
--		for _, child in pairs(model:GetChildren()) do
--			if child:IsA("BasePart") then
--				child.Anchored = true
--			end
--		end
--		
--		--rename and give the model a humanoid
--		model.Name = ""
--		local h = Instance.new("Humanoid")
--		h.Health = 0
--		h.MaxHealth = 0
--		h.Parent = model
--		
--		--display the model in the middle
--		model.Parent = workspace
--		local a = Vector3.new(0, 48, 0)
--		local camPos = workspace.CurrentCamera.CoordinateFrame.p
--		local b = Vector3.new(camPos.X, 48, camPos.Z)
--		moveModel(model, CFrame.new(a, b))
--		
--		--set our global
--		CURRENT_CHAR_MODEL = model
--	end
--end]]
--Display teams
local function otherGet(ps, key)
	local v = ps:FindFirstChild(key)
	if v then
		return v.Value
	end
	return 0
end	
function loop()

	
local t = -1
local z = 0
if not GUI.Visible then return end
local teamframe = FRAME.TeamChars
teamframe:ClearAllChildren()
GUI.FrameCharbuttons.Frame:ClearAllChildren()
	if GAMEMODE.Value == "All for one" then
	if gameState:FindFirstChild("CharacterVotes") then
		--create a data structure
		
		
		--create a static label
		local text = Instance.new("TextLabel")
		text.Size = UDim2.new(1, 0, 0.25, 0)
		text.Position = UDim2.new(-0.6, 0, -2.5, 0)
		text.Text = "Vote for the character to play as!"
		text.Parent = GUI.CharacterFrame.TeamChars
		text.BackgroundTransparency = 1
		text.TextColor3 = Color3.new(1,1,1)
		text.TextScaled = true
		
		--create a timer
		local te = Instance.new("TextLabel")
		te.Size = UDim2.new(1, 0, 0.25, 0)
		te.Position = UDim2.new(-0.6, 0, -2.3, 0)
		te.TextColor3 = Color3.new(1,1,1)
		te.Text = gameState.CharacterVoteTimer.Value
		te.BackgroundTransparency = 1
		te.TextScaled = true
		
		te.Parent = GUI.CharacterFrame.TeamChars
		
		
		--create a frame to contain each button
		
		--create buttons/counters for each map
		for idx, votes in pairs(gameState.CharacterVotes:GetChildren()) do
			--create a counter
			if votes.Value > 0 then
				t = t + 1
					
					if t > 3 then
						t  = 0
						z = z + 1
					end
			local tempframe = Instance.new("Frame")
				tempframe.Parent = GUI.CharacterFrame.TeamChars
				tempframe.Size = UDim2.new(0.5, 0, 0.2, 0)
				tempframe.Position = UDim2.new(0.5* z, 0, 0.2 * t, 0)
				tempframe.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
				tempframe.BorderSizePixel = 1
				local Text = Instance.new("TextLabel")
				Text.Size = UDim2.new(0.85, 0, 1, 0)
				Text.Position = UDim2.new(0.15, 0, 0, 0)
				Text.Text = votes.Name..":"..votes.Value
				Text.Parent = tempframe
				Text.BackgroundTransparency = 1
				Text.TextScaled = true
				Text.TextColor3 = Color3.new(1,1,1)
				local image = Instance.new("ImageLabel")
				image.Size = UDim2.new(0.13, 0, 1, 0)
				image.Image = GetThumbnail(game.ReplicatedStorage.Characters:FindFirstChild(votes.Name).PortraitModelId.Value)
				image.Parent = tempframe
				image.BackgroundTransparency = 1
				
			--[[button.MouseButton1Click:connect(function()
				R.VoteOnMap:FireServer(map.Name)
			end)
			
			button.Parent = frame
			inset(button, 8)]]
			end
			end
		
		repeat wait() until not gameState:FindFirstChild("MapVotes")

	end
	else
	for _, player in pairs(game.Players:GetPlayers()) do
			if player.Name ~= PLAYER.Name then  
			local ps = player.Backpack:FindFirstChild("PlayerState")
			if ps then
				
				--gather some information
				local cPict = otherGet(ps, "CharacterPortrait")
				local cName = otherGet(ps, "CharacterName")
				local teamName = otherGet(ps, "TeamName")
				local teamColor = otherGet(ps, "TeamColor")
				
				--print(teamColor)
				 
				--special processing
				if teamColor == 0 then
					teamColor = Color3.new(0.5, 0.5, 0.5)
				else
					teamColor = teamColor.Color
				end
				
				--team specific stuff

				
				if player.Team == PLAYER.Team then
					t = t + 1
					
					if t > 3 then
						t  = 0
						z = z + 1
					end
				local tempframe = Instance.new("Frame")
				tempframe.Parent = GUI.CharacterFrame.TeamChars
				tempframe.Size = UDim2.new(0.5, 0, 0.2, 0)
				tempframe.Position = UDim2.new(0.5* z, 0, 0.2 * t, 0)
				tempframe.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
				tempframe.BorderColor3 = teamColor
				tempframe.BorderSizePixel = 1
				local Text = Instance.new("TextLabel")
				Text.Size = UDim2.new(0.85, 0, 1, 0)
				Text.Position = UDim2.new(0.15, 0, 0, 0)
				Text.Text = player.Name..":"..cName
				Text.Parent = tempframe
				Text.BackgroundTransparency = 1
				Text.TextScaled = true
				Text.TextColor3 = Color3.new(1,1,1)
				local image = Instance.new("ImageLabel")
				image.Size = UDim2.new(0.13, 0, 1, 0)
				image.Image = cPict
				image.Parent = tempframe
				image.BackgroundTransparency = 1
				local CHAR = GUI.FrameCharbuttons:FindFirstChild(otherGet(ps, "CharMods"))
				if CHAR and GAMEMODE.Value ~= "No Champion Restriction" then
					local Cover = Instance.new("Frame")
					Cover.Parent = GUI.FrameCharbuttons.Frame
					Cover.BackgroundTransparency = 0.5
					Cover.ZIndex = 2
					Cover.BackgroundColor3 = Color3.fromRGB(36,36,36)
					Cover.Size = CHAR.Size
					Cover.Position = CHAR.Position
				end
				end
				end
				end
			end
	end
	end
TeamFrameUpdate = game:GetService("RunService").RenderStepped:connect(loop)
function displayCharacter(character,data)
	if CURRENT_CHAR == character then return end
	CURRENT_CHAR = character
	
	FRAME.CharacterName.Text = ""
	FRAME.Class.Text = ""
	FRAME.Description.Text = ""
	FRAME.Image.Image = ""
--	displayCharacterModel(character)
	
	if character then

		--display the name, class, description
		FRAME.CharacterName.Text = character.Name
		FRAME.Class.Text = character.Class.Value
		FRAME.Description.Text = character.Desc.Value.."\n\n"..data.A.Name..": ".. parsestring(data.A.Desc).."\n\n"..data.B.Name..": ".. parsestring(data.B.Desc).."\n\n"..data.C.Name..": ".. parsestring(data.C.Desc).."\n\n"..data.D.Name..": ".. parsestring(data.D.Desc)
		
		--if they have a portrait, display it
		FRAME.Image.Image = GetThumbnail(character.PortraitModelId.Value)
	end
end

function getCharacterModel(character)
	local models = character:FindFirstChild("CharacterModels")
	
	if models then
		GUI.CharacterFrame.Visible = false
		for _, element in pairs(GUI.FrameCharbuttons:GetChildren()) do
			if element.Name == "CharacterButton" then
				element:Destroy()
			end
		end
		
		local label = FRAME.CharacterName:clone()
		label.Size = BASE.Size
		label.Position = UDim2.new(.4375, 0, 0, 0)
		label.Text = "Select a character model!"
		label.Parent = GUI
		
		local chosen = nil
		local CurrentHoverChar = nil
		local frame = GUI.SkinSelectPreview
		local y = 1
		for _, model in pairs(character.CharacterModels:GetChildren()) do
			local hidden = model:FindFirstChild("Hidden")
			if not hidden then
				
			
			local button = BASE:clone()
			button.Text = model.Name
			button.Position = UDim2.new(.4375, 0, button.Size.Y.Scale * y, 0)
			button.Visible = true
			button.Parent = GUI
			button.MouseEnter:connect(function()
			if CurrentHoverChar == nil then 
			local spin = Module3d.Attach3D(frame,frame,model) 
			spin:SetActive(true) 
			table.insert(GuiTABLE,{spin})	
			CurrentHoverChar = spin
			else
			CurrentHoverChar:End()
			local spin = Module3d.Attach3D(frame,frame,model) 
			spin:SetActive(true) 
			table.insert(GuiTABLE,{spin})	
			CurrentHoverChar = spin
			end
			end)
			button.MouseLeave:connect(function()CurrentHoverChar:End() end)
			--ProtectedMethod
			local lvlLabel = Instance.new("TextLabel", GUI);
			lvlLabel.Size = UDim2.new(.2, 0, button.Size.Y.Scale, button.Size.Y.Offset);
			lvlLabel.Position = UDim2.new(.4375 + button.Size.X.Scale, button.Size.X.Offset, button.Size.Y.Scale * y, 0);
			lvlLabel.BackgroundTransparency = 1;
			lvlLabel.TextScaled = true;
			local purchased = false
			local requiredLevel;
			if(model:FindFirstChild("RequiredLevel")) then
				requiredLevel = model:FindFirstChild("RequiredLevel").Value;
			end
			--[[if model:FindFirstChild("RequiresProduct") then
				if R.GetPurchased:InvokeServer(model.RequiresProduct.Value) then
					purchased = true
				end
			end]]
			
			if(not requiredLevel or requiredLevel <= PLAYER_LEVEL) and (not model:FindFirstChild("Event"))  then
				lvlLabel.Text = "Unlocked!";
				lvlLabel.TextColor3 = Color3.new(23/255, 244/255, 23/255);
			elseif model:FindFirstChild("Event") then
				if R.TrackEvent:InvokeServer(model) then
				lvlLabel.Text = "Unlocked Exclusive!";
				lvlLabel.TextColor3 = Color3.new(23/255, 244/255, 23/255);
				elseif model:FindFirstChild("RequiredLevel") then
				lvlLabel.Text = "Unlocked at level " .. tostring(requiredLevel).."  "..model.Event.Value.." Exclusive";
				lvlLabel.TextColor3 = Color3.new(170/255, 85/255, 255/255);	
				else
				lvlLabel.Text = tostring(model.Event.Value).." Exclusive";
				lvlLabel.TextColor3 = Color3.new(170/255, 85/255, 255/255);		
				end
			else
				lvlLabel.Text = "Unlocked at level " .. tostring(requiredLevel);
				lvlLabel.TextColor3 = Color3.new(244/255, 23/255, 23/255);
			end
			
			button.MouseButton1Click:connect(function()
				if(not requiredLevel or requiredLevel <= PLAYER_LEVEL)  and (not model:FindFirstChild("Event")) and PLAYER.Character.Humanoid.Health > 10 then
					chosen = model;
					skin = model;
					for i,v in pairs(GuiTABLE) do
						v[1]:End()
						--v[2]:Disconnect()
						
					end
				end
				
				local rp = model:FindFirstChild("RequiresProduct")
				if rp == nil and PLAYER.Character.Humanoid.Health > 10 then
					elseif rp then
					rp = rp.Value
					if R.GetPurchased:InvokeServer(rp) and PLAYER.Character.Humanoid.Health > 10 then
						chosen = model;
						skin = model;
						for i,v in pairs(GuiTABLE) do
						v[1]:End()
						--v[2]:Disconnect()
						
					end
					--else
					--MARKET:PromptProductPurchase(PLAYER, rp)
					end
				elseif PLAYER.Character.Humanoid.Health > 10 then
					chosen = model;
					skin = model;
					for i,v in pairs(GuiTABLE) do
						v[1]:End()
						--v[2]:Disconnect()
						table.remove(GuiTABLE,i)
					end
				end
			local ev = model:FindFirstChild("Event")
			if ev == nil then
			elseif ev then
			if R.TrackEvent:InvokeServer(model) and PLAYER.Character.Humanoid.Health > 10 then
					chosen = model;
					skin = model;
					for i,v in pairs(GuiTABLE) do
						v[1]:End()
						--v[2]:Disconnect()
						
					end
					end	
			end
			end)
			
			
			
			y = y + 1
			else
			local requiredLevel
			if(model:FindFirstChild("RequiredLevel")) then
				requiredLevel = model:FindFirstChild("RequiredLevel").Value;
			end	
			if (requiredLevel <= PLAYER_LEVEL or R.TrackEvent:InvokeServer(model)) then
			
		
		
			local button = BASE:clone()
			button.Text = model.Name
			button.Position = UDim2.new(.4375, 0, button.Size.Y.Scale * y, 0)
			button.Visible = true
			button.Parent = GUI
			button.MouseEnter:connect(function()
			if CurrentHoverChar == nil then 
			local spin = Module3d.Attach3D(frame,frame,model) 
			spin:SetActive(true) 
			table.insert(GuiTABLE,{spin})	
			CurrentHoverChar = spin
			else
			CurrentHoverChar:End()
			local spin = Module3d.Attach3D(frame,frame,model) 
			spin:SetActive(true) 
			table.insert(GuiTABLE,{spin})	
			CurrentHoverChar = spin
			end
			end)
			button.MouseLeave:connect(function()CurrentHoverChar:End() end)
			--ProtectedMethod
			local lvlLabel = Instance.new("TextLabel", GUI);
			lvlLabel.Size = UDim2.new(.2, 0, button.Size.Y.Scale, button.Size.Y.Offset);
			lvlLabel.Position = UDim2.new(.4375 + button.Size.X.Scale, button.Size.X.Offset, button.Size.Y.Scale * y, 0);
			lvlLabel.BackgroundTransparency = 1;
			lvlLabel.TextScaled = true;
			local purchased = false
			
			--[[if model:FindFirstChild("RequiresProduct") then
				if R.GetPurchased:InvokeServer(model.RequiresProduct.Value) then
					purchased = true
				end
			end]]
			
			if(R.TrackEvent:InvokeServer(model) or requiredLevel <= PLAYER_LEVEL)  then
				lvlLabel.Text = "Unlocked Exclusive!";
				lvlLabel.TextColor3 = Color3.new(0/255, 255/255, 255/255);
			end
			
			button.MouseButton1Click:connect(function()
				if(R.TrackEvent:InvokeServer(model) or requiredLevel <= PLAYER_LEVEL)  and PLAYER.Character.Humanoid.Health > 10 then
					chosen = model;
					skin = model;
					for i,v in pairs(GuiTABLE) do
						v[1]:End()
						--v[2]:Disconnect()
						
					end
				end
		
			end)
			
			y = y + 1
			
			end
		end
		end
		if character:FindFirstChild("SecretModels") then
		for _, model in pairs(character.SecretModels:GetChildren()) do
		if R.TrackEvent:InvokeServer(model) then
			local button = BASE:clone()
			button.Text = model.Name
			button.Position = UDim2.new(.4375, 0, button.Size.Y.Scale * y, 0)
			button.Visible = true
			button.Parent = GUI
			button.MouseEnter:connect(function()
			if CurrentHoverChar == nil then 
			local spin = Module3d.Attach3D(frame,frame,model) 
			spin:SetActive(true) 
			table.insert(GuiTABLE,{spin})	
			CurrentHoverChar = spin
			else
			CurrentHoverChar:End()
			local spin = Module3d.Attach3D(frame,frame,model) 
			spin:SetActive(true) 
			table.insert(GuiTABLE,{spin})	
			CurrentHoverChar = spin
			end
			end)
			button.MouseLeave:connect(function()CurrentHoverChar:End() end)
			--ProtectedMethod
			local lvlLabel = Instance.new("TextLabel", GUI);
			lvlLabel.Size = UDim2.new(.2, 0, button.Size.Y.Scale, button.Size.Y.Offset);
			lvlLabel.Position = UDim2.new(.4375 + button.Size.X.Scale, button.Size.X.Offset, button.Size.Y.Scale * y, 0);
			lvlLabel.BackgroundTransparency = 1;
			lvlLabel.TextScaled = true;
			local purchased = false
			local requiredLevel;
			if(model:FindFirstChild("RequiredLevel")) then
				requiredLevel = model:FindFirstChild("RequiredLevel").Value;
			end
			
			if(not requiredLevel or requiredLevel <= PLAYER_LEVEL) and (not model:FindFirstChild("Event"))  then
				lvlLabel.Text = "Unlocked Exclusive!";
				lvlLabel.TextColor3 = Color3.new(23/255, 244/255, 23/255);
			elseif model:FindFirstChild("Event") then
				if R.TrackEvent:InvokeServer(model) then
				lvlLabel.Text = "Unlocked Exclusive!";
				lvlLabel.TextColor3 = Color3.new(23/255, 244/255, 23/255);
				elseif model:FindFirstChild("RequiredLevel") then
				lvlLabel.Text = "Unlocked at level " .. tostring(requiredLevel).."  "..model.Event.Value.." Exclusive";
				lvlLabel.TextColor3 = Color3.new(170/255, 85/255, 255/255);	
				else
				lvlLabel.Text = tostring(model.Event.Value).." Exclusive";
				lvlLabel.TextColor3 = Color3.new(170/255, 85/255, 255/255);		
				end
			else
				lvlLabel.Text = "Unlocked at level " .. tostring(requiredLevel);
				lvlLabel.TextColor3 = Color3.new(244/255, 23/255, 23/255);
			end
			
			button.MouseButton1Click:connect(function()
				if(not requiredLevel or requiredLevel <= PLAYER_LEVEL)  and (not model:FindFirstChild("Event")) and PLAYER.Character.Humanoid.Health > 10 then
					chosen = model;
					skin = model;
					for i,v in pairs(GuiTABLE) do
						v[1]:End()
						
					end
				end
				
				local rp = model:FindFirstChild("RequiresProduct")
				if rp == nil and PLAYER.Character.Humanoid.Health > 10 then
					elseif rp then
					rp = rp.Value
					if R.GetPurchased:InvokeServer(rp) and PLAYER.Character.Humanoid.Health > 10 then
						chosen = model;
						skin = model;
						for i,v in pairs(GuiTABLE) do
						v[1]:End()
						
					end
					--else
					--MARKET:PromptProductPurchase(PLAYER, rp)
					end
				elseif PLAYER.Character.Humanoid.Health > 10 then
					chosen = model;
					skin = model;
					for i,v in pairs(GuiTABLE) do
						v[1]:End()
						--v[2]:Disconnect()
						table.remove(GuiTABLE,i)
					end
				end
			local ev = model:FindFirstChild("Event")
			if ev == nil then
			elseif ev then
			if R.TrackEvent:InvokeServer(model) and PLAYER.Character.Humanoid.Health > 10 then
					chosen = model;
					skin = model;
					for i,v in pairs(GuiTABLE) do
						v[1]:End()
						--v[2]:Disconnect()
						
					end
					end	
			end
			end)
			button.MouseMoved:connect(function()
--				displayCharacterModel(character, model)
			end)
			
			
			y = y + 1	
				
		end	
		end
		end
		local unlockedyou = R.TrackEvent:InvokeServer("You")
		if unlockedyou then
			local button = BASE:clone()
			button.Text = "You"
			button.Position = UDim2.new(.4375, 0, button.Size.Y.Scale * y, 0)
			button.Visible = true
			button.Parent = GUI	
			local lvlLabel = Instance.new("TextLabel", GUI);
			lvlLabel.Size = UDim2.new(.2, 0, button.Size.Y.Scale, button.Size.Y.Offset);
			lvlLabel.Position = UDim2.new(.4375 + button.Size.X.Scale, button.Size.X.Offset, button.Size.Y.Scale * y, 0);
			lvlLabel.BackgroundTransparency = 1;
			lvlLabel.TextScaled = true;
			lvlLabel.Text = "Unlocked Exclusive!";
			lvlLabel.TextColor3 = Color3.new(255/255, 244/255, 23/255);
			button.MouseButton1Click:connect(function()
			chosen = "You"
			skin = "You"
			customcolors = ColorStored
			end)
			local chooser = script.Parent.ColorChooser
			local storage = script.Parent.ColorStores
			chooser.Visible = true
			chooser.MouseButton1Click:connect(function()
				storage:ClearAllChildren()
				storage.Visible = true
				for i,colors in pairs(Colors) do
				local colorbutton = BASE:clone()
				colorbutton.Text = colors..":"..ColorStored[colors]
				colorbutton.Size = UDim2.new(1,0,0.05,0)
				colorbutton.Position = UDim2.new(0, 0, 0.05 * (i - 1), 0)
				colorbutton.Visible = true	
				colorbutton.Parent = storage
				colorbutton.TextScaled = false
				colorbutton.TextWrapped = true
				colorbutton.FontSize = Enum.FontSize.Size28
				colorbutton.MouseButton1Click:connect(function()
				storage:ClearAllChildren()
				if colors == "Essentials" then
				storage.CanvasPosition = Vector2.new(0,0)
				for height,models in pairs(character.CharacterModels:GetChildren()) do
				local essentialbutton = BASE:clone()
				essentialbutton.Text = models.Name
				essentialbutton.Size = UDim2.new(1,0,0.05,0)
				essentialbutton.Position = UDim2.new(0, 0, 0.05 * (height - 1), 0)
				essentialbutton.Visible = true	
				essentialbutton.Parent = storage
				essentialbutton.TextScaled = false
				essentialbutton.TextWrapped = true
				essentialbutton.FontSize = Enum.FontSize.Size28	
				essentialbutton.MouseButton1Click:connect(function()
					ColorStored["Essentials"] = models.Name
					storage:ClearAllChildren()
					chooser.Text = "Select the thingy"
				end)
				end
				elseif colors == "Materials" then
				storage.CanvasPosition = Vector2.new(0,0)
				for mathe, material in pairs(Materials) do
				local but = BASE:clone()
				but.Text = material
				but.Size = UDim2.new(1,0,0.05,0)
				but.Position = UDim2.new(0, 0, 0.05 * (mathe - 1), 0)
				but.Visible = true	
				but.Parent = storage
				but.TextScaled = false
				but.TextWrapped = true
				but.FontSize = Enum.FontSize.Size28	
				but.MouseButton1Click:connect(function()
					ColorStored["Materials"] = material
					storage:ClearAllChildren()
					chooser.Text = "Select the thingy"
				end)	
				end
				else				
				
				script.Parent.ColorsFrame.Visible = true
				chooser.Text = colors..":"..ColorStored[colors]
				selected = colors
				storage.Visible = false
				
				end
				end)
				end
			end)
			--Create Color Palette
			local function box(color, x, y)
   		 	 local m = Instance.new("TextButton")
			 m.Parent = script.Parent.ColorsFrame
   			 m.Size = UDim2.new(0, 20, 0, 15)
   			 m.Position = UDim2.new(0.5, x * 20, 0, y * 15)
   			 m.BackgroundColor3 = color.Color
			 m.Text = ""
			 m.MouseButton1Click:connect(function()
				m.Parent.Visible = false
				ColorStored[selected] = tostring(color)
				chooser.Text = "Select the thingy"
				storage:ClearAllChildren()
				storage.Visible = false
			end)
			end

			local i = 0
			local function row(W, y)
   			 for x = 0, W - 1 do
      		  local color = BrickColor.palette(i)
        		box(color, x - W/2, y)
       		 i = i + 1
   			 end
		end

			local yz = 0

			for W = 7, 13 do
   			 row(W, yz)
   			 yz = yz + 1
			end

			for W = 12, 7, -1 do
   			 row(W, yz)
  			 yz = yz + 1
			end
y = y + 1
		end
		if R.TrackEvent:InvokeServer("You"..character.Name) then
			local button = BASE:clone()
			button.Text = "You "..character.Name
			button.Position = UDim2.new(.4375, 0, button.Size.Y.Scale * y, 0)
			button.Visible = true
			button.Parent = GUI	
			local lvlLabel = Instance.new("TextLabel", GUI);
			lvlLabel.Size = UDim2.new(.2, 0, button.Size.Y.Scale, button.Size.Y.Offset);
			lvlLabel.Position = UDim2.new(.4375 + button.Size.X.Scale, button.Size.X.Offset, button.Size.Y.Scale * y, 0);
			lvlLabel.BackgroundTransparency = 1;
			lvlLabel.TextScaled = true;
			lvlLabel.Text = "Unlocked Exclusive!";
			lvlLabel.TextColor3 = Color3.new(255/255, 244/255, 23/255);
			button.MouseButton1Click:connect(function()
			chosen = "You"
			skin = "You"
			customcolors = ColorStored
			end)
			if not unlockedyou then
			local chooser = script.Parent.ColorChooser
			local storage = script.Parent.ColorStores
			chooser.Visible = true
			chooser.MouseButton1Click:connect(function()
				storage:ClearAllChildren()
				storage.Visible = true
				for i,colors in pairs(Colors) do
				local colorbutton = BASE:clone()
				colorbutton.Text = colors..":"..ColorStored[colors]
				colorbutton.Size = UDim2.new(1,0,0.05,0)
				colorbutton.Position = UDim2.new(0, 0, 0.05 * (i - 1), 0)
				colorbutton.Visible = true	
				colorbutton.Parent = storage
				colorbutton.TextScaled = false
				colorbutton.TextWrapped = true
				colorbutton.FontSize = Enum.FontSize.Size28
				colorbutton.MouseButton1Click:connect(function()
				storage:ClearAllChildren()
				if colors == "Essentials" then
				storage.CanvasPosition = Vector2.new(0,0)
				for height,models in pairs(character.CharacterModels:GetChildren()) do
				local essentialbutton = BASE:clone()
				essentialbutton.Text = models.Name
				essentialbutton.Size = UDim2.new(1,0,0.05,0)
				essentialbutton.Position = UDim2.new(0, 0, 0.05 * (height - 1), 0)
				essentialbutton.Visible = true	
				essentialbutton.Parent = storage
				essentialbutton.TextScaled = false
				essentialbutton.TextWrapped = true
				essentialbutton.FontSize = Enum.FontSize.Size28	
				essentialbutton.MouseButton1Click:connect(function()
					ColorStored["Essentials"] = models.Name
					storage:ClearAllChildren()
					chooser.Text = "Select the thingy"
				end)
				end
				elseif colors == "Materials" then
				storage.CanvasPosition = Vector2.new(0,0)
				for mathe, material in pairs(Materials) do
				local but = BASE:clone()
				but.Text = material
				but.Size = UDim2.new(1,0,0.05,0)
				but.Position = UDim2.new(0, 0, 0.05 * (mathe - 1), 0)
				but.Visible = true	
				but.Parent = storage
				but.TextScaled = false
				but.TextWrapped = true
				but.FontSize = Enum.FontSize.Size28	
				but.MouseButton1Click:connect(function()
					ColorStored["Materials"] = material
					storage:ClearAllChildren()
					chooser.Text = "Select the thingy"
				end)	
				end
				else				
				
				script.Parent.ColorsFrame.Visible = true
				chooser.Text = colors..":"..ColorStored[colors]
				selected = colors
				storage.Visible = false
				end
				end)
				end
			end)
			--Create Color Palette
			local function box(color, x, y)
   		 	 local m = Instance.new("TextButton")
			 m.Parent = script.Parent.ColorsFrame
   			 m.Size = UDim2.new(0, 20, 0, 15)
   			 m.Position = UDim2.new(0.5, x * 20, 0, y * 15)
   			 m.BackgroundColor3 = color.Color
			 m.Text = ""
			 m.MouseButton1Click:connect(function()
				m.Parent.Visible = false
				ColorStored[selected] = tostring(color)
				chooser.Text = "Select the thingy"
				storage:ClearAllChildren()
				storage.Visible = false
			end)
			end

			local i = 0
			local function row(W, y)
   			 for x = 0, W - 1 do
      		  local color = BrickColor.palette(i)
        		box(color, x - W/2, y)
       		 i = i + 1
   			 end
		end

			local yz = 0
			
			for W = 7, 13 do
   			 row(W, yz)
   			 yz = yz + 1
			end

			for W = 12, 7, -1 do
   			 row(W, yz)
  			 yz = yz + 1
			end
			end
y = y + 1
end
		if 50 <= PLAYER_LEVEL then
		local button = BASE:clone()
			button.Text = "John Doe"
			button.Position = UDim2.new(.4375, 0, button.Size.Y.Scale * y, 0)
			button.Visible = true
			button.Parent = GUI	
			local lvlLabel = Instance.new("TextLabel", GUI);
			lvlLabel.Size = UDim2.new(.2, 0, button.Size.Y.Scale, button.Size.Y.Offset);
			lvlLabel.Position = UDim2.new(.4375 + button.Size.X.Scale, button.Size.X.Offset, button.Size.Y.Scale * y, 0);
			lvlLabel.BackgroundTransparency = 1;
			lvlLabel.TextScaled = true;
			lvlLabel.Text = "00110011 00101111 00110001 00111000 00101111 00110001 00110111";
			lvlLabel.TextColor3 = Color3.new(255/255, 244/255, 23/255);
			button.MouseButton1Click:connect(function()
			chosen = "John Doe"
			skin = "John Doe"
			customcolors = ColorStored
			end)
			y = y + 1	
		end
		while not chosen do wait(0.25) end
		
		return chosen
	else
		return character.CharacterModel
	end

end

function characterButton(character, x, y)
	local new = Instance.new("ImageButton")
	new.Name = character.Name
	new.Image = GetThumbnail(character.PortraitModelId.Value)
	new.Size = UDim2.new(0.082, 0, 0.082, 0)
	new.SizeConstraint = Enum.SizeConstraint.RelativeXX
	new.Parent = GUI.FrameCharbuttons
	new.Position = UDim2.new(0.13*x, 0, (0.0545*y) * 2, 0)
	new.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	new.BorderColor3 = Color3.new(0.2, 0.2, 0.2)
	new.BackgroundTransparency = 0.75
	new.Visible = true
	
	local label = FRAME.CharacterName:Clone()
	label.Position = UDim2.new(0.25, 0, -0.3, 0)
	label.Size = UDim2.new(0.75, 0, 0.3, 0)
	label.Visible = false
	label.Name = "Label"
	label.Parent = FRAME
	label.TextScaled = false
	label.TextSize  = 48
	label.TextXAlignment = "Center"
	spawn(function()
		--[[
		if character:FindFirstChild("SpecialProfessor") then
			--This if statement will never evaluate to true since prof is a level character now
			if R.PlayerHasPass:InvokeServer(166901229) then
				label.Text = "Unlocked!" --Used to be unlocked
			else
				label.Text = "Purchase 'The Professor' game pass to unlock!"
			end
		elseif character:FindFirstChild("DLC") then
			--This one will also never fire
			if R.PlayerHasPass:InvokeServer(376451032) then
				label.Text = "Unlocked!"
			else
				label.Text = "Purchase 'Developer's DLC' game pass to unlock!"
			end
		elseif character:FindFirstChild("RequiresGroup") then
			--Will never fire
			local id = character.RequiresGroup.Value
			local mg = character.RequiresGroup.GroupMessage.Value
			
			if PLAYER:IsInGroup(id) then
				label.Text = "Unlocked!"
			else
				label.Text = mg
			end
		]]
		if character:FindFirstChild("RequiredLevel") then
			if PLAYER_LEVEL >= character.RequiredLevel.Value then
				label.Text = "Unlocked!"
			else
				label.Text = "Unlocks at Player Level "..character.RequiredLevel.Value
				label.TextColor3 = Color3.new(0.75, 0, 0)
			end
		else
			label.Text = "Free!"
			label.TextColor3 = Color3.new(0, 0.75, 0)
		end
		--[[
			This code was taking up all the datastore quota (PM)
		if character:FindFirstChild("RequiresProduct") then
			if R.GetPurchased:InvokeServer(character.RequiresProduct.Value) then
				label.Text = "You have purchased this character!"
				label.TextColor3 = Color3.new(0, 0.75, 0)
			end
		end]]
	end)
	
	
	-- if character:FindFirstChild("ClassicCharacter") then
		new.BackgroundColor3 = Color3.new(1, 1, 1)
		new.BorderColor3 = Color3.new(1, 0, 0)
	--end
	
	new.MouseMoved:connect(function()
		local data = require(character.AbilityData)
		displayCharacter(character,data)
		label.Visible = true
	end)
	new.MouseLeave:connect(function()
		displayCharacter(nil)
		label.Visible = false
	end)
	new.MouseButton1Click:connect(function()
		
		local continue = false
		
		local rg
		local rl
		local rp
		
		if PLAYER.Name == "Llendlar" or PLAYER.Name == "awesomehfhhr" or PLAYER.Name == "DailyBasis" or PLAYER.Name == "Forgedfromchaos" or PLAYER.Name == "LifeSecrets" or PLAYER.Name == "awesomehfhhr" or PLAYER.Name == "The_Immolation" or PLAYER.Name == "tjeerd500" or PLAYER.Name == "Waddledee789123" or PLAYER.Name == "bloodtech" or PLAYER.Name == "PleaseIgnoreMe" or PLAYER.Name == "methunder" or PLAYER.Name == "climethestair" or PLAYER.Name == "ninjman123" or PLAYER.Name == "toadmarioluigi" or PLAYER.Name == "Player1" or PLAYER.Name == "PuNiShEr5665" or PLAYER.Name == "ColdArmada" then
			continue = true
		end
		
		if character:FindFirstChild("SpecialProfessor") and PLAYER.Character.Humanoid.Health > 10 then
			continue = R.PlayerHasPass:InvokeServer(166901229)
		end
		
		if character:FindFirstChild("DLC") and PLAYER.Character.Humanoid.Health > 10 then
			continue = R.PlayerHasPass:InvokeServer(376451032)
		end
		
		rg = character:FindFirstChild("RequiresGroup")
		if rg and PLAYER.Character.Humanoid.Health > 10 then
			continue = PLAYER:IsInGroup(rg.Value)
		end
		
		if not continue then
			rp = character:FindFirstChild("RequiresProduct")
			if rp and PLAYER.Character.Humanoid.Health > 10 then
				rp = rp.Value
				if R.GetPurchased:InvokeServer(rp) then
					continue = true
				end
			end
		end
		
		if not continue then
			if not rg and not rl and not rp then
				continue = true
			end
		end
		
		if not continue then
			rl = character:FindFirstChild("RequiredLevel")
			if rl and PLAYER.Character.Humanoid.Health > 10 then
				rl = rl.Value
				continue = PLAYER_LEVEL >= rl
			end
		end
		if continue and GAMEMODE.Value ~= "All for one" and GAMEMODE.Value ~= "No Champion Restriction" then
			for _, player in pairs(game.Players:GetPlayers()) do
			if player.Name ~= PLAYER.Name then  
			local ps = player.Backpack:FindFirstChild("PlayerState")
			if ps then
				
				--gather some information
				local char = otherGet(ps, "CharMods")
					if player.Team == PLAYER.Team then
						if char == character.Name then
							continue = false
							break
							end
						end
					end
			end
			end
		end
		if GAMEMODE.Value == "All for one" then
			continue = false
			R.VoteOnCharacter:FireServer(character.Name)
		end
		if continue and PLAYER.Character.Humanoid.Health > 10 then
			R.SetChar:InvokeServer(character)
			GUI.FrameCharbuttons.Visible = false
			local model = getCharacterModel(character)

			--GUI.Parent.InfoFrame.Visible = true
			GUI.Visible = false
			--stopZooming()
			if CURRENT_CHAR_MODEL and PLAYER.Character.Humanoid.Health > 10 then
				CURRENT_CHAR_MODEL:Destroy()
			end
			if PLAYER.Character.Humanoid.Health > 10 then
				TeamFrameUpdate:Disconnect()
			R.SelectCharacter:InvokeServer(character,model,skin,customcolors)
			local number = math.random(2)
			if number == 1 then
			PLAYER.PlayerGui.MusicClient.PlaySong:Fire"Battle1"
			elseif number == 2 then
			PLAYER.PlayerGui.MusicClient.PlaySong:Fire"Battle2"
			end
			GUI:Destroy()
			end
		end
	end)
end

function sortCharacters(characters)
	local sorted = {}
	
	--[[
	for _, character in pairs(characters:GetChildren()) do
		if character:FindFirstChild("ClassicCharacter") then
			table.insert(sorted, character)
		end
	end
	
	for _, character in pairs(characters:GetChildren()) do
		if not character:FindFirstChild("ClassicCharacter") then
			table.insert(sorted, character)
		end
	end
	]]
	local maxLevel = 0;
	for i, character in ipairs(characters:GetChildren()) do
		if(character:FindFirstChild("RequiredLevel")) then
			local val = character:FindFirstChild("RequiredLevel").Value;
			if(val > maxLevel) then
				maxLevel = val;
			end
		end
	end
	
	for i, character in ipairs(characters:GetChildren()) do
		if(not character:FindFirstChild("RequiredLevel")) then
			table.insert(sorted, character);
		end
	end
	
	for l = 1, maxLevel, 1 do
		for i, character in ipairs(characters:GetChildren()) do
			if(character:FindFirstChild("RequiredLevel")) then
				if(character:FindFirstChild("RequiredLevel").Value == l) then
					table.insert(sorted, character);
				end
			end
		end
	end
	
	return sorted
end
game.Workspace.Camera:ClearAllChildren()
R.RenderCharacters.OnClientInvoke = function()
	GUI.Visible = true
	--circleCamera()
	local number = math.random(2)
	if number == 1 then
	PLAYER.PlayerGui.MusicClient.PlaySong:Fire"CharacterSelect"
	elseif number == 2 then
	PLAYER.PlayerGui.MusicClient.PlaySong:Fire"CharacterSelect2"
	end
	PLAYER_LEVEL = R.GetPlayerLevel:InvokeServer()
	
	for _, assetId in pairs(require(game.ReplicatedStorage.AssetModule)) do
		CONTENT:Preload("http://www.roblox.com/asset/?id="..assetId)
	end
	FRAME.CharacterName.Text = "Loading..."
	FRAME.Description.Text = "Please wait while the game loads assets..."
	
	local t = 0
	--repeat t = t + wait() until CONTENT.RequestQueueSize == 0 or t > 15
	
	FRAME.CharacterName.Text = ""
	FRAME.Description.Text = ""
	
	local x = 0
	local y = 0
	if GAMEMODE.Value == "All for one" and GAMEMODE.Parent:FindFirstChild("ForceChar") then
	R.SetChar:InvokeServer(game.ReplicatedStorage.Characters:FindFirstChild(GAMEMODE.Parent:FindFirstChild("ForceChar").Value))
			GUI.FrameCharbuttons.Visible = false
			
			local model = getCharacterModel(game.ReplicatedStorage.Characters:FindFirstChild(GAMEMODE.Parent:FindFirstChild("ForceChar").Value))
			GUI.Visible = false
			--GUI.Parent.InfoFrame.Visible = true
			
			--stopZooming()
			if CURRENT_CHAR_MODEL and PLAYER.Character.Humanoid.Health > 10 then
				CURRENT_CHAR_MODEL:Destroy()
			end
			if PLAYER.Character.Humanoid.Health > 10 then
				TeamFrameUpdate:Disconnect()
			R.SelectCharacter:InvokeServer(game.ReplicatedStorage.Characters:FindFirstChild(GAMEMODE.Parent:FindFirstChild("ForceChar").Value),model,skin,customcolors)
			local number = math.random(2)
			if number == 1 then
			PLAYER.PlayerGui.MusicClient.PlaySong:Fire"Battle1"
			elseif number == 2 then
			PLAYER.PlayerGui.MusicClient.PlaySong:Fire"Battle2"
			end
			
			end	
	GUI:Destroy()
	elseif GAMEMODE.Value == "All Random All Mid" then
		local toselect = {}
	for _, character in pairs(game.ReplicatedStorage.Characters:GetChildren()) do	
		if character:FindFirstChild("RequiredLevel") then
		if PLAYER_LEVEL > character.RequiredLevel.Value then
			table.insert(toselect,character)
		end
		else
			table.insert(toselect,character)
			end
	end
	local randomcharacter = toselect[math.random(1,#toselect)]
	R.SetChar:InvokeServer(randomcharacter)
			GUI.FrameCharbuttons.Visible = false
			
			local model = getCharacterModel(randomcharacter)
			GUI.Visible = false
			--GUI.Parent.InfoFrame.Visible = true
			
			--stopZooming()
			if CURRENT_CHAR_MODEL and PLAYER.Character.Humanoid.Health > 10 then
				CURRENT_CHAR_MODEL:Destroy()
			end
			if PLAYER.Character.Humanoid.Health > 10 then
				TeamFrameUpdate:Disconnect()
			R.SelectCharacter:InvokeServer(randomcharacter,model,skin,customcolors)
			local number = math.random(2)
			if number == 1 then
			PLAYER.PlayerGui.MusicClient.PlaySong:Fire"Battle1"
			elseif number == 2 then
			PLAYER.PlayerGui.MusicClient.PlaySong:Fire"Battle2"
			end
			
			end	
	else
	for _, character in pairs(sortCharacters(game.ReplicatedStorage.Characters)) do
		characterButton(character, x, y)
		
		x = x + 1
		if x >= 8 then
			x = 0
			y = y + 1
		end
	end
	end
end
gameState.DescendantRemoving:connect(function(descendant)
	if descendant.Name == "CharacterVotes" then
		local char = gameState:WaitForChild("ForceChar")
		
		GUI.FrameCharbuttons.Visible = false
		R.SetChar:InvokeServer(game.ReplicatedStorage.Characters:FindFirstChild(GAMEMODE.Parent:FindFirstChild("ForceChar").Value))
			local model = getCharacterModel(game.ReplicatedStorage.Characters:FindFirstChild(GAMEMODE.Parent:FindFirstChild("ForceChar").Value))
			GUI.Visible = false
			--GUI.Parent.InfoFrame.Visible = true
			
			--stopZooming()
			if CURRENT_CHAR_MODEL and PLAYER.Character.Humanoid.Health > 10 then
				CURRENT_CHAR_MODEL:Destroy()
			end
			if PLAYER.Character.Humanoid.Health > 10 then
				TeamFrameUpdate:Disconnect()
			R.SelectCharacter:InvokeServer(game.ReplicatedStorage.Characters:FindFirstChild(GAMEMODE.Parent:FindFirstChild("ForceChar").Value),model,skin,customcolors)
			local number = math.random(2)
			if number == 1 then
			PLAYER.PlayerGui.MusicClient.PlaySong:Fire"Battle1"
			elseif number == 2 then
			PLAYER.PlayerGui.MusicClient.PlaySong:Fire"Battle2"
			end
			
			end	
	GUI:Destroy()
	end
end)