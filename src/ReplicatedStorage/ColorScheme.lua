local function hexToDec(a)
	a = a:lower()
	if a == "a" then
		a = 10
	elseif a == "b" then
		a = 11
	elseif a == "c" then
		a = 12
	elseif a == "d" then
		a = 13
	elseif a == "e" then
		a = 14
	elseif a == "f" then
		a = 15
	else
		a = tonumber(a)
	end
	return a
end

local function elementFromHex(hex)
	local a = hexToDec(hex:sub(1, 1)) * 16
	local b = hexToDec(hex:sub(2, 2))
	return a + b
end

local function color(hex)
	local r = elementFromHex(hex:sub(1, 2))
	local g = elementFromHex(hex:sub(3, 4))
	local b = elementFromHex(hex:sub(5, 6))
	return Color3.new(r / 255, g / 255, b / 255)
end

local colorScheme = {
	Primary = color("999999"),
	Secondary = color("888888"),
	Text = color("FFFFFF"),
	Tertiary = color("444444"),
	Quaternary = color("333333"),
	HealthFull = color("4FC974"),
	HealthLow = color("7D1918"),
	Dark = color("000000"),
}

return colorScheme