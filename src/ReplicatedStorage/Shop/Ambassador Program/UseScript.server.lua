local active = true

function script.Use.OnInvoke(item, d)
	if not active then return end
	local radius = 18
	local center = d.HRP.Position
local team = d.GET_OTHER_TEAM:Invoke(d.CHAR.Team.Value)
local function onHit(ally)
				d.ST.MoveSpeed:Invoke(ally, .15, 5)
				if d.CHAR:FindFirstChild("ForceField") then return end
	if d.HUMAN:FindFirstChild("Anti") then return end
	local STATUSES = d.CHAR:FindFirstChild("Statuses")
	if STATUSES and not d.CHAR:FindFirstChild("ForceField") then
		for i,v in pairs(STATUSES:GetChildren()) do
			if v.Name == "MoveSpeed" then
				v:Destroy()
			elseif v:FindFirstChild("Amount") and v:FindFirstChild("Amount").Value < 0 then
				v:Destroy()
			end
		end
	end  
	end
d.DS.AOE:Invoke(center, radius, team, onHit)
	d.SFX.Shockwave:Invoke(d.FLAT(center), radius, "Cyan")
	active = false
	wait(25)
	active = true
end

local active = true