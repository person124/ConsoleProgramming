local game = {}

-- This function will generate a new turn based on map data
local function generateTurn()
	-- 1) Clear the turn table
	-- 2) Get the list of player entities
	-- 3) Get the list of enemy entities
	-- 4) Set player turn to true

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
			
			-- 2)
			local ent = map.getEntity(tileX, tileY)
			if ent ~= nil and utils.containsPoint(map.attackTiles, point) then
				-- Call attack function
				ai.basicAttack(map, map.currentlySelected, ent, map.movementTiles)
				map.clearSelection()
				return
			end
			
			-- 3)
			if utils.containsPoint(map.movementTiles, point) then
				-- Move the entity
				map.moveEntity(map.currentlySelected, tileX, tileY)
				map.clearSelection()
				return
			end
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

function game.load()
	game.map = require("core/map")
	game.map.load()
	
	-- Generate the first turn
	generateTurn()
end

function game.tapTile(tileX, tileY)
	-- Check to see if it is the player's turn
	-- If not then do nothing

	if game.turn.isPlayerTurn then
		tapTileInternal(tileX, tileY)
	end
end

function game.render(screen)
	game.map.render(screen)
end

return game