local player = game.Players.LocalPlayer
while not player.Character do wait() end
local humanoid = player.Character:WaitForChild("Humanoid")
humanoid.JumpPower = 0