-- this is an example tile file format
local tileData = {}

local tile = {}
tile.id = "grass"
tile.name = "Grass"
tile.isSolid = false
tile.anim = "tile_grass"
tile.funcs = {}
tile.funcs.onEnter = function(map, tileX, tileY, entity)
	print(tileX, tileY)
end
table.insert(tileData, tile)

tile = {}
tile.id = "wall"
tile.name = "Wall"
tile.isSolid = true
tile.anim = "tile_wall"
table.insert(tileData, tile)

return tileData