bans = {};

lib = require(game.ReplicatedStorage.Library);
timeMod = require(game.ReplicatedStorage.TimeModule);

ds = game:GetService("DataStoreService");
bs = ds:GetDataStore("Bans");

bans.verifyTable = function()
	--Make sure that the table exists
	local old = bs:GetAsync("BanTable");
	while(not old) do
		bs:SetAsync("BanTable", {});
		old = bs:GetAsync("BanTable");
		wait();
	end
end

bans.get = function()
	bans.verifyTable();
	local filtered = {};
	local unfiltered = bs:GetAsync("BanTable");
	for name, data in pairs(unfiltered) do
		if(tonumber(data[1]) > tick()) then
			filtered[name] = data;
		end
	end
	return filtered;
end

bans.playerData = function(name)
	if(name) then
		local data = bans.get();
		for plrName, plrData in pairs(data) do
			if(plrName == name and plrData[1] and plrData[2]) then
				return plrName, plrData;
			end
		end
	end
	return nil, nil;
end

bans.isBanned = function(name)
	if(name) then
		local plrName, plrData = bans.playerData(name);
		if(plrName and plrData) then
			if(tonumber(plrData[1]) > tick()) then
				return true;
			end
		end
	end
	return false;
end

bans.getExpiration = function(name)
	if(name) then
		local name, plrData = bans.playerData(name);
		if(plrData) then
			return plrData[1];
		end
	end
	return nil;
end

bans.getReason = function(name)
	if(name) then
		local name, plrData = bans.playerData(name);
		if(plrData) then
			return plrData[2];
		end
	end
end

--String name, int days, String reason
bans.banPlayer = function(name, days, reason)
	if(name and days and reason) then
		local old = bans.get();
		bs:UpdateAsync("BanTable", function()
			local now = tick();
			local daysInSeconds = 86400 * days;
			local new = now + daysInSeconds;
			
			old[name] = {new, reason};
			return old;
		end)
	end
end

bans.unbanPlayer = function(name)
	if(name) then
		if(bans.isBanned(name)) then
			local data = bans.get();
			bs:UpdateAsync("BanTable", function()
				data[name] = {0, "Not banned!"};
				return data;
			end)
		end
	end
end

return bans;