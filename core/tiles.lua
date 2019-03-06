local tiles = {}

-- create a tile with the specified data
-- quad can be nil
-- id is the internal name
-- name is the human name
local function createTile(isInternal, id, name, isSolid, texture, quad)
	local tile = {}

	tile.const = {}
	tile.const.builtIn = isInternal
	tile.const.id = id
	tile.const.name = name
	utils.protect(tile.const)

	tile.isSolid = isSolid
	tile.texture = texture
	tile.quad = quad

	tiles[tile.const.id] = tile
end

-- This is where the built in tiles will be loaded as well as any other
-- needed settings or information
function tiles.load()
	tiles.loadFile("assets/example_tile", true)
end

-- This will load tile(s) from a file, if the second parameter is true
-- Than the tiles will be marked as built in ones and not deleted on refresh
function tiles.loadFile(fileName, isBuiltIn)
	local loadedFile = require(fileName)

	local builtIn = false
	if isBuiltIn ~= nil then
		builtIn = isBuiltIn
	end

	for i=1,table.getn(loadedFile) do
		local tile = loadedFile[i]

		-- Check the tile data
		assert(tile.id ~= nil, "No ID set for " .. fileName)
		assert(tile.name ~= nil, "No name set for " .. fileName)
		assert(tile.isSolid ~= nil, "No solidity set for " .. fileName)
		assert(tile.texture ~= nil, "No texture set for " .. fileName)

		-- If the tile has quad data then use it
		local quad = nil
		if tile.quad ~= nil then
			local x = tile.quad.x * 64
			local y = tile.quad.y * 64
			local width = getTexture(tile.quad.texture):getWidth()
			local height = getTexture(tile.quad.texture):getHeight()

			quad = love.graphics.newQuad(x, y, 64, 64, width, height)
		end

		-- If it passes, then create tile
		createTile(builtIn, tile.id, tile.name, tile.isSolid, tile.texture, quad)
	end
end

-- TODO Rework!
-- render the specified tile at the specified location
function tiles.render(tile, xPos, yPos, screen)
	-- Calculate the positon of the tile including screen offsets
	local adjX = (xPos - 1) * 64
	local adjY = (yPos - 1) * 64

	adjX = adjX - screen.offset.x
	adjY = adjY - screen.offset.y

	-- If the tile has a quad then render it using it, otherwise render normally
	if not tile.quad then
		love.graphics.draw(getTexture(tile.texture), adjX, adjY)
	else
		love.graphics.draw(getTexture(tile.texture), tile.quad, adjX, adjY)
	end
end

return tiles