local function getType(obj)
	local t = type(obj)
	
	if t == "userdata" then
		local isCFrame = pcall(function() return obj.lookVector end)
		if isCFrame then return "CFrame" end
		
		local isVector3 = pcall(function() return obj:Dot(Vector3.new()) end)
		if isVector3 then return "Vector3" end
		
		local isBrickColor = pcall(function() return obj.Color end)
		if isBrickColor then return "BrickColor" end
		
		local isColor3 = pcall(function() return obj.r, obj.g, obj.b end)
		if isColor3 then return "Color3" end
	else
		if t == "string" then
			return "String"
		elseif t == "number" then
			return "Number"
		elseif t == "boolean" then
			return "Bool"
		end
	end
end

return getType