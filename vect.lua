return function()
	local vect = {}
	vect.__index = vect

	local sqrt,sin,cos,tau,pi = math.sqrt,math.sin,math.cos,math.pi*2,math.pi

	local new = function(x,y)
		return setmetatable({x=x or 0,y=y or 0},vect)
	end
	
	vect.isvect = true
	
	vect.print = function(v)
		return 'vect('..v.x..','..v.y..')'
	end
	
	vect.unpack = function(v)
		return v.x,v.y
	end
	
	vect.invert = function(v)
		return new(-v.x,-v.y)
	end
	
	vect.INVERT = function(v)
		v.x = -v.x
		v.y = -v.y
		return v
	end
	
	vect.equal = function(a,b)
		return a.x == b.x and a.y == b.y
	end
	
	vect.clone = function(v)
		return new(v.x,v.y)
	end
	
	vect.get = function(a,b)
		return new(a.x - b.x,a.y - b.y)
	end
	
	vect.sum = function(a,b)
		return new(a.x + b.x,a.y + b.y)
	end
	
	vect.ADD = function(a,b)
		a.x,a.y = a.x + b.x,a.y + b.y
		return a
	end
	
	vect.scale = function(v,s)
		return new(v.x * s,v.y * s)
	end
	
	vect.SCALE = function(v,s)
		v.x = v.x * s
		v.y = v.y * s
		return v
	end
	
	vect.resize = function(v,s)
		return v:norm():SCALE(s)
	end
	
	vect.RESIZE = function(v,s)
		return v:NORM():SCALE(s)
	end
	
	vect.dot = function(a,b)
		return a.x*b.x+a.y*b.y
	end
	
	vect.project = function(v1,v2)	
		local b = v2:norm()
		return b:SCALE(v1:dot(b))
	end

	vect.perp = function(v)
		return new(-v.y,v.x)
	end
	
	vect.PERP = function(v)
		local x,y = v.x,v.y
		v.x = -y
		v.y = x
		return v
	end
	
	vect.nperp = function(v)
		return new(v.y,-v.x)
	end
	
	vect.NPERP = function(v)
		local x,y = v.x,v.y
		v.x = v.y
		v.y = -v.x
		return v
	end
	
	vect.smag = function(v)
		return ((v.x * v.x) + (v.y * v.y))
	end
	
	vect.mag = function(v)
		return sqrt((v.x ^ 2) + (v.y ^ 2))
	end
	
	vect.norm = function(v)
		local mag = v:mag() 
		return mag == 0 and new(0,0) or new(v.x/mag,v.y/mag)
	end
	
	vect.NORM = function(v)
		local mag = v:mag()
		if mag == 0 then
			v.x,v.y = 0,0
		else
			v.x = v.x / mag
			v.y = v.y / mag
		end
		return v
	end
	
	vect.rot = function(v,r)
		local c,s = cos(r), sin(r)
		return new((c * v.x) - (s * v.y),(s * v.x) + (c * v.y))
	end
	
	vect.ROT = function(v,r)
		local c,s = cos(r),sin(r)
		local x,y = v.x,v.y
		v.x = (c * x) - (s * y)
		v.y = (s * x) + (c * y)
		return v
	end
	
	vect.frot = function(v,n,d)
		local r = tau / d
		return v:rot(n*r)
	end
	
	vect.FROT = function(v,n,d)
		local r = tau / d
		return v:ROT(n*r)
	end
	
	vect.angle = function(v1,v2)
		return math.atan2(v2.y,v2.x) - math.atan2(v1.y,v1.x)	
	end

	vect.toAngle = function(v)
		return math.atan2(v.y,v.x)
	end
	
	vect.dir = function(a,b)
		return a:get(b):NORM()
	end
	
	vect.dist = function(a,b)
		local dx = a.x - b.x 
		local dy = a.y - b.y 
		return sqrt((dx*dx)+(dy*dy))
	end
	
	vect.sdist = function(a,b)
		local dx = a.x - b.x
		local dy = a.y - b.y
		return ((dx*dx) + (dy*dy))
	end
	
	vect.len = function(v)
		return sqrt(v.x*v.x+v.y*v.y)
	end
	
	vect.clamp = function(v,c)
		local mag = v:mag()
		return v:norm():scale(clamp(mag,0,c)) 
	end
	
	vect.CLAMP = function(v,c)
		local mag = v:mag()
		return v:NORM():SCALE(clamp(mag,0,c))
	end
	
	
	vect.SET = function(v,x,y)
		if type(x) == 'table' then
			v.x,v.y = x.x,x.y
		else
			v.x,v.y = x,y
		end
		return v
	end
	
	vect.round = function(v)
		return new(round(v.x),round(v.y))
	end
	
	vect.midpoint = function(a,b)
		return (a+b):SCALE(.5)
	end
	
	vect.test = function()
		for k,v in pairs(vect) do
			print(k,v)
		end
	end
	
	vect.__eq = vect.equal
	vect.__sub = vect.get
	vect.__unm = vect.invert
	vect.__mul = vect.scale 
	vect.__add = vect.sum
	vect.__len = vect.len
	vect.__call = function(_,a,b)
		if type(a) == 'table' and type(b) == 'table' then
			return a-b
		else
			return new(a,b)
		end
	end
	
	return setmetatable({},vect)
end
