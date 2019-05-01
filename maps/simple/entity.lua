-- Example of the entity file format
local entities = {}

local e = {}
e.id = "ally"
e.hp = 10
e.at = 5
e.sp = 2
e.rn = 1
e.anim = "ally"
e.funcs = nil -- Leave funcs nil to use default values
table.insert(entities, e)

e = {}
e.id = "enemy"
e.hp = 10
e.at = 5
e.sp = 1
e.rn = 1
e.anim = "enemy"
e.isEnemy = true
e.funcs = nil
table.insert(entities, e)

return entities