local turret = {}

function turret:new(x, y, team)
	local t = {}
	setmetatable(t, self)
	self.__index = self

	t.x = x
	t.y = y
	t.team = team

	t.image = g.newImage("res/images/Turret.png")
	t.w = t.image:getWidth()
	t.h = t.image:getHeight()

	t.bcost = 100

	t.a_radius = 100
	t.a_rate = 1
	t.a_timer = 0

	t.z = 0

	return t

end

function turret:place()
end

function turret:draw()
	self.z = self.y
	g.setColor(255, 255, 255)
	g.circle("line", self.x+self.w/2, self.y+self.h/2, self.a_radius)
	g.draw(self.image, self.x, self.y)
end

return turret
