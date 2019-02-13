entity = {}

function entity.create(id, health, attack, speed, range, texture)
	entity[id] = {}
	entity[id].hp = health
	entity[id].at = attack
	entity[id].sp = speed
	entity[id].rn = range

	entity[id].texture = texture
end

function entity.render(ent, xPos, yPoss)
	xPos = xPos - screen.offset.x
	yPos = yPos - screen.offset.y

	love.graphics.draw(textures[ent.texture], xPos, yPos)
end