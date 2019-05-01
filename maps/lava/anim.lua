local function getAnimations(a)
	local anim = {}

	anim["ally"] = a.create("ally", 0, 0, 64, 64, 3, 1, 0.25)
	anim["enemy"] = a.create("enemy", 0, 0, 64, 64, 3, 1, 0.25)

	anim["tile_grass"] = a.create("tiles", 0, 0, 64, 64, 1, 2, 0)
	anim["tile_wall"] = a.create("tiles", 64, 0, 64, 64, 1, 1, 0)
	anim["tile_lava"] = a.create("tile_lava", 0, 0, 64, 64, 2, 2, 1)

	return anim
end

return getAnimations