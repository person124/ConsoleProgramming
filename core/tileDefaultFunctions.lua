--[[
	This file contains the default functions for tiles. If the function isn't replaced these
	are the fallbacks
--]]

local funcs = {}

function funcs.onEnter(map, tileX, tileY, entity)
end
function funcs.onExit(map, tileX, tileY, entity, newX, newY)
end
function funcs.onDeathOn(map, tileX, tileY, entity)
end
function funcs.onStay(map, tileX, tileY, entity)
end

return funcs