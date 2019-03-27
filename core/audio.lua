local audio = {}

-- Loads in the audio files specified in the file
-- audio.dat located in the assets folder
function audio.load()
	audio.builtIn = {}
	audio.data = {}

	love.audio.setDistanceModel("none")

	audio.loadFile("assets/audio.dat", "assets/", true)
end

function audio.loadFile(fileName, basePath, builtIn)
	local skip = false -- variable to skip the first line of tile

	-- Go through each line of the file
	for line in love.filesystem.lines("assets/audio.dat") do
		if skip then
			-- Split the string
			local split = string.gmatch(line, "%S+")

			-- Get the data from the split string
			local name = split()
			local streamType = split()
			local loops = split()
			local path = split()

			assert(audio.data[name] == nil and audio.builtIn[name] == nil,
				"ERROR audio file: " .. name .. " already exists!!!")

			local loopBool = (loops == "true")
			-- Generates a love audio source
			if builtIn == nil then
				audio.data[name] = love.audio.newSource(basePath .. path, streamType)
				audio.data[name]:setLooping(loopBool)
			else
				audio.builtIn[name] = love.audio.newSource(basePath .. path, streamType)
				audio.builtIn[name]:setLooping(loopBool)
			end
		else
			skip = true
		end
	end
end

-- Plays the specififed audio file
function audio.play(id)
	local a = audio.get(id)
	if a ~= nil then
		love.audio.play(a)
	end
end

-- Pauses all audio or the specified audio file
function audio.pause(id)
	if id == nil then
		love.audio.pause()
		return
	end

	local a = audio.get(id)
	if a ~= nil then
		love.audio.pause(a)
	end
end

-- Resumes all audio or the specified audio file
function audio.resume(id)
	if id == nil then
		love.audio.resume()
		return
	end

	local a = audio.get(id)
	if a ~= nil then
		love.audio.resume(a)
	end
end

-- Stops all audio or the specified audio file
function audio.stop(id)
	if id == nil then
		love.audio.stop()
		return
	end

	local a = audio.get(id)
	if a ~= nil then
		love.audio.stop(a)
	end
end

function audio.get(id)
	local result = audio.data[id]

	if result ~= nil then return result
	else return audio.builtIn[id] end
end

return audio