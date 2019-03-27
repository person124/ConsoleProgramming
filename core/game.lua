local game = {}

-- This function will generate a new turn based on map data
local function generateTurn()
	-- 1) Clear the turn table
	-- 2) Get the list of player entities
	-- 3) Get the list of enemy entities
	-- 4) Set other turn variables

	-- 1)
	game.turn = {}

	-- 2) and 3)
	game.turn.player = {}
	game.turn.enemy = {}
	for i=1,table.getn(game.map.entities) do
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

	-- TODO add win condition here
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
	utils.removeDeadEntities(game.turn.player)

	utils.removeDeadEntities(game.turn.enemy)
end

function game.load()
	game.map = require("core/map")
	game.loadMap("test_map")

	-- Generate the first turn
	generateTurn()
end

-- The main update function for game loop
-- Used only during the enemies turn
function game.update(dt)
	-- If its the player's turn the leave
	if game.turn.isPlayerTurn then return end

	local turn = game.turn

	-- TODO
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
			-- Wait time is three seconds
			turn.waitTime = 3
		else
			if not turn.enemyMoved then
				-- 4)
				ai.enemyBasic(game.map, turn.enemyUnit, turn.player)
				-- Clear any dead enemies/player entities
				pruneDeadEntities()

				-- 5)
				-- Wait time is three seconds
				turn.waitTime = 3
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

	getTexturesInstance().loadFile(path .. "textures.dat", path .. "assets/")
	getTilesInstance().loadFile(path .. "tile")
	getEntitiesInstance().loadFile(path .. "entity")
	game.map.loadFile(path .. "map")
end

return game