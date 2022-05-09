--[[
updates = {};

function addUpdate(d, msg, dev)
	table.insert(updates, {d, msg, dev});
end

addUpdate("April 1, 2016", "Game was reverted.", "Admins");
addUpdate("April 2, 2016", "Redid some backend updates.", "ProtectedMethod");
addUpdate("April 2, 2016", "Redid the purchase update thing.", "ProtectedMethod");
addUpdate("April 2, 2016", "Re-enabled MouseLockShift.", "ProtectedMethod");
addUpdate("April 2, 2016", "Re-enabled player points and lifetime kills.", "ProtectedMethod");
addUpdate("April 2, 2016", "Moved the character skin selection again and removed datastore spam.", "ProtectedMethod");
addUpdate("April 2, 2016", "Added newer, better admin commands! :D", "ProtectedMethod");
addUpdate("April 2, 2016", "Fixed speed glitching using mouselock and mouse tracking!!!", "ProtectedMethod");
addUpdate("April 2, 2016", "Decreased map vote time to 15 seconds.", "ProtectedMethod");
addUpdate("April 2, 2016", "Added back server version label.", "ProtectedMethod");
addUpdate("April 2, 2016", "Fixed +2 votes pass.", "ProtectedMethod");
addUpdate("April 3, 2016", "Minor updates.", "ProtectedMethod");
addUpdate("April 3, 2016", "Minor backend changes.", "ProtectedMethod");
addUpdate("April 3, 2016", "Changes to admin commands.", "ProtectedMethod");
addUpdate("April 3, 2016", "Yeet.", "ProtectedMethod");
addUpdate("April 7, 2016", "Added Ravaged Forest back into the game. Fixed map thumbnails.", "Llendlar");
addUpdate("April 8, 2016", "Minor MouselockShift update.", "ProtectedMethod");
addUpdate("April 8, 2016", "Entirely rewrote admin commands.", "ProtectedMethod");
addUpdate("April 8, 2016", "Made preparations for new map addition. Added different visual effects to heals.", "Llendlar");
addUpdate("April 8, 2016", "Added new map: Sacred Oasis.", "Llendlar");
addUpdate("April 9, 2016", "Made all characters free.", "ProtectedMethod");
addUpdate("April 9, 2016", "Made skins require player level.", "ProtectedMethod");
addUpdate("April 9, 2016", "Gave players extra map votes for player level.", "ProtectedMethod");
addUpdate("April 9, 2016", "Fixed healing glitch and back-end error.", "Llendlar");
addUpdate("April 9, 2016", "Reworked Wsly's kit.", "Llendlar");
addUpdate("April 9, 2016", "Buffed speedydude's 3 damage, but removed damage from 2 and decreased 2's slow duration.", "Llendlar");
addUpdate("April 9, 2016", "Reduced Matt's cooldowns. Buffed Matt's 4.", "Llendlar");
addUpdate("April 9, 2016", "Reduced Davidii's 3 cooldown, but reduced its slow duration. Increased the duration of Davidii's 4.", "Llendlar");
addUpdate("April 9, 2016", "Dekenus: Increased 1 push distance, increased 2 h4x scaling, decreased 3 stun duration, decreased 4 startup and slow duration", "Llendlar");
addUpdate("April 9, 2016", "ChiefJustus: Increased basic attack scaling, increased 3 skillz scaling", "Llendlar");
addUpdate("April 9, 2016", "Jacksmirkingrevenge: Decreased 3 cooldown slightly, increased 4 cooldown and stun duration.", "Llendlar");
addUpdate("April 9, 2016", "Reenacted player level requirements.", "ProtectedMethod");
addUpdate("April 9, 2016", "Added a couple new admin commands.", "ProtectedMethod");
addUpdate("April 9, 2016", "Added script to shutdown old servers at end of round.", "ProtectedMethod");
addUpdate("April 9, 2016", "Fixed professor.", "ProtectedMethod");
addUpdate("April 10, 2016", "Added new map: Ruins.", "TheTiredHippo");
addUpdate("April 10, 2016", "Added new shop.", "BLOXER787");
addUpdate("April 10, 2016", "Minions Re-Balnced", "BLOXER787");
addUpdate("April 10, 2016", "Item Limit and Level Limit Added", "LoR Dev Team");
addUpdate("April 10, 2016", "Leveling Tweaked", "LoR Dev Team");
addUpdate("April 10, 2016", "Reblanced Turrents Rewards", "LoR Dev Team");
addUpdate("April 10, 2016", "Removed Ruins from Map Rotation", "TheTiredHippo");
addUpdate("April 10, 2016", "Fixed Wsly.", "Llendlar");
addUpdate("April 10, 2016", "Restructured shop layout to make it easier to navigate.", "Llendlar");
addUpdate("April 10, 2016", "Added Robloxian Rift back in.", "Llendlar");
addUpdate("April 11, 2016", "Altered minion mechanics so that they are less likely to get flung.", "Llendlar");
addUpdate("April 11, 2016", "Removed Ruins and Robloxian Rift maps; it will be added back in once it has been modified to not have lag.", "Llendlar");
addUpdate("April 11, 2016", "Added in late game character balancing.", "ProtectedMethod");
addUpdate("April 12, 2016", "Reduced the range at which you can stand from minions to get xp and tix (from 64 to 50).", "Llendlar");
addUpdate("April 12, 2016", "Revised the late-joining balance system; you now only get 90% of the average tix and xp as opposed to 100%.", "Llendlar");
addUpdate("April 12, 2016", "Fixed minion flinging; should be a lot less buggy now..", "Llendlar");
addUpdate("April 17, 2016", "BLOXER787: Increased h4x scaling of 2 to 30%, increased ability level scaling of 3 to 8 per level and 45%.", "BLOXER787");
addUpdate("April 17, 2016", "BLOXER787: The 3 will now find a target and then wait .5 seconds to deal damage rather than waiting .5 seconds to find a target and deal damage.", "BLOXER787");
addUpdate("April 17, 2016", "pspjohn1: Increased the skillz scaling of the 1, increased base, ability level, and hp scaling of the 3, increased base, ability level, and bonus healing of the 4", "BLOXER787");
addUpdate("April 17, 2016", "Rebalanced the shop", "BLOXER787");
addUpdate("June 18, 2016", "Buffed golems; fixed circle farming and flinging golems.", "BLOXER787");
addUpdate("June 18, 2016", "BLOXER787 and The Professor now either require level up or previous purchase of pass.", "BLOXER787");
addUpdate("June 18, 2016", "EXP gains after win/loss decreased from 10/5 to 6/3.", "BLOXER787");
addUpdate("June 18, 2016", "Old update: Stats can no longer go negative.", "BLOXER787");
addUpdate("June 18, 2016", "Added a new character to the game, awesomehfhhr. Can be unlocked at level 20/old purchase of Developer's DLC.", "BLOXER787");
addUpdate("June 18, 2016", "Increased the player EXP needed to level up and unlocked new character to 4x player level (was 3x)", "BLOXER787");
addUpdate("June 19, 2016", "Added a new character to the game, Gingerbreadman. Can be unlocked at level 20/old purchase of Developer's DLC", "BaDShyGUy");
addUpdate("June 19, 2016", "Rebalanced awesomehfhhr", "BLOXER787");
addUpdate("June 22, 2016", "Changes to Gingerbreadman, he is supposed to be a Durable Sustain not a damage dealer.", "BaDShyGUy");
addUpdate("June 22, 2016", "Added a new character to the game, ColdArmada. Can be unlocked at level 19", "BLOXER787");
addUpdate("June 22, 2016", "Reworked the shop", "BLOXER787");
addUpdate("June 24, 2016", "Fixed Nightgaladeld's flag texture.", "BaDShyGUy");
addUpdate("June 25, 2016", "Added a new character to the game, Emma. Can be unlocked at level 17", "BLOXER787");
addUpdate("June 27, 2016", "Attempting to fix minion merging.", "BLOXER787");
addUpdate("June 30, 2016", "Hopefully fixed  one issue that prevented EXP gain, will need to do further testing to find out.", "BaDShyGUy");
addUpdate("July 3, 2016", "Added a new character to the game, InfinilixEverlasting. Can be unlocked at level 7", "BLOXER787");
addUpdate("July 3, 2016", "Added a new character to the game, Demaru. Can be unlocked at level 7", "BLOXER787");
addUpdate("July 7, 2016", "Added a new character to the game, ImAnAverageNormalMan. Can be unlocked at level 7", "BLOXER787");
addUpdate("July 7, 2016", "Added a new character to the game, swordninjGUy. Can be unlocked at level 22", "BLOXER787");
addUpdate("July 8, 2016", "Added an item limit into the game to prevent extreme farming, also to balance out HP tanks. Removed top tier defense items and HP.", "BaDShyGUy");
addUpdate("July 8, 2016", "A large amount of characters have been rebalanced/reworked, and more will come out every so often.", "BLOXER787");
addUpdate("July 9, 2016", "ClanAtlas can no longer heal his invincible minion, due to the fact it could stay alive forever.", "BaDShyGUy");
addUpdate("July 11, 2016", "All characters have been rebalanced/reworked. We will balance characters when needed.", "The (New) Balance Team");
addUpdate("August 7, 2016", "All characters roles have been updated and most of them have been buffed. Finally, turret durability has been nerfed.", "Dryswordmaster");
a = 1;
b = 0;
c = 0;

for i, update in ipairs(updates) do
	c = c + 1;
	if(c == 10) then
		c = 0;
		b = b + 1;
		if(b == 10) then
			b = 0;
			a = a + 1;
		end
	end
end

updates["v"] = tostring(a) .. "." .. tostring(b) .. tostring(c);

return updates;
]]