--[[
	This file contains the information/functions that entity need to use for loading and such
--]]

local entity = {}

local entityDefaultFuncs = require("core/entityDefaultFunctions")

-- Creates entity table
function entity.load()
	entity.data = {}
end

function entity.loadFile(fileName)
	local loadedFile = require(fileName)

	for i=1,table.getn(loadedFile) do
		local e = loadedFile[i]

		-- Check to make sure the vital data exists
		assert(e.id ~= nil, "No ID set for " .. fileName)
		assert(e.hp ~= nil, "No health set for " .. fileName)
		assert(e.at ~= nil, "No attack set for " .. fileName)
		assert(e.sp ~= nil, "No speed set for " .. fileName)
		assert(e.rn ~= nil, "No range set for " .. fileName)
		assert(e.texture ~= nil, "No texture set for " .. fileName)

		entity.create(e.id, e.hp, e.at, e.sp, e.rn, e.texture, e.funcs)

		if e.isEnemy ~= nil then
			entity.data[e.id].isEnemy = e.isEnemy
		end
	end
end

-- Clears the list of entities
function entity.clear()
	entity.data = {}
end

-- Creates an entity with specified data
-- id is internal name
function entity.create(id, health, attack, speed, range, texture, funcs)
	local ent = {}

	-- Default entity stats (utils.protected)
	ent.stats = {}
	ent.stats.hp = health
	ent.stats.at = attack
	ent.stats.sp = speed
	ent.stats.rn = range
	ent.stats = utils.protect(ent.stats)

	-- Applied entity stats
	ent.hp = health
	ent.at = attack
	ent.sp = speed
	ent.rn = range

	-- Is the entity not on the player's team
	ent.isEnemy = false

	-- The texture of the entity
	ent.texture = texture

	-- The position of the entity
	ent.x = 0
	ent.y = 0

	-- Entity Functions
	ent.funcs = utils.mergeFunctions(entityDefaultFuncs, funcs)
	ent.funcs = utils.protect(ent.funcs)

	entity.data[id] = ent
end

-- Draws the specified entity at the entities location
function entity.render(ent, screen)
	local xPos = ((ent.x - 1) * 64) - screen.offset.x
	local yPos = ((ent.y - 1) * 64) - screen.offset.y

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