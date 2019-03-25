local map = {}

-- Setting map size
map.width = 5
map.height = 5

-- Setting map tiles
map.tileFilesToLoad = {}
map.tileFilesToLoad[1] = "assets/example_tile"

map.tiles = {}
for i=1,map.width do
	map.tiles[i] = {}
	for j=1,map.height do
		map.tiles[i][j] = "grass"
	end
end
map.tiles[3][4] = "wall"
map.tiles[3][2] = "wall"
map.tiles[3][3] = "wall"
map.tiles[2][3] = "wall"
map.tiles[4][3] = "wall"

-- Setting map entities
map.entityFilesToLoad = {}
map.entityFilesToLoad[1] = "assets/example_entity"

map.entities = {}
map.entities[1] = {}
map.entities[1].id = "unit"
map.entities[1].x = 3
map.entities[1].y = 1

map.entities[2] = {}
map.entities[2].id = "unit_enemy"
map.entities[2].x = 3
map.entities[2].y = 5

return map