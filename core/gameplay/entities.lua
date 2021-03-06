--[[
	This file contains the information/functions that entity need to use for loading and such
--]]

local entity = {}

local entityDefaultFuncs = require("core/entityDefaultFunctions")

-- Creates entity table
function entity.load()
	entity.data = {}
	entity.count = 0
end

function entity.loadFile(fileName, animationsList)
	local loadedFile = require(fileName)

	for i=1,table.getn(loadedFile) do
		local e = loadedFile[i]

		-- Check to make sure the vital data exists
		assert(e.id ~= nil, "No ID set for " .. fileName)
		assert(e.hp ~= nil, "No health set for " .. fileName)
		assert(e.at ~= nil, "No attack set for " .. fileName)
		assert(e.sp ~= nil, "No speed set for " .. fileName)
		assert(e.rn ~= nil, "No range set for " .. fileName)
		assert(e.anim ~= nil, "No animation set for " .. fileName)

		local anim = animationsList[e.anim]

		entity.create(e.id, e.hp, e.at, e.sp, e.rn, anim, e.funcs)

		if e.isEnemy ~= nil then
			entity.data[e.id].isEnemy = e.isEnemy
		end
	end
end

-- Clears the list of entities
function entity.clear()
	entity.data = {}
	entity.count = 0
end

-- Creates an entity with specified data
-- id is internal name
function entity.create(id, health, attack, speed, range, anim, funcs)
	local ent = {}

	-- Default entity stats (utils.protected)
	ent.stats = {}
	ent.stats.id = id
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

	-- The animation of the entity
	ent.anim = anim

	-- The position of the entity
	ent.x = 0
	ent.y = 0

	-- Entity Functions
	local funcsToUse = utils.mergeFunctions(entityDefaultFuncs, funcs)
	for i in pairs(funcsToUse) do
		ent[i] = funcsToUse[i]
	end

	entity.data[id] = ent
	entity.count = entity.count + 1
end

-- Draws the specified entity at the entities location
function entity.render(ent, screen)
	local xPos = ((ent.x - 1) * 64) - screen.offset.x
	local yPos = ((ent.y - 1) * 64) - screen.offset.y

	love.graphics.draw(getTexture(ent.anim.info.sheet),
		ent.anim:getFrame(), xPos, yPos)
end

-- Copys the given entity and returns the copy
function entity.copy(ent)
	local entCopy = {}

	for i in pairs(ent) do
		entCopy[i] = ent[i]
	end

	return entCopy
end

return entity