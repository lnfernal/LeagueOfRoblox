local bans = require(script.BanModule);
local lib = require(script.Library);
local t =  require(script.TimeModule);



	while wait(5) do
	for i,plr in pairs(game.Players:GetPlayers()) do
	local banned, banData = bans.isBanned(plr.userId);
	if(banned) then
		local expiration = t.stampToTime(banData["expiration"]);
		local newMsg = "You are banned!\n\nExpiration: " .. expiration.month .. "/" .. expiration.day .. "/" .. expiration.year .. " at " .. expiration.hour .. ":" .. expiration.minute .. ":" .. expiration.second .. "\nReason: " .. banData["reason"];
		plr:Kick(newMsg);
	end
	end
	end
