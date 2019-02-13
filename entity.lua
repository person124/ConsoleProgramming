entity = {}

function entity.load()
	entity.create("unit", 10, 5, 2, 1, "unit")
end

function entity.create(id, health, attack, speed, range, texture)
	entity[id] = {}
	entity[id].hp = health
	entity[id].at = attack
	entity[id].sp = speed
	entity[id].rn = range

	entity[id].texture = texture

	entity[id].x = 0
	entity[id].y = 0
end

function entity.render(ent)
	xPos = (ent.x * 64) - screen.offset.x
	yPos = (ent.y * 64) - screen.offset.y

	love.graphics.draw(textures[ent.texture], xPos, yPos)
end

function entity.copy(ent)
	entCopy = {}
	entCopy.hp = ent.hp
	entCopy.at = ent.at
	entCopy.sp = ent.sp
	entCopy.rn = ent.rn

	entCopy.texture = ent.texture

	entCopy.x = ent.x
	entCopy.y = ent.y

	return entCopy
end