math.randomseed(os.time())
local PURCHASES = game:GetService("DataStoreService"):GetDataStore("Purchases")
local UNLOCKS = game:GetService("DataStoreService"):GetDataStore("Unlocks")
local LEVELS = game:GetService("DataStoreService"):GetDataStore("PlayerLevels")
local PLAY_ANIM = require(game.ServerStorage.PlayAnimation)
local Event = ""
local R = game.ReplicatedStorage.Remotes
local GAMEMODE = game.ReplicatedStorage.GameState.Gamemode
local getThumbnail = require(game.ReplicatedStorage.GetThumbnail)
local charsskins = {}
for i,character in pairs(game.ReplicatedStorage.Characters:GetChildren()) do
	if character:FindFirstChild("CharacterModel") then
		table.insert(charsskins,character:FindFirstChild("CharacterModel"))
	elseif character:FindFirstChild("CharacterModels") then
		for i,v in pairs(character.CharacterModels:GetChildren()) do
			table.insert(charsskins,v)
		end
	end
end
function getKillsDeaths(char)
	local scr = char:FindFirstChild("CharacterScript")
	if scr then
		local gs = scr:FindFirstChild("GetStat")
		if gs then
			local kills = gs:Invoke("Kills")
			local deaths = gs:Invoke("Deaths")
			local assists = gs:Invoke("Assists")
			
			return kills.." / "..deaths.." / "..assists
		end
	end
	
	return ""
end

function startCommunication()	
	local function Unlocks(player)
		if UNLOCKS and Event == "Christmas" then
			for i,chars in pairs(game.ReplicatedStorage.Characters:GetChildren()) do
			if chars:FindFirstChild("CharacterModels") then
			for i,skin in pairs(chars:FindFirstChild("CharacterModels"):GetChildren()) do
			if skin:FindFirstChild("RequiredLevel") then
			local ll = LEVELS:GetAsync(player.userId) or 1
			if skin:FindFirstChild("Event")and skin:FindFirstChild("Event").Value == Event and skin:FindFirstChild("RequiredLevel").Value <= ll then
			UNLOCKS:SetAsync(player.userId.."has"..skin.Name,true)
			end
			end
			end
			end
			end
		end
	end
	R.UnlockSkins.OnServerEvent:connect(Unlocks);
	R.GetPurchased.OnServerInvoke = function(player, assetId)
		if player.Name == "Player" then
			return true
		end
		
		if PURCHASES then
			return PURCHASES:GetAsync(player.userId.."has"..assetId)
		else
			return true
		end
	end
	R.TrackEvent.OnServerInvoke = function(player, skin)
		if type(skin) == "model" then
		if player.Name == "Player1" then
			return true
		end
		
		if UNLOCKS then
			return UNLOCKS:GetAsync(player.userId.."has"..skin.Name)
		else
			return false
		end
		else
		if player.Name == "Player1" then
			return true
		end
		if UNLOCKS then
			return UNLOCKS:GetAsync(player.userId.."has"..tostring(skin))
		else
			return false
		end
		end
	end
	R.SetChar.OnServerInvoke = function(player, character)
		local Contingency = Instance.new("StringValue")
		Contingency.Name = "CharMods"
		Contingency.Value = character.Name
	local playerState = player.Backpack:WaitForChild("PlayerState")
		Contingency.Parent = playerState	
	end
	R.SelectCharacter.OnServerInvoke = function(player, character, characterModel,skin,colors)
		if type(characterModel) == "string" then
			if characterModel == "You" then
			characterModel = game.ServerStorage.ExtraCharacters.You
			characterModel.Torso.Essentials.Value = ""
			for i,v in pairs(characterModel.Torso:GetChildren()) do
				if colors[v.Name] then
					if v:IsA("Color3Value") then
					v.Value = BrickColor.new(colors[v.Name]).Color	
					elseif v:IsA("StringValue") then
					v.Value = colors[v.Name]					
					else
					v.Value = BrickColor.new(colors[v.Name])
					end
				end
			end
			skin = game.ServerStorage.ExtraCharacters.You:Clone()
			skin.Name = player.Name
			local models = character:FindFirstChild("CharacterModels")
			if models then
				local tocopy = models:FindFirstChild(colors["Essentials"])
				if tocopy then
					for i,v in pairs(tocopy:GetChildren()) do
						if v:IsA("Script") or v:IsA("StringValue") or v:IsA("NumberValue") then
							local copy = v:Clone()
							copy.Parent = skin
						end
					end
				end
			end
			elseif characterModel == "John Doe" then
			characterModel = game.ServerStorage.ExtraCharacters["John Doe"]
			for i,v in pairs(characterModel.Torso:GetChildren()) do
				if colors[v.Name] then
					if v:IsA("Color3Value") then
					v.Value = BrickColor.Random().Color
					elseif v:IsA("StringValue") then
					v.Value = "Plastic"					
					else
					v.Value = BrickColor.Random()
					end
				end
			end
			local rand = character:FindFirstChild("CharacterModels"):GetChildren()[math.random(#character:FindFirstChild("CharacterModels"):GetChildren())]
			characterModel.Torso.Essentials.Value = rand.Name
			skin = game.ServerStorage.ExtraCharacters["John Doe"]:Clone()
			local Does = {"John Doe", "Jane Doe"}
			skin.Name = Does[math.random(#Does)]
			local models = character:FindFirstChild("CharacterModels")
			if models then
				local tocopy = rand
				if tocopy then
					for i,v in pairs(tocopy:GetChildren()) do
						if v:IsA("Script") or v:IsA("StringValue") or v:IsA("NumberValue") then
							local copy = v:Clone()
							copy.Parent = skin
						end
					end
				end
			end
			
			
			
			end
		
		
		end
		
		local toselect = nil
		local hold = player.Character:FindFirstChild("CharacterSelectHold", true)
		--print("THE CHARACTER SELECT HOLDING OBJECT IS", hold)
		if hold then
			hold:Destroy()
		end
		if skin ~= nil and skin:FindFirstChild("AbilityScript") then
		skin.AbilityScript:clone().Parent = player.Backpack
		else
		character.AbilityScript:clone().Parent = player.Backpack
		end
		local control = game.ServerStorage.Scripts.ControlScript:clone()
		if skin ~= nil and skin:FindFirstChild("CharacterData") then
		local characterData = skin.CharacterData:clone()
		characterData.Parent = control
		else
		local characterData = character.CharacterData:clone()
		characterData.Parent = control	
		end
		
		local cmr = Instance.new("ObjectValue")
		cmr.Value = characterModel
		cmr.Name = "CharacterModel"
		cmr.Parent = control
		if GAMEMODE.Value == "Identity Crisis" then
		toselect = charsskins[math.random(1,#charsskins)]
		local scr = Instance.new("ObjectValue")
		if player.Backpack:FindFirstChild("ForcedCharIdentity") then
			scr.Value = player.Backpack:FindFirstChild("ForcedCharIdentity").Value
			toselect = player.Backpack:FindFirstChild("ForcedCharIdentity").Value
		else
		scr.Value = toselect	
		end
		
		scr.Name = "CharacterModels"
		scr.Parent = control
		end
		local SKIN = Instance.new("StringValue")
		SKIN.Name = "Skin"
		
		control.Parent = player.Backpack
		
		local characterName = Instance.new("StringValue")
		characterName.Name = "CharacterName"
		if toselect ~= nil and (toselect.Name == "Classic" or toselect.Name == "Original") then
		characterName.Value = toselect.Parent.Parent.Name.." "..character.Name
		SKIN.Value = toselect.Name
		elseif toselect ~= nil and (skin.Name == "Classic" or skin.Name == "Original") then
		characterName.Value = toselect.Name.." "..character.Name
		SKIN.Value = toselect.Name	
		elseif toselect ~= nil then
		characterName.Value = toselect.Name.." "..skin.Name.." "..character.Name
		SKIN.Value = toselect.Name	
		elseif (skin == nil or skin.Name == "Classic" or skin.Name == "Original") then
			characterName.Value = character.Name
			SKIN.Value = ""
		elseif (skin.Name == "Cindering" or skin:FindFirstChild("UniqueName")) then
			characterName.Value = skin.Name
			SKIN.Value = skin.Name
		else
			characterName.Value = skin.Name.." "..character.Name
			SKIN.Value = skin.Name
		end
		characterName.Parent = player.Backpack
		
		
			if (skin == nil or skin.Name == "Classic" or skin.Name == "Original") and character:FindFirstChild("PassiveAnim") then
			PLAY_ANIM(player, character.PassiveAnim.Value)
			elseif skin ~= nil and skin:FindFirstChild("PassiveAnim") then
			PLAY_ANIM(player, skin.PassiveAnim.Value)	
			elseif character:FindFirstChild("PassiveAnim") then
			PLAY_ANIM(player, character.PassiveAnim.Value)	
				
		end
		if skin:FindFirstChild('PassivesAnim') then
			player.Character:WaitForChild("Animate").idle.Animation1.AnimationId = skin.PassivesAnim.Value
			player.Character:WaitForChild("Animate").idle.Animation2.AnimationId = skin.PassivesAnim.Value
			elseif character:FindFirstChild('PassivesAnim') then
			player.Character:WaitForChild("Animate").idle.Animation1.AnimationId = character.PassivesAnim.Value
			player.Character:WaitForChild("Animate").idle.Animation2.AnimationId = character.PassivesAnim.Value
		end
		if skin:FindFirstChild('WalksAnim') then
		player.Character:WaitForChild("Animate").walk.WalkAnim.AnimationId = skin.WalksAnim.Value
		elseif character:FindFirstChild('WalksAnim') then
		player.Character:WaitForChild("Animate").walk.WalkAnim.AnimationId = character.WalksAnim.Value
		end
		if character:FindFirstChild("WalkAnim") then
				if skin == nil or skin.Name == "Classic" or skin.Name == "Original" then
			player.Character:WaitForChild("Animate").Disabled = true
			R.CustomWalk:InvokeClient(player, character.WalkAnim.Value)
				else
					if skin:FindFirstChild("WalkAnim") then
				player.Character:WaitForChild("Animate").Disabled = true
			R.CustomWalk:InvokeClient(player, skin.WalkAnim.Value)
					else
			player.Character:WaitForChild("Animate").Disabled = true
			R.CustomWalk:InvokeClient(player, character.WalkAnim.Value)	
			end		
				end
				end
		
		--insert the character's name and portrait into the PlayerState
		local playerState = player.Backpack:WaitForChild("PlayerState")
		--Contingency.Parent = playerState
		SKIN.Parent = playerState
		characterName:Clone().Parent = playerState
		
		local charPortrait = Instance.new("StringValue")
		charPortrait.Name = "CharacterPortrait"
		if skin == nil or skin.Name == "Classic" or skin.Name == "Original" then
		charPortrait.Value = getThumbnail(character:FindFirstChild("PortraitModelId").Value)
		else
		if skin:FindFirstChild("PortraitModelId") and toselect == nil then
		charPortrait.Value = getThumbnail(skin:FindFirstChild("PortraitModelId").Value)
		elseif toselect ~= nil and toselect:FindFirstChild("PortraitModelId") then
		charPortrait.Value = getThumbnail(toselect:FindFirstChild("PortraitModelId").Value)
		elseif toselect ~= nil then
		charPortrait.Value = getThumbnail(toselect.Parent.Parent:FindFirstChild("PortraitModelId").Value)
		else
			charPortrait.Value = getThumbnail(character:FindFirstChild("PortraitModelId").Value)
		end
		end
		charPortrait.Parent = playerState
		if skin ~= nil and skin:FindFirstChild("Icons") then
		for i,v in pairs(skin:FindFirstChild("Icons"):GetChildren()) do
				local icon = Instance.new("StringValue",playerState)
				icon.Parent = playerState
				if v.Name == "AbilityiconA" then
				icon.Name = "AbilityiconA"
				icon.Value = getThumbnail(v.Value)
				elseif v.Name == "AbilityiconB"  then
				icon.Name = "AbilityiconB"	
				icon.Value = getThumbnail(v.Value)
				elseif v.Name == "AbilityiconC" then
				icon.Name = "AbilityiconC"	
				icon.Value = getThumbnail(v.Value)
				elseif v.Name == "AbilityiconD" then
				icon.Name = "AbilityiconD"	
				icon.Value = getThumbnail(v.Value)
				end	
			end
		elseif character:FindFirstChild("Icons") then
			for i,v in pairs(character:FindFirstChild("Icons"):GetChildren()) do
				local icon = Instance.new("StringValue",playerState)
				icon.Parent = playerState
				if v.Name == "AbilityiconA" then
				icon.Name = "AbilityiconA"
				icon.Value = getThumbnail(v.Value)
				elseif v.Name == "AbilityiconB"  then
				icon.Name = "AbilityiconB"	
				icon.Value = getThumbnail(v.Value)
				elseif v.Name == "AbilityiconC" then
				icon.Name = "AbilityiconC"	
				icon.Value = getThumbnail(v.Value)
				elseif v.Name == "AbilityiconD" then
				icon.Name = "AbilityiconD"	
				icon.Value = getThumbnail(v.Value)
				end	
			end
		else
				for i =1 ,4 do
				local icon = Instance.new("StringValue",playerState)
				if i == 1 then
				icon.Name = "AbilityiconA"
				elseif i == 2 then
				icon.Name = "AbilityiconB"	
				elseif i == 3 then
				icon.Name = "AbilityiconC"	
				elseif i == 4 then
				icon.Name = "AbilityiconD"	
				end	
				end
		end
		local RAPI = _G.RAPI
		if RAPI then
			RAPI.Functions.RecordOccurrenceData("Character Chosen", character.Name)
		end
	end
	R.LevelUpAbility.OnServerInvoke = function(player, abilityName)
		local char = player.Character 
		if abilityName == "A" and (player.Backpack:FindFirstChild("PlayerState"):FindFirstChild("CharMods").Value == "The Murderer" or player.Backpack:FindFirstChild("PlayerState"):FindFirstChild("CharMods").Value == "ObliviousPanther")then
			player.Backpack.AbilityScript.UnlockFirst:Fire()
		end
		if abilityName == "D" and (player.Backpack:FindFirstChild("PlayerState"):FindFirstChild("CharMods").Value == "Matt Dusek" or player.Backpack:FindFirstChild("PlayerState"):FindFirstChild("CharMods").Value == "BLOXER787" or player.Backpack:FindFirstChild("PlayerState"):FindFirstChild("CharMods").Value == "Davidscookies") then
			player.Backpack.AbilityScript.UnlockUltimate:Fire()
		end
		if char then
			local scr = char:FindFirstChild("CharacterScript")
			if scr then
				local abilityLevel = scr:FindFirstChild("AbilityLevelUp")
				if abilityLevel then
					abilityLevel:Invoke(abilityName)
				end
			end
		end
	end
	R.AttemptShopBuy.OnServerInvoke = function(player, shopItem)
		local BASE_ITEMS = {"Normal Sword" , "Tin Foil Hat" , "Shoes" , "Client Dagger" , "BLOXy Cola" , "Antivirus Script" , "Plastic Armor" , "Health Potion" , "Speed Potion" , "Mesh Character" , "Local Script"} --11
		local char = player.Character
		local scr = char:FindFirstChild("CharacterScript")
		
		local function Check(item)
		if item == "Bluesteel Blade" then
			return true
		elseif item == ".dll Exploit" then
			return true
		elseif item == "Admin Broadsword" then
			return true
		elseif item == "Armored Shoes" then
			return true
		elseif item == "Backup Copy Armor" then
			return true
		elseif item == "DDoS" then
			return true
		elseif item ==  "Darkheart" then
			return true
		elseif item == "Data Shield" then
			return true
		elseif item == "Encrypted Shoes" then
			return true
		elseif item == "Expensive Outfit" then
			return true
		elseif item == "Exploiter's Rapier" then
			return true
		elseif item == "Firewall" then
			return true
		elseif item == "Glitched Sword" then
			return true
		elseif item == "Illumina" then
			return true
		elseif item == "Limited Hat" then
			return true
		elseif item == "Load String" then
			return true
		elseif item == "Metal Armor" then
			return true
		elseif item == "Network Filter" then
			return true
		elseif item == "Plate Armor" then
			return true
		elseif item == "Proxy Jacket" then
			return true
		elseif item == "ROBLOXian Healing Orb" then
			return true
		elseif item == "Running Shoes" then
			return true
		else
			return false 
			end
		end
		
		if char then
			if GAMEMODE.Value ~= "No Item Limit" then
				local shopBuy = scr:FindFirstChild("AttemptShopBuy")
				if shopBuy and #scr.Inventory:GetChildren() < 999 then
					shopBuy:Invoke(shopItem)
				end
			elseif GAMEMODE.Value == "No Item Limit" then
				local shopBuy = scr:FindFirstChild("AttemptShopBuyNoLimit")
				if shopBuy then
					shopBuy:Invoke(shopItem)
				end
			end
		end
	end
	R.AttemptShopSell.OnServerInvoke = function(player, item)
		local char = player.Character
		if char then
			local shopSell = char:FindFirstChild("AttemptShopSell", true)
			if shopSell then
				shopSell:Invoke(item)
			end
		end
	end
	R.Kick.OnServerInvoke = function(player)
		player:Kick()
	end
	local function retreivePlayerLevel(player)
		if LEVELS then
			return LEVELS:GetAsync(player.userId) or 1
		else
			return 1
		end
	end
	
	R.GetPlayerLevel.OnServerInvoke = retreivePlayerLevel;
	script.GetPlayerLevel.OnInvoke = retreivePlayerLevel;
	R.Leaderboard.OnServerEvent:connect(function(player)
		local char = player.Character
		if char then
			local team = char:FindFirstChild("GetTeam")
			if team ~= nil then
				local data = {}
				
				local myTeam = team:Invoke()
				local enTeam = myTeam:GetOtherTeam()
				
				data.MyTeamName = myTeam.Name
				data.MyTeamColor = myTeam.Color.Color
				data.EnTeamName = enTeam.Name
				data.EnTeamColor = enTeam.Color.Color
				
				data.PlayerData = {}
				for _, p in pairs(game.Players:GetPlayers()) do
					local pData = {}
					
					local char = p.Character
					if char ~= nil then
						local team = char:FindFirstChild("GetTeam")
						if team ~= nil then
							local pTeam = team:Invoke()
							
							if p.Backpack:FindFirstChild("CharacterName") then
								pData.Character = p.Backpack.CharacterName.Value
							else
								pData.Character = ""
							end
							
							pData.Ally = (pTeam.Name == myTeam.Name)
							pData.Name = p.Name
							pData.KillsDeaths = getKillsDeaths(char)
							
							table.insert(data.PlayerData, pData)
						end
					end
				end
				
				R.Leaderboard:FireClient(player, data)
			end
		end
	end)
	R.StopLeaderboard.OnServerEvent:connect(function(player)
		R.StopLeaderboard:FireClient(player)
	end)
	R.PlayerHasPass.OnServerInvoke = function(player, id)
		return game:GetService("GamePassService"):PlayerHasPass(player, id)
	end
end

function main()
	startCommunication()
end
main()