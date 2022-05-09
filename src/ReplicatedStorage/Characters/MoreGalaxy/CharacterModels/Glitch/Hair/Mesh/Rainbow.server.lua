-- I picked up how to do this on Khan Academy (https://www.khanacademy.org/) after
-- looking at a few projects that used this technique, namely
-- Lava the Impossible Game, by Swax97. The technique uses
-- sin(milliseconds since project start) to create a disco color. I don't want to
-- go into too much detail, but this is roughly how I did it in ROBLOX.

-- Just so you know, math.sin(workspace.DistributedGameTime) will gradually
-- increase/decrease from -1 to 1 and vice versa indefinitely. If you want to try
-- and understand the math behind this creation, go ahead. I won't stop you.

-- LoganDark

function loop()
	local r = (math.sin(workspace.DistributedGameTime/2)/2)+0.5
	local g = (math.sin(workspace.DistributedGameTime)/2)+0.5
	local b = (math.sin(workspace.DistributedGameTime*1.5)/2)+0.5
	local color = Vector3.new(r, g, b)
	script.Parent.VertexColor = color
end

game:GetService("RunService").Heartbeat:Connect(loop)