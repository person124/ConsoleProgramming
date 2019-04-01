local levelSelect = {}

local levelList = {}

function levelSelect.start(mapFolder)
	assert(love.filesystem.isDirectory(mapFolder), "Map folder " .. mapFolder .. "not found")

	for i,file in ipairs(love.filesystem.getDirectoryItems(mapFolder)) do
		if love.filesystem.isDirectory(mapFolder .. "/" .. file) then
			table.insert(levelList, file)
		end
	end
end

function levelSelect.update(dt)

end

function levelSelect.render(screen)
	-- Render the list of levels

	-- Set the font size bigger
	love.graphics.setNewFont(64)
	for i=1,table.getn(levelList) do
		love.graphics.draw(getTexture("level-select"), 20, i * 20)
		love.graphics.print(levelList[i], 20 + 64, i * 20 - 5)
	end
end

return levelSelect