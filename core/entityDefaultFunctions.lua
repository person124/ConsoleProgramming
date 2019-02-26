--[[
	This file contains the default functions for entities. If the function isn't replaced these
	are the fallbacks
--]]

local funcs = {}

function funcs.damage(attacker, target, amount)
	target.hp = target.hp - amount
end

return funcs