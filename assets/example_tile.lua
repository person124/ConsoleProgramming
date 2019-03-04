-- this is an example tile file format
local tileData = {}

local tile = {}
tile.id = "test"
tile.name = "Test"
tile.isSolid = false
tile.texture = "test"
table.insert(tileData, tile)

tile = {}
tile.id = "grass"
tile.name = "Grass"
tile.isSolid = false
tile.texture = "grass"
table.insert(tileData, tile)

tile = {}
tile.id = "wall"
tile.name = "Wall"
tile.isSolid = true
tile.texture = "wall"
table.insert(tileData, tile)

return tileData