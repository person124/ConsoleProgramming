local game = {}

-- List of animations for the map
local animationsList = {}

-- This function will generate a new turn based on map data
local function generateTurn()
	-- 1) Clear the turn table
	-- 2) Get the list of player entities
	-- 3) Get the list of enemy entities
	-- 3.5) Reset entity stats
	-- 4) Set other turn variables

	-- 1)
	game.turn = {}

	-- 2) and 3)
	game.turn.player = {}
	game.turn.enemy = {}
	for i=1,table.getn(game.map.entities) do
		-- 3.5)
		local ent = game.map.entities[i]
		ent.at = ent.stats.at
		ent.sp = ent.stats.sp
		ent.rn = ent.stats.rn

		if game.map.entities[i].isEnemy then
			table.insert(game.turn.enemy, game.map.entities[i])
		else
			table.insert(game.turn.player, game.map.entities[i])
		end
	end

	-- 4)
	game.turn.isPlayerTurn = true
	game.turn.usedEntities = {}
	game.turn.enemyUnit = nil
	game.turn.enemyMoved = false
	game.turn.waitTime = 0

	if table.getn(game.turn.enemy) == 0 then
		-- Player Won
		endGame(true)
	elseif table.getn(game.turn.player) == 0 then
		-- Player Lost
		endGame(false)
	end
end

function game.start(fileName)
	game.map = require("core/gameplay/map")
	game.loadMap(fileName)

	-- Generate the first turn
	generateTurn()
end

function game.getAnimations()
	return animationsList
end

-- This function is the internal function to manage the player
-- Tapping on a tile
local function tapTileInternal(tileX, tileY)
	local map = game.map

	-- Steps:
	-- 1) Check if in range
	-- 2) See if attacking
	-- 3) See if moving
	-- 4) See if selecting
	-- 5) Otherwise clear selection

	-- 1)
	if tileX > 0 and tileY > 0 and tileX <= map.width and tileY <= map.height then
		-- Check if something is currently selected
		if map.currentlySelected ~= nil and not map.currentlySelected.isEnemy then
			local point = utils.getPoint(tileX, tileY)

			local ent = map.getEntity(tileX, tileY)
			-- This if checks to see if the entity has already moved
			if not utils.containsObject(game.turn.usedEntities, map.currentlySelected) then

			-- 2)
			if ent ~= nil and utils.containsPoint(map.attackTiles, point) then
				-- Add entity to the list of used entities
				table.insert(game.turn.usedEntities, map.currentlySelected)
				-- Call attack function
				ai.basicAttack(map, map.currentlySelected, ent, map.movementTiles)
				map.clearSelection()
				return
			end

			-- 3)
			if utils.containsPoint(map.movementTiles, point) then
				-- Add entity to the list of used entities
				table.insert(game.turn.usedEntities, map.currentlySelected)
				-- Move the entity
				map.moveEntity(map.currentlySelected, tileX, tileY)
				map.clearSelection()
				return
			end

			end -- Matches the contains object if
		end

		-- 4)
		for i=1,table.getn(map.entities) do
			if map.entities[i].x == tileX and map.entities[i].y == tileY then
				map.currentlySelected = map.entities[i]

				if not map.currentlySelected.isEnemy then
					map.movementTiles, map.attackTiles = ai.plan(map, map.entities[i])
				else
					map.movementTiles = {}
					map.attackTiles = {}
				end

				return
			end
		end
	end

	-- 5)
	map.clearSelection()
end

local function pruneDeadEntities()
	-- If an entity is dead then call the tile function
	for i=1,table.getn(game.map.entities) do
		if game.map.entities[i].hp <= 0 then
			local x = game.map.entities[i].x
			local y = game.map.entities[i].y
			game.map.tiles[x][y].funcs.onDeathOn(
				game.map,
				x,
				y,
				game.map.entities[i])

			-- Also send the entities function
			game.map.entities[i]:onDeath()
		end
	end

	-- Prune turn players
	utils.removeDeadEntities(game.turn.player)

	-- Prune turn enemies
	utils.removeDeadEntities(game.turn.enemy)

	-- Prune list of enemies
	utils.removeDeadEntities(game.map.entities)
end

-- The main update function for game loop
-- Used only during the enemies turn
function game.update(dt)
	-- Update animations list
	getAnimationsInstance().update(dt, animationsList)

	-- If its the player's turn the leave
	if game.turn.isPlayerTurn then return end

	local turn = game.turn

	-- Steps:
	-- 1) Get the first enemy in the list
	-- 2) Set the offset view to them
	-- 3) Pause for a bit
	-- 4) Update them
	-- 5) Pause for a bit
	-- 6) Remove enemy from the list
	-- 7) Repeat until empty
	-- 8) Re-generate the turn

	if turn.waitTime <= 0 then
		if turn.enemyUnit == nil then
			-- 7)
			if table.getn(turn.enemy) == 0 then
				-- 8)
				generateTurn()
				return
			end

			-- 1)
			turn.enemyUnit = turn.enemy[1]

			-- 2)
			local x = turn.enemyUnit.x
			local y = turn.enemyUnit.y
			getScreenInstance().setOffset(x, y)

			-- 3)
			-- Wait time is 1.5 seconds
			turn.waitTime = 1.5
		else
			if not turn.enemyMoved then
				-- 4)
				ai.enemyBasic(game.map, turn.enemyUnit, turn.player)
				-- Clear any dead enemies/player entities
				pruneDeadEntities()

				-- 5)
				-- Wait time is 1.5 seconds
				turn.waitTime = 1.5
				turn.enemyMoved = true
			else
				-- 6)
				turn.enemyUnit = nil
				table.remove(turn.enemy, 1)
				turn.enemyMoved = false
			end
		end
	else
		turn.waitTime = turn.waitTime - dt
	end
end

function game.tapTile(tileX, tileY)
	-- Check to see if it is the player's turn
	-- If not then do nothing

	if game.turn.isPlayerTurn then
		tapTileInternal(tileX, tileY)

		-- Check to see if the turn is done
		if table.getn(game.turn.player) == table.getn(game.turn.usedEntities) then
			-- If both tables are the same size then the player's turn is done
			game.turn.isPlayerTurn = false

			-- Check and remove dead entities
			pruneDeadEntities()
		end
	end
end

function game.render(screen)
	game.map.render(screen)

	if not game.turn.isPlayerTurn then
		love.graphics.setColor(255, 0, 0)
		love.graphics.rectangle("fill", 0, 0, screen.baseWidth, 33)
		love.graphics.setColor(0, 0, 255)
		love.graphics.print("Enemy Turn!")
	end
end

function game.loadMap(folderName)
	local path = "maps/" .. folderName

	if not love.filesystem.isDirectory(path) then return false end

	path = path .. "/"

	-- Load in textures
	if love.filesystem.exists(path .. "textures.dat") then
		getTexturesInstance().loadFile(path .. "textures.dat", path .. "assets/")
	else
		assert(false, "Error! No textures.dat found for map: " .. folderName)
	end

	-- Load in animations
	animationsList = {}
	if love.filesystem.exists(path .. "anim.lua") then
		animationsList = getAnimationsInstance().loadFile(path .. "anim")
	else
		print("No anim.lua found for map: " .. folderName .. ". Skipping")
	end

	-- Load in audio
	if love.filesystem.exists(path .. "audio.dat") then
		getAudioInstance().loadFile(path .. "audio.dat", path .. "assets/")
	else
		print("No audio.dat found for map: " .. folderName .. ". Skipping")
	end

	-- Load in tiles
	if love.filesystem.exists(path .. "tile.lua") then
		getTilesInstance().loadFile(path .. "tile", animationsList)
	else
		assert(false, "Error! No tile.lua found for map: " .. folderName)
	end

	-- Load in entities
	if love.filesystem.exists(path .. "entity.lua") then
		getEntitiesInstance().loadFile(path .. "entity", animationsList)
	else
		assert(false, "Error! No entity.lua found for map: " .. folderName)
	end

	-- Load in the map
	if love.filesystem.exists(path .. "map.lua") then
		game.map.loadFile(path .. "map")
	else
		assert(false, "Error! No map.lua found for map: " .. folderName)
	end

	return true
end

return game