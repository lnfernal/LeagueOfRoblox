local PLAYER = game.Players.LocalPlayer
local MOUSE = PLAYER:GetMouse()
local UserInput = game:GetService("UserInputService")
local CLICK_COOLDOWN = false
local upgrademode = false
local R = game.ReplicatedStorage.Remotes

function e(name)
	return R[name]
end

game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
--game:GetService("StarterGui"):SetCore("ResetButtonCallback", false)
--MOUSE.Move:connect(function()
--	e("MouseMove"):FireServer(MOUSE.Hit, MOUSE.Target)
--end)

local hold = false
MOUSE.Button1Down:connect(function()
	if not CLICK_COOLDOWN then
		hold = true
	
	
	end
end)
MOUSE.Button1Up:connect(function()
	hold = false
end)

UserInput.InputBegan:connect(function(key, ProcessedEvent)
	if key.KeyCode == Enum.KeyCode.LeftControl and ProcessedEvent == false then
		upgrademode = true
	end
	if ProcessedEvent == false and upgrademode == false and key.KeyCode ~= Enum.KeyCode.Unknown then
	e("KeyDown"):FireServer(key.KeyCode)
	elseif key.KeyCode == Enum.KeyCode.One and  ProcessedEvent == false and upgrademode == true then
		R.LevelUpAbility:InvokeServer("A")
	
	elseif key.KeyCode == Enum.KeyCode.Two  and  ProcessedEvent == false and upgrademode  == true then
		R.LevelUpAbility:InvokeServer("B")
	
	elseif key.KeyCode == Enum.KeyCode.Three and  ProcessedEvent == false and upgrademode  == true then
		R.LevelUpAbility:InvokeServer("C")
	
	elseif key.KeyCode == Enum.KeyCode.Four and  ProcessedEvent == false and upgrademode  == true then
		R.LevelUpAbility:InvokeServer("D")
	end
end)

UserInput.InputEnded:connect(function(key, ProcessedEvent)
	if key.KeyCode == Enum.KeyCode.LeftControl then
		upgrademode = false
	end
end)
function getMouseTargetPoint()
	local char = PLAYER.Character
	if not char then return Vector3.new() end
	
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return Vector3.new() end
	
	local mouse = PLAYER:GetMouse()
	
	local footY = root.Position.Y - root.Size.Y * 1.5
	local ray = mouse.UnitRay
	if ray.Direction.magnitude <= 0 then
		return Vector3.new()
	end
	local t = (ray.Origin.Y - footY) / ray.Direction.Y
	local x = ray.Origin.X - ray.Direction.X * t
	local z = ray.Origin.Z - ray.Direction.Z * t
	
	return Vector3.new(x, footY, z)
end
script.GetMouseTargetPoint.OnInvoke = getMouseTargetPoint

MOUSE.KeyUp:connect(function(key)
	--e("KeyUp"):FireServer(key)
	
	--if key == "e" then
		--R.StopLeaderboard:FireServer()
	--end
end)

e("GetMousePos").OnClientInvoke = function()
	return getMouseTargetPoint()
end

while true do
	if hold then
	e("MouseButton1Down"):FireServer(MOUSE.Hit, MOUSE.Target)
	CLICK_COOLDOWN = true
	wait(0.1)
	CLICK_COOLDOWN = false
	end
	wait()
	end
