local map = {}
-- Map Size
map.width = 8
map.height = 8
-- Tile Setup
map.tiles = {}
for x=1,map.width do
map.tiles[x] = {}
end
-- Tile Data
map.tiles[1][1] = "wall"
map.tiles[1][2] = "wall"
map.tiles[1][3] = "wall"
map.tiles[1][4] = "wall"
map.tiles[1][5] = "wall"
map.tiles[1][6] = "wall"
map.tiles[1][7] = "wall"
map.tiles[1][8] = "wall"
map.tiles[2][1] = "wall"
map.tiles[2][2] = "grass"
map.tiles[2][3] = "lava"
map.tiles[2][4] = "wall"
map.tiles[2][5] = "grass"
map.tiles[2][6] = "grass"
map.tiles[2][7] = "grass"
map.tiles[2][8] = "wall"
map.tiles[3][1] = "wall"
map.tiles[3][2] = "lava"
map.tiles[3][3] = "lava"
map.tiles[3][4] = "lava"
map.tiles[3][5] = "grass"
map.tiles[3][6] = "grass"
map.tiles[3][7] = "grass"
map.tiles[3][8] = "wall"
map.tiles[4][1] = "wall"
map.tiles[4][2] = "wall"
map.tiles[4][3] = "lava"
map.tiles[4][4] = "lava"
map.tiles[4][5] = "lava"
map.tiles[4][6] = "grass"
map.tiles[4][7] = "grass"
map.tiles[4][8] = "wall"
map.tiles[5][1] = "wall"
map.tiles[5][2] = "grass"
map.tiles[5][3] = "grass"
map.tiles[5][4] = "lava"
map.tiles[5][5] = "lava"
map.tiles[5][6] = "lava"
map.tiles[5][7] = "wall"
map.tiles[5][8] = "wall"
map.tiles[6][1] = "wall"
map.tiles[6][2] = "grass"
map.tiles[6][3] = "grass"
map.tiles[6][4] = "grass"
map.tiles[6][5] = "lava"
map.tiles[6][6] = "lava"
map.tiles[6][7] = "lava"
map.tiles[6][8] = "wall"
map.tiles[7][1] = "wall"
map.tiles[7][2] = "grass"
map.tiles[7][3] = "grass"
map.tiles[7][4] = "grass"
map.tiles[7][5] = "wall"
map.tiles[7][6] = "lava"
map.tiles[7][7] = "grass"
map.tiles[7][8] = "wall"
map.tiles[8][1] = "wall"
map.tiles[8][2] = "wall"
map.tiles[8][3] = "wall"
map.tiles[8][4] = "wall"
map.tiles[8][5] = "wall"
map.tiles[8][6] = "wall"
map.tiles[8][7] = "wall"
map.tiles[8][8] = "wall"
-- Entity Data
map.entities = {}
map.entities[1] = {}
map.entities[1].id = "ally"
map.entities[1].x = 2
map.entities[1].y = 6
map.entities[2] = {}
map.entities[2].id = "ally"
map.entities[2].x = 3
map.entities[2].y = 7
map.entities[3] = {}
map.entities[3].id = "enemy"
map.entities[3].x = 6
map.entities[3].y = 2
map.entities[4] = {}
map.entities[4].id = "enemy"
map.entities[4].x = 7
map.entities[4].y = 3
-- Return the map data
return map