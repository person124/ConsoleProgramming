local audio = {}

-- Loads in the audio files specified in the file
-- audio.dat located in the assets folder
function audio.load()
	local skip = false -- variable to skip the first line of tile

	-- Go through each line of the file
	for line in love.filesystem.lines("assets/audio.dat") do
		if skip then
			-- Find the space in the line
			local i = string.find(line, "")

			-- Seperate the line into name and path
			local name = string.sub(line, 1, i - 1)
			local path = string.sub(line, i + 1, -1)

			-- Load the audio and save it
			-- TODO add ability to load in streamed audio
			audio[name] = love.audio.newSource("assets/" .. path)
		else
			skip = true
		end
	end
end

return audio