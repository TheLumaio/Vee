local factory = {}

function factory:new(x, y)
	local f = {}
	setmetatable(f, self)
	self.__index = self

	f.x = x
	f.y = y
	f.image = g.newImage("res/images/Factory.png")
	f.w = f.image:getWidth()
	f.h = f.image:getHeight()

	f.z = 0

	f.bcost = 500

	f.cost = 20
	f.queue = 0
	f.timer = 0

	return f

end

function factory:place()
	f.body = phys.newBody(World,self.x, self.y, "static")
	f.shape = phys.newRectangleShape(self.image:getWidth(), self.image:getHeight()-20)
	f.fixture = phys.newFixture(self.body, self.shape)
end

function factory:update(dt)

	if self.queue > 0 then
		self.timer = self.timer + dt
		if self.timer > 5 then
			self.queue = self.queue - 1
			EntityHandler:addEntity(Grunt:new(math.random(self.x, self.x+self.w), math.random(self.y+self.h+15, self.y+self.h+50)))
			self.timer = 0
		end
	end

end

function factory:draw()
	self.z = self.y+25

	self.x = math.floor(self.x)
	self.y = math.floor(self.y)
	self.body:setX(self.x+self.image:getWidth()/2)
	self.body:setY(self.y+self.image:getHeight()/2+10)
	g.setColor(255, 255, 255)
	g.draw(self.image, self.x, self.y)
	g.print(tostring(self.queue), self.x, self.y)

	g.setColor(100, 115, 100)
	g.rectangle("fill", self.x, self.y-12, self.timer*self.w/5, 10)


end

function factory:mousepressed(x, y, b)
	local dx, dy = x, y
	local dx, dy = MainCam:worldCoords(x, y)
	if b == "l" then
		if dx > self.x and dx < self.x+self.w and dy > self.y and dy < self.y+self.h then
			if Player.resources-self.cost > -1 then
				self.queue = self.queue + 1
				Player.resources = Player.resources - self.cost
			end
		end
	end
end

return factory
