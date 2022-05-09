local module = {}
local CHAR = game.Workspace:WaitForChild(script.Name)
local STATUSES = CHAR:WaitForChild("Statuses")
local PASSIVE = CHAR:WaitForChild("Passives")
local INVENTORY = CHAR:WaitForChild("CharacterScript"):WaitForChild("Inventory")
function Ability(id)
	return {
		OnCooldown = false,
		CooldownLeft = 0,
		Cooldown = 1,
		Level = 0,
		C = function(self, data)
			local total = 0
			for stat, scale in pairs(data) do
				if stat == "Base" then
					total = total + scale
				elseif stat == "AbilityLevel" then
					total = total + self.Level * scale
				else
					total = total + self:Get(stat) * scale
				end
				if stat == "H4xAbilityLevel" then
					total = total + (self:Get("H4x") * scale) *  self.Level 
				end
				end
			return total
		end,
		Id = id,
	}
end

module.Stats = {
	Level = 0,
	Experience = 0,
	Skillz = 0,
	Toughness = 0,
	H4x = 0,
	Resistance = 0,
	BasicCDR = 0,
	CooldownReduction = 0,
	Shields = 0,
	Speed = 16,
	Health = 100,
	HealthRegen = 1,
	Tix = 450,
	Kills = 0,
	Deaths = 0,
	Assists = 0,
	Abilities = {
		Q = Ability("Q"),
		A = Ability("A"),
		B = Ability("B"),
		C = Ability("C"),
		D = Ability("D"),
}}
module.StatsGet = function(statName)
		local base = module.Stats[statName] or 0	
		
		--check for stat buffs
		for _, status in pairs(STATUSES:GetChildren()) do
			if status.Effect.Value == "StatBuff" then
				if status:FindFirstChild("Stat") then
				if status.Stat.Value == statName then
					base = base + status.Amount.Value
				end
				end
			end
		end
		
		for _, status in pairs(PASSIVE:GetChildren()) do
			if status.Effect.Value == "StatBuff" then
				if status.Stat.Value == statName then
					base = base + status.Amount.Value
				end
			end
		end
		
		
		--check for stat boosting items
		for _, item in pairs(INVENTORY:GetChildren()) do
			local statEffect = item.Effects:FindFirstChild(statName)
			if (item.Name == "Ghostwalker" or item.Name == "Exploiter's Rapier") and statEffect and module.Stats["Kills"] <= 9 then
			base = base + (statEffect.Value + (15 *  module.Stats["Kills"]))
			elseif (item.Name == "Ghostwalker" or item.Name == "Exploiter's Rapier") and statEffect and module.Stats["Kills"] > 9 then
			base = base + (statEffect.Value + (15 * 9))
			elseif statEffect then
				base = base + statEffect.Value
			end
			
		end	
		if base < 0 then
			base = 0
		end
		return base	
end
module.SetStat = function(statName,value)
	module.Stats[statName] = value
end
module.BaseStatGet = function(statName)
		local base = module.Stats[statName] or 0	
		return base
end
return module
