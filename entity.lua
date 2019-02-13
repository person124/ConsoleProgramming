entity = {}

function entity.create(id, health, attack, speed, range, texture)
	entity[id] = {}
	entity[id].hp = health
	entity[id].at = attack
	entity[id].sp = speed
	entity[id].rn = range

	entity[id].texture = texture

	entity[id].x = x
	entity[id].y = y
end

function entity.render(ent)
	xPos = ent.x - screen.offset.x
	yPos = ent.y - screen.offset.y

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