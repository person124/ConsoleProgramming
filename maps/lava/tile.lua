-- this is an example tile file format
local tileData = {}

local tile = {}
tile.id = "grass"
tile.isSolid = false
tile.anim = "tile_grass"
table.insert(tileData, tile)

tile = {}
tile.id = "wall"
tile.isSolid = true
tile.anim = "tile_wall"
table.insert(tileData, tile)

tile = {}
tile.id = "lava"
tile.isSolid = false
tile.anim = "tile_lava"
tile.funcs = {}
tile.funcs.onEnter = function(map, tileX, tileY, entity)
	entity.hp = entity.hp - 1
end
table.insert(tileData, tile)

return tileData