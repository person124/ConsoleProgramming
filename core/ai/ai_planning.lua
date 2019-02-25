local function getPoint(x, y)
	local point = {}
	point.x = x
	point.y = y
	return point
end

local function planMovement(map, ent)
	
end

-- This function will plot out a list of tiles that the specified entity
-- Can move to/attack
function plan(map, ent)
	moveTiles = {}
	attackTiles = {}
	
	moveTiles = planMovement(map, ent)
end