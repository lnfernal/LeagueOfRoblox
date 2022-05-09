bm = {};

ds = game:GetService("DataStoreService"):GetDataStore("Bans");

bm.getBans = function(userId)
	local result;
	local success;
	local message;
	repeat success, message = pcall(function()
			result = ds:GetAsync(userId);
		end) if(not success) then wait(1) end
	until success;
	
	return result;
end

bm.ban = function(userId, days, reason)
	local previous = bm.getBans(userId);
	if(not previous) then
		previous = {};
	end
	
	local banData = {expiration = os.time() + (86400 * days),
		reason = reason,
		active = true
	};
	
	table.insert(previous, banData);
	
	local success;
	local message;
	
	repeat success, message = pcall(function()
			ds:SetAsync(userId, previous);
		end) if(not success) then wait(1) end
	until success;
end

bm.isBanned = function(userId)
	local history = bm.getBans(userId);
	
	if(not history) then
		return false, nil;
	else
		for i, ban in ipairs(history) do
			if(ban.expiration > os.time() and ban.active) then
				return true, ban;
			end
		end
	end
	
	return false, nil;
end

bm.unban = function(userId)
	local previous = bm.getBans(userId);
	
	if(not previous) then
		return;
	end
	
	for i, ban in ipairs(previous) do
		ban["active"] = false;
	end
	
	local success;
	local message;
	
	repeat success, message = pcall(function()
			ds:SetAsync(userId, previous);
		end) if(not success) then wait(1) end
	until success;
end

return bm;