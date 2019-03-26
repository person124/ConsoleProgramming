local textures = {}

-- This functions loads in the default sprite files
function textures.load()
	textures.loadFile("assets/textures.dat")
end

function textures.loadFile(fileName)
	local skip = false --variable to skip first line of file

	-- Go through each line of the file
	for line in love.filesystem.lines(fileName) do
		if skip then
			-- Find where the space is
			local i = string.find(line, " ")

			-- Seperate out the line into the name and path
			local name = string.sub(line, 1, i - 1)
			local path = string.sub(line, i + 1, -1)

			assert(textures[name] == nil, "ERROR texture: " .. name .. " already exists!!!")

			-- Load the texture and save it
			textures[name] = love.graphics.newImage("assets/" .. path)
		else
			skip = true -- This makes sure it skips the first line
		end
	end
end

return textures