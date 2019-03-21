local audio = {}

-- Loads in the audio files specified in the file
-- audio.dat located in the assets folder
function audio.load()
	local skip = false -- variable to skip the first line of tile

	-- Go through each line of the file
	for line in love.filesystem.lines("assets/audio.dat") do
		if skip then
			-- Split the string
			local split = string.gmatch(line, "%S+")

			-- Get the data from the split string
			local name = split()
			local streamType = split()
			local path = split()

			-- Generates a love audio source
			audio[name] = love.audio.newSource("assets/" .. path, streamType)
		else
			skip = true
		end
	end
end

-- Plays the specififed audio file
function audio.play(id)
	if audio[id] ~= nil then
		love.audio.play(audio[id])
	end
end

-- Pauses all audio or the specified audio file
function audio.pause(id)
	if id == nil then
		love.audio.pause()
	elseif audio[id] ~= nil then
		love.audio.pause(audio[id])
	end
end

return audio