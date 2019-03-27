local textures = {}

-- This functions loads in the default sprite files
function textures.load()
	-- Generates tables to store textures in
	textures.builtIn = {}
	textures.data = {}

	-- Load in the default textures
	textures.loadFile("assets/textures.dat", true)
end

function textures.loadFile(fileName, builtIn)
	local skip = false --variable to skip first line of file

	-- Go through each line of the file
	for line in love.filesystem.lines(fileName) do
		if skip then
			-- Find where the space is
			local i = string.find(line, " ")

			-- Seperate out the line into the name and path
			local name = string.sub(line, 1, i - 1)
			local path = string.sub(line, i + 1, -1)

			assert(textures.data[name] == nil or textures.builtIn[name] == nil,
				"ERROR texture: " .. name .. " already exists!!!")

			-- Load the texture and save it
			if builtIn == nil then
				textures.data[name] = love.graphics.newImage(path)
			else
				textures.builtIn[name] = love.graphics.newImage("assets/" .. path)
			end
		else
			skip = true -- This makes sure it skips the first line
		end
	end
end

function textures.get(id)
	local result = textures.data[id]

	if result ~= nil then return result
	else return textures.builtIn[id] end
end

return textures