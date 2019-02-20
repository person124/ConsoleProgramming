entity = {}

-- This functions allows the creation of protected tables
-- On use will make a table write only
-- http://andrejs-cainikovs.blogspot.com/2009/05/lua-constants.html
local function protect(tbl)
	return setmetatable({}, {
		__index = tbl,
		__newindex = function(t, key, value)
			error("attempting to change constant " ..
				tostring(key) .. " to " .. tostring(value), 2)
		end
	})
end

-- Loads in built-in entities
function entity.load()
	entity.create("unit", 10, 5, 2, 1, "unit")
end

-- Creates an entity with specified data
-- id is internal name
function entity.create(id, health, attack, speed, range, texture)
	entity[id] = {}

	entity[id].stats = {}
	entity[id].stats.hp = health
	entity[id].stats.at = attack
	entity[id].stats.sp = speed
	entity[id].stats.rn = range
	entity[id].stats = protect(entity[id].stats)

	entity[id].hp = health
	entity[id].at = attack
	entity[id].sp = speed
	entity[id].rn = range

	entity[id].texture = texture

	entity[id].x = 0
	entity[id].y = 0
end

-- Draws the specified entity at the entities location
function entity.render(ent)
	xPos = ((ent.x - 1) * 64) - screen.offset.x
	yPos = ((ent.y - 1) * 64) - screen.offset.y

	love.graphics.draw(textures[ent.texture], xPos, yPos)
end

-- Copys the given entity and returns the copy
function entity.copy(ent)
	local entCopy = {}
	entCopy.hp = ent.hp
	entCopy.at = ent.at
	entCopy.sp = ent.sp
	entCopy.rn = ent.rn

	entCopy.texture = ent.texture

	entCopy.x = ent.x
	entCopy.y = ent.y

	return entCopy
end