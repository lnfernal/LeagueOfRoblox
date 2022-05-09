local info = {
	Shedletsky = 4355003422,
	ReeseMcBlox = 5200452433,
	Builderman = 5523004432,
	ChiefJustus = 5142233514,
	Sorcus = 2255004334,
	BlockHaak = 2355004234,
	JacksSmirkingRevenge = 5300354224,
	Stickmasterluke = 2200554433,
	Guest = 5241342513,
	ejob = 5200254433,
	Shylocke = 2255004422,
	FlareBlast = 5400224533,
	PuNiShEr5665 = 2433354211,
	ObliviousPanther = 4200553324,
	Ozzypig = 4400553223,
	Nightgaladeld = 3455002243,
	Firebrand1 = 3500442253,
	Cupcake = 4455002332,
	DeadpoolDaMercenary = 5532004324,
	DekenusTheFallenOne = 4500225433,
	JoelMatGarcia = 5244002533,
}
info["Matt Dusek"] = 2200553344
info["1x1x1x1"] = 4300223455

function health(b, l)
	b = 105 + tonumber(b) * 15
	l = 7.5 + tonumber(l) * 2.5
	return b, l
end

function h4x(b, l)
	if b == "0" then
		return 0, 0
	end
	
	b = 3 + tonumber(b)
	l = .4 * tonumber(l)
	return b, l
end

function skillz(b, l)
	if b == "0" then
		return 0, 0
	end
	
	b = 2 + tonumber(b)
	l = .2 + .3 * tonumber(l)
	return b, l
end

function toughness(b, l)
	b = 3 + tonumber(b) * 2
	l = -.2 + tonumber(l) * .6
	return b, l
end

function resistance(b, l)
	b = 2 + tonumber(b) * 2
	l = -.2 + tonumber(l) * .5
	return b, l
end

function setCharacterData(name, number)
	local str = tostring(number)
	
	local hb = str:sub(1,1)
	local hl = str:sub(2,2)
	local sb = str:sub(3,3)
	local sl = str:sub(4,4)
	local xb = str:sub(5,5)
	local xl = str:sub(6,6)
	local tb = str:sub(7,7)
	local tl = str:sub(8,8)
	local rb = str:sub(9,9)
	local rl = str:sub(10,10)
	
	hb, hl = health(hb, hl)
	xb, xl = h4x(xb, xl)
	sb, sl = skillz(sb, sl)
	tb, tl = toughness(tb, tl)
	rb, rl = toughness(rb, rl)
	
	if xb == 0 then
		sb = sb * 1.25
		sl = sl * 1.25
	end
	
	if sb == 0 then
		xb = xb * 1.25
		xl = xl * 1.25
	end
	
	local character = game.ReplicatedStorage.Characters:FindFirstChild(name)
	if character then
		local data = character:FindFirstChild("CharacterData")
		if data ~= nil then
			data:Destroy()
		end
		data = Instance.new("Model")
		data.Name = "CharacterData"
		data.Parent = character
		
		local function statModel(stat, base, perLevel)
			local model = Instance.new("Model")
			model.Name = stat
			model.Parent = data
			
			local b = Instance.new("NumberValue")
			b.Name = "Base"
			b.Value = base
			b.Parent = model
			
			local p = Instance.new("NumberValue")
			p.Name = "PerLevel"
			p.Value = perLevel
			p.Parent = model
		end
		
		statModel("Health", hb, hl)
		statModel("Skillz", sb, sl)
		statModel("H4x", xb, xl)
		statModel("Toughness", tb, tl)
		statModel("Resistance", rb, rl)
	end
end

--for name, number in pairs(info) do
--	setCharacterData(name, number)
--end