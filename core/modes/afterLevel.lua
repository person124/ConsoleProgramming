local afterLevel = {}

local won

function afterLevel.start(didWin)
	won = didWin
end

function afterLevel.update(dt)

end

function afterLevel.render(screen)
	love.graphics.setNewFont(64)

	if won then
		love.graphics.print('You win!!', 0, 0)
	end
end

return afterLevel