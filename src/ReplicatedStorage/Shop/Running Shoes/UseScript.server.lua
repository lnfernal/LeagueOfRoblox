local active = true

function script.Use.OnInvoke(item, d)
	if not active then return end
	
	d.ST.MoveSpeed:Invoke(d.HUMAN, .2, 5)
	active = false
	wait(30)
	active = true
end

local active = true