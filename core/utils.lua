-- This functions allows the creation of protected tables
-- On use will make a table write only
-- http://andrejs-cainikovs.blogspot.com/2009/05/lua-constants.html
function protect(tbl)
	return setmetatable({}, {
		__index = tbl,
		__newindex = function(t, key, value)
			error("attempting to change constant " ..
				tostring(key) .. " to " .. tostring(value), 2)
		end
	})
end