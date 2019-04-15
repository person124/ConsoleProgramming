local mainMenu = {}

function mainMenu.start()

end

function mainMenu.update(dt)

end

function mainMenu.render(screen)
	love.graphics.setNewFont(64)

	love.graphics.print("Play Level", 20 + 64, 55)

	love.graphics.print("Create Level", 20 + 64, 139)
	
	love.graphics.print("Quit", 20 + 64, 223)
end

return mainMenu