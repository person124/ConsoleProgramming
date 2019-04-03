local levelSelect = {}

local levelList = {}

function levelSelect.start(mapFolder)
	levelList = {}
	assert(love.filesystem.isDirectory(mapFolder), "Map folder " .. mapFolder .. "not found")

	for i,file in ipairs(love.filesystem.getDirectoryItems(mapFolder)) do
		if love.filesystem.isDirectory(mapFolder .. "/" .. file) then
			table.insert(levelList, file)
		end
	end
end

function levelSelect.update(dt)
	local input = getInputInstance()

	if input.screenX ~= -1 and input.screenY ~= -1 and input.count == 1 then
		local clickedY = 0

		clickedY = math.floor((input.screenY + 24) / 84)

		if clickedY < 1 or clickedY > table.getn(levelList) then return end

		loadMap(levelList[clickedY])
	end
end

function levelSelect.render(screen)
	-- Render the list of levels

	-- Set the font size bigger
	love.graphics.setNewFont(64)
	for i=1,table.getn(levelList) do
		-- The y value for the texture and level name
		local y = (i * 84) - 24
		love.graphics.draw(getTexture("level-select"), 20, y)
		love.graphics.print(levelList[i], 20 + 64, y - 5)
	end
end

return levelSelect