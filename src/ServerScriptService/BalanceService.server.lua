local CHARACTERS = {}

local function getAverageLevel()
	local teamScript = game.ServerScriptService.TeamScript
	return teamScript.GetAverageLevel:Invoke()
end

local function getAverageExperience()
	local teamScript = game.ServerScriptService.TeamScript
	return teamScript.GetAverageExperience:Invoke()
end

local function balanceCharacter(char)
	local setStat = char:FindFirstChild("SetStat", true)
	local charData = char:FindFirstChild("CharacterData")
	if setStat and charData then
		local avgLvl = getAverageLevel()
		for _, statModel in pairs(charData:GetChildren()) do
			local stat = statModel.Name
			local base = statModel.Base.Value
			local perLevel = statModel.PerLevel.Value
			local t = game.ReplicatedStorage.GameState.Time.Value
			local total = base + perLevel * (avgLvl + math.floor((math.floor(t/60)/5)))
			setStat:Invoke(stat, math.min(math.max(total, 1), 99999))
		end
	end
end

local function balanceAllCharacters()
	for index, char in pairs(CHARACTERS) do
		if not char.Parent then
			table.remove(CHARACTERS, index)
		else
			balanceCharacter(char)
		end
	end
end

local function addCharacter(char)
	table.insert(CHARACTERS, char)
end
script.AddCharacter.OnInvoke = addCharacter

local function main()
	while true do
		wait(1)
		balanceAllCharacters()
	end
end

main()