local editor = {}

function editor.update(dt)

end

function editor.render(screen)
	love.graphics.newFont(64)
	love.graphics.print("Still a WIP!", 0, 0)
end

return editor