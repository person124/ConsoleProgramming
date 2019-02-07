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

function tiles.load()
	createTile("test", "Test", "test", nil)
end

-- render the tile with specified id at the specified location
function tiles.render(id, xPos, yPos)
	local tile = tiles[id]

	if not tile then return end

	xPos = xPos - screen.offset.x
	yPos = yPos - screen.offset.y

	if not tile.quad then
		love.graphics.draw(textures[tile.texture], xPos, yPos)
	else
		love.graphics.draw(textures[tile.texture], tile.quad, xPos, yPos)
	end
end