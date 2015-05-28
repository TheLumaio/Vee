local drill = {}

function drill:new(x, y)
	local d = {}
	setmetatable(d, self)
	self.__index = self

	d.x = x
	d.y = y
	d.image = g.newImage("res/images/Drill.png")
	d.w = d.image:getWidth()
	d.h = d.image:getHeight()

	d.bcost = 200

	d.timer = 0

	d.z = 0

	return d
end

function drill:place()
	self.body = phys.newBody(World, self.x, self.y, "static")
	self.shape = phys.newRectangleShape(self.w, self.h-20)
	self.fixture = phys.newFixture(self.body, self.shape)
end

function drill:update(dt)
	self.z = self.y+25

	self.body:setX(self.x+self.w/2)
	self.body:setY(self.y+self.h/2+10)

	
	self.timer = self.timer + dt
	if self.timer > 2 then
		Player.resources = Player.resources + 10
		self.timer = 0
	end
end

function drill:draw()

	g.setColor(255, 255, 255)
	g.draw(self.image, self.x, self.y)


	g.setColor(100, 115, 100)
	g.rectangle("fill", self.x, self.y-12, self.timer*self.w/2, 10)
end

return drill
