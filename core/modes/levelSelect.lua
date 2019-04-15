local levelSelect = {}

local levelList = {}

local offset

function levelSelect.start(mapFolder)
	getScreenInstance().setOffset(0, 0)

	levelList = {}
	assert(love.filesystem.isDirectory(mapFolder), "Map folder " .. mapFolder .. "not found")

	for i,file in ipairs(love.filesystem.getDirectoryItems(mapFolder)) do
		if love.filesystem.isDirectory(mapFolder .. "/" .. file) then
			table.insert(levelList, file)
		end
	end
end

function levelSelect.update(dt)
	-- Offset checking
	if getScreenInstance().offset.y > 0 then
		getScreenInstance().offset.y = 0
	end

	-- Tap location checking
	local input = getInputInstance()
	if input.screenX ~= -1 and input.screenY ~= -1 then
		if input.count == 1 then
			local clickedY = 0

			local y = input.screenY + 24 - getScreenInstance().offset.y
			clickedY = math.floor(y / 84)

			if clickedY < 1 or clickedY > table.getn(levelList) then return end

			loadMap(levelList[clickedY])
		end
	end
end

-- Render the list of levels
function levelSelect.render(screen)
	local yOff = getScreenInstance().offset.y

	-- Set the font size bigger
	love.graphics.setNewFont(64)
	for i=1,table.getn(levelList) do
		-- The y value for the texture and level name
		local y = (i * 84) - 24
		love.graphics.draw(getTexture("level-select"), 20, y + yOff)
		love.graphics.print(levelList[i], 20 + 64, y + yOff - 5)
	end
end

return levelSelect