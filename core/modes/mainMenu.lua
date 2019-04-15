local mainMenu = {}

local yMod = 250

function mainMenu.start()

end

function mainMenu.update(dt)
	-- Check and see if you clicked on a option
	local input = getInputInstance()
	
	if input.screenX ~= -1 and input.screenY ~= -1 and input.count == 1 then
		local x = input.screenX
		local y = input.screenY

		if x >= 84 and x <= 400 and y >= 300 and y <= 364 then
			goToLevelSelect()
		end
	end
end

function mainMenu.render(screen)
	-- Render main title
	love.graphics.setNewFont(100)
	love.graphics.print("Tactical Knockout", 50, 50)

	love.graphics.setNewFont(64)

	-- Render menu options
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", 20+64, yMod+55, 32 * 10, 64)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Play Level", 20 + 64, yMod + 55)

	if not utils.isMobile() then
		love.graphics.print("Create Level", 20 + 64, yMod + 139)
	end
	
	love.graphics.print("Quit", 20 + 64, yMod + 223)
end

return mainMenu