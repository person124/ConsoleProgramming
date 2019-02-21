tiles = {}

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
	protect(tile.const)

	tile.isSolid = isSolid
	tile.texture = texture
	tile.quad = quad

	tiles[tile.const.id] = tile
end

-- This is where example tiles will be created, this bit will most likely
-- be removed later and replaced with a more auto-loading method
function tiles.load()
	tiles.loadFile("assets/example_tile", true)
end

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
			local width = textures[tile.quad.texture]:getWidth()
			local height = textures[tile.quad.texture]:getHeight()
			
			quad = love.graphics.newQuad(x, y, 64, 64, width, height)
		end
		
		-- If it passes, then create tile
		createTile(builtIn, tile.id, tile.name, tile.isSolid, tile.texture, quad)
	end
end

-- render the tile with specified id at the specified location
function tiles.render(id, xPos, yPos)
	-- Checks to make sure an id was passed at all
	if id == nil then return end

	local tile = tiles[id]

	-- Checks to make sure a tile exists at that point
	if not tile then return end

	-- Calculate the positon of the tile including screen offsets
	xPos = xPos - screen.offset.x
	yPos = yPos - screen.offset.y

	-- If the tile has a quad then render it using it, otherwise render normally
	if not tile.quad then
		love.graphics.draw(textures[tile.texture], xPos, yPos)
	else
		love.graphics.draw(textures[tile.texture], tile.quad, xPos, yPos)
	end
end