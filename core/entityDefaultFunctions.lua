--[[
	This file contains the default functions for entities. If the function isn't replaced these
	are the fallbacks
--]]

local funcs = {}

function funcs.damage(self, target, amount)
	target:hurt(amount)
end

function funcs.hurt(self, amount)
	self.hp = self.hp - amount
end

return funcs