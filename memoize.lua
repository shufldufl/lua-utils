--arglist to string
local flatten = function(argl)
	local s = '{'
	for _,v in ipairs({argl}) do
		s = s .. v .. ','
	end
	return s
end
--cache stores arglist as keys, simple stack pop operation when cache limit is hit
local caller = function(m,...)
	local ns = flatten(...)
	local c = m.__cache
	if c[ns] then
		return c[ns]
	else
		local res = m.__func(...)
		c[ns] = res
		if c.__limit then
			c.__order[#c.__order+1] = ns
			if c.__count < c.__limit then 
				c.__count = c.__count + 1
			else
				c(c.__order[1]) = nil
				table.remove(c.__order,1)	
			end
		end
		return res
	end
end

local clear = function(m)
	local c = m.__cache
	local nc = {
		__limit = c.__limit,
		__count = 0,
		__order = {}
	}
	return nc
end

local memoize = function(f,n,p)
	return setmetatable(
		{
			__cache = {
				__limit=n or false,
				__count = 0,
				__order = {}
			},
			__func = f,
			clear = clear
		}
		{
			__call = function(m,...)
				return caller(m,...)
			end
		})
end

return memoize
