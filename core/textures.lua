textures = {}

-- This functions loads in images as specified in the file
-- textures.dat located in the assets folder
function textures.load()
	local skip = false --variable to skip first line of file

	-- Go through each line of the file
	for line in love.filesystem.lines("assets/textures.dat") do
		if skip then
			-- Find where the space is
			local i = string.find(line, " ")

			-- Seperate out the line into the name and path
			local name = string.sub(line, 1, i - 1)
			local path = string.sub(line, i + 1, -1)

			-- Load the texture and save it
			textures[name] = love.graphics.newImage("assets/" .. path)
		else
			skip = true -- This makes sure it skips the first line
		end
	end
end