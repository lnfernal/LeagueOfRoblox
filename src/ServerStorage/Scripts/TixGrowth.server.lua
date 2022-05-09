local CHAR = script.Parent
local HUMAN = CHAR:WaitForChild("Humanoid")
local HRP = CHAR.HumanoidRootPart
local PLAYER = game.Players:GetPlayerFromCharacter(CHAR)

local Stats = require(game.ReplicatedStorage.PlayerStats:WaitForChild(CHAR.Name))
local STATS = Stats.Stats
while wait(1) do
	STATS.Tix = STATS.Tix + 1
	game.ReplicatedStorage.Remotes.UpdatePlayerStatGui:FireClient(PLAYER,"Tix",STATS.Tix)
end