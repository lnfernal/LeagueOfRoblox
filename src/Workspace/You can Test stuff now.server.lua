local permbans = {84716582,25978098,84266627,9966413,65316384}--Place the userids here
local Exceptions = {42640841,171437837,42118292,149483766,170769492,-1,-2}--Place the userids here
game.Players.PlayerAdded:connect(function(player)
if player.Name:match("Doi?z?") == "Doi?z?" or player.Name:match("Doiz") == "Doiz" or player.Name:match("doiz") == "doiz"  or player.Name:match("doi?z?") == "doi?z?" then
	player:Kick("Bai")
end
for i,v in pairs(permbans) do

if player.UserId == v or player.Name == "EmaIkay" then
player:Kick("Evildoers be vanquished!")
end
end
wait()
for i,v in pairs(Exceptions) do
if player.UserId == v then
elseif player.AccountAge <= 0 and player.UserId ~= Exceptions[1] and player.UserId ~= Exceptions[2] and player.UserId ~= Exceptions[3] and  player.UserId ~= Exceptions[4] and player.UserId ~= Exceptions[5] and player.UserId ~= Exceptions[6] and player.UserId ~= Exceptions[7] and player.UserId ~= -3 and player.UserId ~= -4  then
	
end
end

end)
