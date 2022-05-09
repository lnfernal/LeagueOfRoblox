--this global holds the music
local Music
--these are the ids for songs in the game
local Songs = {
	CharacterSelect = 146868175,
	CharacterSelect2 = 179436066,
	Victory = 345842716,
	Defeat = 345842716,
	Battle1 = 143632950,
	Battle2 = 149130258,
}

--this function stops the music
local function stopMusic()
	if Music then
		Music:Destroy()
	end
end
script.StopMusic.Event:connect(stopMusic)

--this function plays a song from the list
local function playSong(songName)
	if not Songs[songName] then return end
	
	stopMusic()
	
	Music = Instance.new("Sound")
	Music.SoundId = "rbxassetid://"..Songs[songName]
	Music.Looped = true
	Music.Parent = Workspace
	Music:Play()
end
script.PlaySong.Event:connect(playSong)

--this function changes the volume
local function changeVolume(delta)
	if Music then
		Music.Volume = Music.Volume + delta
	end
end
script.ChangeVolume.Event:connect(changeVolume)

--this function prepares the music to stop when the character dies
local function stopMusicOnDeath()
	local player = Game.Players.LocalPlayer
	repeat wait() until player.Character
	player.Character:WaitForChild("Humanoid").Died:connect(function()
		stopMusic()
	end)
end

--this function allows volume changes with , and .
local function keyPresses()
	local mouse = Game.Players.LocalPlayer:GetMouse()
	mouse.KeyDown:connect(function(key)
		if key == "l" then
			changeVolume(0.1)
		end
		
		if key == "k" then
			changeVolume(-0.1)
		end
	end)
end

--prepare us to die!
stopMusicOnDeath()
keyPresses()
