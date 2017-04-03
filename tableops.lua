local tab = {}

tab.deepcopy = function(t)
    local ttype,d = type(t),tab.deepcopy
    local copy
    if ttype == 'table' then
        copy = {}
        for k,v in next,t,nil do copy[d(k)]=d(v) end
		setmetatable(copy,getmetatable(t))
    else copy = t 
    end
    return copy
end

tab.protocopy = function(t,p)
	local copy = t.deepcopy(t)
	if p then
		for k,v in pairs(p) do
			copy[k] = v
		end
	end
	return copy
end


tab.shallowcopy = function(t)
	local copy = {}
	for k,v in pairs(t) do copy[k]=v end
	return copy 
end

tab.shallowcopy_n = function(t)
	local copy = {}
	for i=1,#t do
		local o = t[i]
		copy[#copy+ 1] = o
	end
	return copy 
end

tab.condcopy = function(t,cond)
	local copy = {}
	for k,v in pairs(t) do
		if cond(v) then 
			copy[k] = v	
		end
	end
	return copy
end

tab.condcopy_n = function(t,cond)
	local copy = {}
	for i=1,#t do
		local o = t[i]
		if cond(o) then
			copy[#copy + 1] = o
		end
	end
	return copy 
end

tab.merge = function(...)
	local copy = {}
	for _,t in ipairs({...}) do
		for k,v in pairs(t) do
			copy[k] = v
		end
	end
	return copy 
end

tab.merge_n = function(...)
	local copy = {}
	for _,t in ipairs({...}) do
		for i=1,#t do
			copy[#copy+1] = t[i]
		end
	end
	return copy 
end

tab.map = function(t,f,...)
	local copy = {}
	for k,v in pairs(t) do
		copy[k] = f(v,...)
	end
	return copy 
end


tab.invert = function(t)
	local copy = {}
	for k,v in pairs(t) do
		nt[v] = k
	end
	return copy 
end

tab.any = function(t,x)
	for k,v in pairs(t) do
		if x == v then 
			return true 
		end
	end
end

tab.contains_any = function(t,...)
	for _,v in ipairs({...}) do
		if t[v] then
			return true
		end
	end
end


tab.contains_all = function(t,...)
	for _,v in ipairs({...}) do
		if not t[v] then
			return
		end
	end
	return true
end


tab.slice = function(t,n,e)
	local s = {}
	for i=n,(e or #t) do
		s[#s+1] = t[i]
	end
	return s
end

tab.grid = {}

tab.grid.new = function(w,h,f)
	local g = {}
	for y=1,h do
		g[y] = {}
		for x=1,w do
			g[y][x] = (type(f) == "function" and f(x,y) or (f or 0))
		end
	end
	return setmetatable(g,tab.grid)
end

tab.grid.transpose = function(g)
	local ng = tab.grid.new(#g[1],#g)
	for i=1,#g do
		for j=1,#g[i] do
			ng[j][i] = g[i][j]
		end
	end
	return ng 
end

tab.grid.flip_y = function(g)
	local ng = tab.grid.new(#g[1],#g)
	for i=1,#g do
		for j=1,#g[i] do
			ng[#g - i + 1][j] = g[i][j]
		end
	end
	return ng 
end

tab.grid.flip_x = function(g)
	local ng = tab.grid.new(#g[1],#g)
	for i=1,#g do
		for j=1,#g[i] do
			ng[i][#g[i] - j + 1] = g[i][j]
		end
	end
	return ng 
end

tab.grid.rotate_cclock = function(g)
	local ng = transpose(g)
	return tab.grid.flip_y(ng)
end

tab.grid.rotate_clock = function(g)
	local ng = tab.grid.transpose(g)
	return tab.grid.flip_x(ng)
end

setmetatable(tab.grid,{__call = tab.grid.new})

tab.queue = {}

tab.queue.new = function ()
	return setmetatable({head=0,tail=-1},{__index = tab.queue})
end

tab.queue.push_left = function(q,n)
	q.head = q.head - 1
	q[q.head] = n
end

tab.queue.push_right = function(q,n)
	q.tail = q.tail + 1
	q[q.tail] = n
end

tab.queue.pop_left = function(q)
	assert(q.head <= q.tail,"attempt to pop empty queue")
	local n = q[q.head]
	q[q.head] = nil
	q.head = q.head + 1
	return n
end

tab.queue.pop_right = function(q)
	assert(q.head <= q.tail,"attempt to pop empty queue")
	local n = q[q.tail]
	q[q.tail] = nil
	q.tail = q.tail - 1
	return n
end

tab.queue.peek_left = function(q)
	return q[q.head+1]
end

tab.queue.peek_right = function(q)
	return q[q.tail]
end

tab.queue.len = function(q)
	return q.tail - q.head
end

setmetatable(tab.queue,{__call = tab.queue.new})
	
