-- this is an example tile file format
local tileData = {}

local tile = {}
tile.id = "grass"
tile.name = "Grass"
tile.isSolid = false
tile.anim = "tile_grass"
table.insert(tileData, tile)

tile = {}
tile.id = "wall"
tile.name = "Wall"
tile.isSolid = true
tile.anim = "tile_wall"
table.insert(tileData, tile)

tile = {}
tile.id = "carpet"
tile.name = "Carpet"
tile.isSolid = false
tile.anim = "tile_carpet"
table.insert(tileData, tile)

tile = {}
tile.id = "wood"
tile.name = "Wood"
tile.isSolid = false
tile.anim = "tile_wood"
table.insert(tileData, tile)

tile = {}
tile.id = "pillar"
tile.name = "Pillar"
tile.isSolid = true
tile.anim = "tile_pillar"
table.insert(tileData, tile)

return tileData