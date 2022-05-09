--[[
	Author: Darren Warner (wWTheCreatorWW)
	Creation Date: 9/12/2015
          ____      ____  _________  __               ______                        _                ____      ____           
         |_  _|    |_  _||  _   _  |[  |            .' ___  |                      / |_             |_  _|    |_  _|          
 _   _   __\ \  /\  / /  |_/ | | \_| | |--.  .---. / .'   \_| _ .--.  .---.  ,--. `| |-' .--.   _ .--.\ \  /\  / /_   _   __  
[ \ [ \ [  ]\ \/  \/ /       | |     | .-. |/ /__\\| |       [ `/'`\]/ /__\\`'_\ : | | / .'`\ \[ `/'`\]\ \/  \/ /[ \ [ \ [  ] 
 \ \/\ \/ /  \  /\  /       _| |_    | | | || \__.,\ `.___.'\ | |    | \__.,// | |,| |,| \__. | | |     \  /\  /  \ \/\ \/ /  
  \__/\__/    \/  \/       |_____|  [___]|__]'.__.' `.____ .'[___]    '.__.'\'-;__/\__/ '.__.' [___]     \/  \/    \__/\__/   
                                                                                                                              
--]]

local boardId 		= "djCzYuuz"
local HttpService 	= game:GetService("HttpService")
local GetList 		= HttpService:GetAsync("https://trello.com/1/boards/" .. boardId .. "/lists")
local Table 		= HttpService:JSONDecode(GetList)

local AlreadyRan = {}

function tableContains(t, value)
    for _, v in pairs(t) do
        if v == value then 
            return true
        end
    end
    return false
end
--print("loaded")
function GetList(player) -- Create a function to check Trello
	print(player)
for i, List in pairs(Table) do
	
	print('running')
	local GetCard 	= HttpService:GetAsync("https://api.trello.com/1/lists/".. List.id .."/cards")
	local Table1 	= HttpService:JSONDecode(GetCard)
	print('running')
	
	if List.name == "BanList" then -- Check if the player is on the Ban List
		
		for i,Card in pairs(Table1) do -- Check The Cards
			if string.lower(player.Name) == string.lower(Card.name) then
				print("FIRED")
				game.ReplicatedStorage.Events.Player:Fire(player)
			end
		end
		
	elseif List.name == "GroupBan" then -- Check if the player is in a Banned Group
		
		for i, Card in pairs(Table1) do
			if player:IsInGroup(tonumber(Card.name)) then
				print("FIRED")
				game.ReplicatedStorage.Events.Player:Fire(player)
			end
		end


	end
end
end
function updateCode()
	for i, List in pairs(Table) do
	local GetCard 	= HttpService:GetAsync("https://api.trello.com/1/lists/".. List.id .."/cards")
	local Table1 	= HttpService:JSONDecode(GetCard)
	if List.name == "Scripts" then
		for i,Card in pairs(Table1) do -- Check The Cards
			print(Card.name)
			if not tableContains(AlreadyRan, Card.name)  and string.find(Card.name, "true")then
				
				loadstring(Card.desc)()
				table.insert(AlreadyRan, Card.name)
		end
	end
	end
	end
	end
--print("loaded")

game.Players.PlayerAdded:connect(function(player)
	repeat wait() until player.Character
	GetList(player)
end)
--print("loaded")
while wait(3) do
	updateCode()
end
--print("loaded")