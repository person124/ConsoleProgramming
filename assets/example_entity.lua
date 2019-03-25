-- Example of the entity file format

local entities = {}

local e = {}
e.id = "unit"
e.hp = 10
e.at = 5
e.sp = 2
e.rn = 1
e.isEnemy = false
e.texture = "unit"
e.funcs = nil -- Nil to use default funcs
table.insert(entities, e)

return entities