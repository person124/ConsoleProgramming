tiles = {}

-- create a tile with the specified data
-- quad can be nil
-- id is the internal name
-- name is the human name
local function createTile(id, name, texture, quad)
	local tile = {}
	tile.id = id
	tile.name = name
	tile.texture = texture
	tile.quad = quad
	tiles[tile.id] = tile
end

-- This is where example tiles will be created, this bit will most likely
-- be removed later and replaced with a more auto-loading method
function tiles.load()
	createTile("test", "Test", "test")
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