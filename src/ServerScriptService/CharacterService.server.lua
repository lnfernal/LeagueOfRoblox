function weld(x, y)
	if x == y then return end
	local CJ = CFrame.new(x.Position)
	local w = Instance.new("Weld")
	w.Name = "Weld"
	w.Part0 = x
	w.Part1 = y
	w.C0 = x.CFrame:inverse() * CJ
	w.C1 = y.CFrame:inverse() * CJ
	w.Parent = x
	return w
end

function motor(x, y)
	if x == y then return end
	local CJ = CFrame.new(x.Position)
	local w = Instance.new("Motor6D")
	w.Name = "Weld"
	w.Part0 = x
	w.Part1 = y
	w.C0 = x.CFrame:inverse() * CJ
	w.C1 = y.CFrame:inverse() * CJ
	w.Parent = x
	return w
end

function makeMotor(part, base, c0, c1)
	--print("MOTOR",part,"TO",base,"AT\n",c0,"AND\n",c1)
	local motor = Instance.new("Motor6D")
	motor.Part0 = base
	motor.Part1 = part
	motor.C0 = c0
	motor.C1 = c1
	motor.Parent = base
	return motor
end

function copyPropertiesAndChildren(part, temp)
	--first, properties
	if  not temp:IsA("Motor") then
	local properties = {
		"Transparency",
		"BrickColor",
		"Material",
	}
	for _, property in pairs(properties) do
		part[property] = temp[property]
	end
	
	--next, children
	for _, child in pairs(temp:GetChildren()) do
		if  not child:IsA("Motor") then
		
		child:clone().Parent = part
		
		end
	end
	end
end


local Attachments = {
	{"LeftShoulderAttachment","Left Arm"},
	{"RightShoulderAttachment","Right Arm"},
	{"FaceCenterAttachment","Head"},
	{"FaceFrontAttachment","Head"},
	{"HairAttachment","Head"},
	{"HatAttachment","Head"},
	{"BodyBackAttachment","Torso"},
	{"BodyFrontAttachment","Torso"},
	{"LeftCollarAttachment","Torso"},
	{"RightCollarAttachment","Torso"},
	{"NeckAttachment","Torso"},
	{"WaistBackAttachment","Torso"},
	{"WaistCenterAttachment","Torso"},
	{"WaistFrontAttachment","Torso"},
	}

function weldAttachments(attach1, attach2)
	local weld = Instance.new("Weld")
	weld.Part0 = attach1.Parent
	weld.Part1 = attach2.Parent
	weld.C0 = attach1.CFrame
	weld.C1 = attach2.CFrame
	weld.Parent = attach1.Parent
	return weld
end

function GetEssentials(Classic,Player,Desired)
	local essentialtable = {}
	local function recurse(model)
		for _,children in pairs(model:GetChildren()) do
			if children:FindFirstChild("Essentials") or children:FindFirstChild("MotorTo") or children:FindFirstChildOfClass("Script") or children:FindFirstChild("MakeMotor") then
			table.insert(essentialtable,children)
			else
			recurse(children)
			end
		end
	end
	recurse(Classic)
	for _, object in pairs(essentialtable) do
		if object:IsA("BasePart") then
			for _, obj in pairs(object:GetChildren()) do
				if obj.Name == "WeldTo" then
					local y = Classic:FindFirstChild(obj.Value)
					if y then
						weld(object, y)
					end
				end
				
				if obj.Name == "MotorTo" then
					local y = Classic:FindFirstChild(obj.Value)
					if y then
						motor(object, y)
					end
				end
			
			end
		end
	end
	
	--now do the copying
	local id = 1
	local origNames = {}
	for _, object in pairs(essentialtable) do
		
		
			local new = object:clone()
			origNames[id] = new.Name
			--new.Name = id
			new.Parent = Desired
			if object:IsA("BasePart") then
			local physicalProp = PhysicalProperties.new(0.01,0.3,0,1,0)
			new.CustomPhysicalProperties = physicalProp	
			if new:FindFirstChild("Essentials") then
				
				if new:FindFirstChild("Color") then
					
					if Desired.Torso.EssentialColor.Value ~= "" then
					new.BrickColor = BrickColor.new(Desired.Torso.EssentialColor.Value)
					
					end
				end
			end
			end
			if object:FindFirstChild("Weld") then
				local warning = Instance.new("ObjectValue")
				warning.Name = "NeedsWelding"
				warning.Value = new
				warning.Parent = object
				new:FindFirstChild("Weld"):Destroy()
				if new:FindFirstChild("WeldTo") then
				new:FindFirstChild("WeldTo"):Destroy()	
				end
			end
			if new:FindFirstChildOfClass("Motor6D") then
				for i,v in pairs(new:GetChildren()) do
				if v:IsA("Motor6D") or v.Name == "MotorTo" then
					v:Destroy()
				end
				end
			
		
		
		id = id + 1
	end
end
	--return names to normal
	--[[for id, origName in pairs(origNames) do
		Desired[id].Name = origName
	end]]
	
	--motoring?
	for _, object in pairs(Desired:GetChildren()) do
		if object:IsA("Script") and object.Name == ("AbilityScript") then
			Desired:FindFirstChild(object.Name):Destroy()	
		end
		if object:IsA("Model") and object.Name == ("CharacterData") then
			Desired:FindFirstChild(object.Name):Destroy()	
			end
		if object:FindFirstChild("MakeMotor") then
			local obj = object.MakeMotor
			local part = Desired:FindFirstChild(obj.Value)
			if part then
				makeMotor(part, object, obj.C0.Value, obj.C1.Value)
			end
		end
	end
	local ta = {}
	local function contains(t, v)
	for _, val in pairs(t) do
		if val == v then
			return true
		end
	end
	return false
end
	--weld dat
	for _, object in pairs(essentialtable) do
		if object:FindFirstChild("NeedsWelding") then
			local new = object.NeedsWelding.Value
			
			for _, obj in pairs(object:GetChildren()) do
				if obj.Name == "Weld" and contains(ta,{new,obj.Part1.Name}) == false and obj.Part1.Name  then
					local part1Name = obj.Part1.Name
					local newWeld = obj:clone()
					newWeld.Part0 = new
					newWeld.Part1 = Desired[part1Name]
					newWeld.Parent = new
					--print(newWeld)
					table.insert(ta,{new,part1Name})
				end
			end
		end
	end

end

function ConstructMe(player,desired)
local character = game.ReplicatedStorage.Characters:FindFirstChild(player.Backpack.PlayerState.CharMods.Value)
local essential
local tocopy = desired.Torso.Essentials.Value
if character.CharacterModels:FindFirstChild(tocopy) then
	essential = character.CharacterModels:FindFirstChild(tocopy):Clone()
elseif character.CharacterModels:FindFirstChild("Classic") then
	essential = character.CharacterModels:FindFirstChild("Classic"):Clone()
elseif character.CharacterModels:FindFirstChild("Original") then
	essential = character.CharacterModels:FindFirstChild("Original"):Clone()
elseif character.CharacterModels:FindFirstChild("The Original") then
	essential = character.CharacterModels:FindFirstChild("The Original"):Clone()
end
GetEssentials(essential,player,desired)
local HTTP = game:GetService("HttpService")
local URLS = {}
local id = player.userId
local numberdetector = "%d+"
local stringcount = 0
local assets = HTTP:GetAsync("http://rprxy.xyz/Asset/AvatarAccoutrements.ashx?userId="..id)
for String in string.gmatch(assets, ".-;") do
stringcount = stringcount +	string.len(String)
local assetid = String:match(numberdetector)
if tonumber(assetid) ~= id then
URLS[#URLS + 1] = assetid
end
end
URLS[#URLS + 1] = string.sub(assets, stringcount):match(numberdetector)  


local bodycolors = HTTP:GetAsync("http://rprxy.xyz/Asset/BodyColors.ashx?userId="..id)

local order = {"HeadColor","LeftArmColor","LeftLegColor","RightArmColor","RightLegColor","TorsoColor"} --Just something to know
local colors = {}
for match in string.gmatch(bodycolors, "<int name=.->.-</.->") do	
	match = match:match(numberdetector)
	colors[#colors + 1] = match
end

for i,v in pairs(colors) do
	if desired:FindFirstChild("Body Colors") then
	desired["Body Colors"][order[i]] = BrickColor.new(v)
	else
	local body = Instance.new("BodyColors")
	body.Parent = desired
	body[order[i]] = BrickColor.new(v)
	end
end
for i,v in pairs(URLS) do
	local model = game:GetService("InsertService"):LoadAsset(v)
            for _, child in pairs(model:GetChildren()) do
			if child:IsA("Decal") or child:IsA("SpecialMesh") then
			if child:IsA("SpecialMesh") then
			desired.Head.Mesh:Destroy()		
			else
			desired.Head.face:Destroy()	
			end
			child.Parent = desired.Head
			elseif child:IsA("Folder") then
				if child.Name == "R6" then
					for i,v in pairs(child:GetChildren()) do
						v.Parent = desired
					end
				end
			elseif not child:IsA("Tool") then
            child.Parent = desired
			for _,attachments in pairs(Attachments) do
				if child:FindFirstChild("Handle") then
				local part = child.Handle
				if part:FindFirstChild(attachments[1]) then
					part.Parent = desired
					part.Name = child.Name
					weldAttachments(part[attachments[1]],desired:FindFirstChild(attachments[2])[attachments[1]])
					child:Destroy()
					part.CanCollide = false
					break
				end
				end
			end
			end
            end
end
if desired:FindFirstChild("Humanoid") then
	desired.Humanoid:Destroy()
end
return desired
end

function ConstructDoe(player,desired)
local character = game.ReplicatedStorage.Characters:FindFirstChild(player.Backpack.PlayerState.CharMods.Value)
local essential
local tocopy = desired.Torso.Essentials.Value
if character.CharacterModels:FindFirstChild(tocopy) then
	essential = character.CharacterModels:FindFirstChild(tocopy):Clone()
elseif character.CharacterModels:FindFirstChild("Classic") then
	essential = character.CharacterModels:FindFirstChild("Classic"):Clone()
elseif character.CharacterModels:FindFirstChild("Original") then
	essential = character.CharacterModels:FindFirstChild("Original"):Clone()
elseif character.CharacterModels:FindFirstChild("The Original") then
	essential = character.CharacterModels:FindFirstChild("The Original"):Clone()
end
GetEssentials(essential,player,desired)
return desired
end

function changeCharacter(current, desired,checker,plr)
	if checker then
		for i,v in pairs(current:GetChildren()) do
			if v:IsA("BasePart") then
			if v.Name == "Torso" or v.Name == "Left Arm" or v.Name == "Right Arm" or v.Name == "Left Leg" or v.Name == "Right Leg" or v.Name == "Head" or v.Name:match("Horse") == "Horse" or v.Name:match("Bear") == "Bear"  then
			else 
			v.Transparency = 1
			end
			end
		end
	end
	
	desired = desired:clone()
	if desired.Name == "You" then
	desired = ConstructMe(plr,desired)
	elseif desired.Name =="John Doe" then
		desired = ConstructDoe(plr,desired)
	end
	--this helps, trust you
	for _,parts in pairs(current.Head:GetChildren()) do
		if parts:IsA("SpecialMesh") or parts:IsA("Decal") or parts:IsA("BlockMesh") or parts:IsA("CylinderMesh") or parts:IsA("FileMesh") or parts:IsA("BillboardGui") then
			parts:Destroy()
		end
	end
	
	--first we must weld the desired so we can copy welds
	for _, object in pairs(desired:GetChildren()) do
		if object:IsA("BasePart") then
			for _, obj in pairs(object:GetChildren()) do
				if obj.Name == "WeldTo" then
					local y = desired:FindFirstChild(obj.Value)
					if y then
						weld(object, y)
					end
				end
				
				if obj.Name == "MotorTo" then
					local y = desired:FindFirstChild(obj.Value)
					if y then
						motor(object, y)
					end
				end
			
			end
		end
	end
	
	--now do the copying
	local id = 1
	local origNames = {}
	for _, object in pairs(desired:GetChildren()) do
		if current:FindFirstChild(object.Name) and object.Name == "Torso" or object.Name == "Left Arm" or object.Name == "Right Arm" or object.Name == "Left Leg" or object.Name == "Right Leg" or object.Name == "Head" or object.Name == "HumanoidRootPart"  then
			
			if object:IsA("BasePart") then
			copyPropertiesAndChildren(current[object.Name], object)
			if current[object.Name].CustomPhysicalProperties then
			local oldProp = current[object.Name].CustomPhysicalProperties			
			local physicalProp = PhysicalProperties.new(oldProp.Density, oldProp.Friction,0,oldProp.FrictionWeight,0)
			current[object.Name].CustomPhysicalProperties = physicalProp
		else
		local physicalProp = PhysicalProperties.new(0.7,0.3,0,1, 0)
		current[object.Name].CustomPhysicalProperties = physicalProp
	end
				if object:FindFirstChild("Weld") then
					local warning = Instance.new("ObjectValue")
					warning.Name = "NeedsWelding"
					warning.Value = current[object.Name]
					warning.Parent = object
				end
			
		end
			
		else
			local new = object:clone()
			origNames[id] = new.Name
			new.Name = id
			new.Parent = current
			if object:IsA("BasePart") then
			local physicalProp = PhysicalProperties.new(0.01,0.3,0,1,0)
			new.CustomPhysicalProperties = physicalProp	
			end
			if object:FindFirstChild("Weld") then
				local warning = Instance.new("ObjectValue")
				warning.Name = "NeedsWelding"
				warning.Value = new
				warning.Parent = object
				new:FindFirstChild("Weld"):Destroy()
				if new:FindFirstChild("WeldTo") then
				new:FindFirstChild("WeldTo"):Destroy()	
				end
			end
			if new:FindFirstChildOfClass("Motor6D") then
				for i,v in pairs(new:GetChildren()) do
				if v:IsA("Motor6D") or v.Name == "MotorTo" then
					v:Destroy()
				end
				end
			end
		end
		
		id = id + 1
	end

	--return names to normal
	for id, origName in pairs(origNames) do
		current[id].Name = origName
	end
	
	--motoring?
	for _, object in pairs(current:GetChildren()) do
		if object:IsA("Script") and object.Name == ("AbilityScript") then
			current:FindFirstChild(object.Name):Destroy()	
		end
		if object:IsA("Model") and object.Name == ("CharacterData") then
			current:FindFirstChild(object.Name):Destroy()	
			end
		if object:FindFirstChild("MakeMotor") then
			local obj = object.MakeMotor
			local part = current:FindFirstChild(obj.Value)
			if part then
				makeMotor(part, object, obj.C0.Value, obj.C1.Value)
			end
		end
	end
	local ta = {}
	local function contains(t, v)
	for _, val in pairs(t) do
		if val == v then
			return true
		end
	end
	return false
end
	--weld dat
	for _, object in pairs(desired:GetChildren()) do
		if object:FindFirstChild("NeedsWelding") then
			local new = object.NeedsWelding.Value
			
			for _, obj in pairs(object:GetChildren()) do
				if obj.Name == "Weld" and contains(ta,{new,obj.Part1.Name}) == false and obj.Part1.Name  then
					local part1Name = obj.Part1.Name
					local newWeld = obj:clone()
					newWeld.Part0 = new
					newWeld.Part1 = current[part1Name]
					newWeld.Parent = new
					--print(newWeld)
					table.insert(ta,{new,part1Name})
				end
			end
		end
	end
	local function recurse(root)
		for _, obj in pairs(root:GetChildren()) do
			if obj:IsA("Script") and obj.Name ~= ("AbilityScript") then
				obj.Disabled = false
			end
			
			recurse(obj)
		
			
		end
	end
	desired:Destroy()
	recurse(current)

	--add back the gui
	local team = current:FindFirstChild("GetTeam")
	local billboard = current:FindFirstChild("TeamGui", true)
	if team ~= nil and billboard == nil then
		team = team:Invoke()
		team:CreatePlayerTeamGui(current)
	end
end

script.ChangeCharacter.OnInvoke = changeCharacter