--[[
	This file contains the information/functions that entity need to use for loading and such
--]]

local entity = {}

local entityDefaultFuncs = require("core/entityDefaultFunctions")

-- Loads in built-in entities
function entity.load()
	entity.create("unit", 10, 5, 2, 1, "unit")
end

-- Creates an entity with specified data
-- id is internal name
function entity.create(id, health, attack, speed, range, texture)
	entity[id] = {}

	-- Default entity stats (utils.protected)
	entity[id].stats = {}
	entity[id].stats.hp = health
	entity[id].stats.at = attack
	entity[id].stats.sp = speed
	entity[id].stats.rn = range
	entity[id].stats = utils.protect(entity[id].stats)

	-- Applied entity stats
	entity[id].hp = health
	entity[id].at = attack
	entity[id].sp = speed
	entity[id].rn = range
	
	-- Is the entity not on the player's team
	entity[id].isEnemy = false

	-- The texture of the entity
	entity[id].texture = texture

	-- The position of the entity
	entity[id].x = 0
	entity[id].y = 0
	
	-- Entity Functions
	entity[id].funcs = entityDefaultFuncs
	entity[id].funcs = utils.protect(entity[id].funcs)
end

-- Draws the specified entity at the entities location
function entity.render(ent, screen)
	xPos = ((ent.x - 1) * 64) - screen.offset.x
	yPos = ((ent.y - 1) * 64) - screen.offset.y

	love.graphics.draw(getTexture(ent.texture), xPos, yPos)
end

-- Copys the given entity and returns the copy
function entity.copy(ent)
	local entCopy = {}
	
	entCopy.stats = ent.stats
	entCopy.hp = ent.hp
	entCopy.at = ent.at
	entCopy.sp = ent.sp
	entCopy.rn = ent.rn
	
	entCopy.isEnemy = ent.isEnemy

	entCopy.texture = ent.texture

	entCopy.x = ent.x
	entCopy.y = ent.y
	
	entCopy.funcs = ent.funcs

	return entCopy
end

return entity