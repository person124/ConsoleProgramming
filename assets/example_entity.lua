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
e.funcs = {}
function e.funcs.damage(attacker, target, amount)
	target.hp = 1
end
table.insert(entities, e)

return entities