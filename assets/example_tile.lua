-- this is an example tile file format
local tileData = {}

local tile = {}
tile.id = "test"
tile.name = "Test"
tile.isSolid = false
tile.texture = "test"
table.insert(tileData, tile)

return tileData