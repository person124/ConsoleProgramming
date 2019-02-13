--[[
	This file is HEAVILY subject to change, in the current state exists
	only to get an idea of what rendering would look like
--]]

map = {}

function map.load()
	map.width = 3
	map.height = 5

	map.tiles = {}
	for i=1,map.width do
		map.tiles[i] = {}
		for j=1,map.height do
			map.tiles[i][j] = "test"
		end
	end

	map.entities = {}
	map.addEntity(entity["unit"])
	map.entities[1].x = 2
end

function map.render()
	for x=1,map.width do
		for y=1,map.height do
			tiles.render(map.tiles[x][y], (x - 1) * 64, (y - 1) * 64)
		end
	end

	for i=1,table.getn(map.entities) do
		entity.render(map.entities[i])
	end
end

function map.addEntity(ent)
	table.insert(map.entities, entity.copy(ent))
end