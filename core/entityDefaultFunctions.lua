--[[
	This file contains the default functions for entities. If the function isn't replaced these
	are the fallbacks
--]]

local funcs = {}

function funcs.damage(self, target, amount)
	target:hurt(amount)

	if target.hp <= 0 then
		self:onKill(target)
	end
end

function funcs.hurt(self, amount)
	self.hp = self.hp - amount
end

function funcs.onMove(self, map, origX, origY, newX, newY)
	self.x = newX
	self.y = newY
end

function funcs.onKill(self, target)

end

function funcs.onDeath(self)

end

return funcs