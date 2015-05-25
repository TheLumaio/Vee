local grunt = {}

function grunt:new(x, y, team)
	local gr = {}
	setmetatable(gr, self)
	self.__index = self

	gr.actor = true

	gr.x = x
	gr.y = y
	gr.to_x = nil
	gr.to_y = nil
	gr.team = team

	gr.z = gr.y

	gr.w = 16
	gr.h = 32

	gr.isLeader = false

	gr.body = phys.newBody(World, x, y, "dynamic")
	gr.shape = phys.newCircleShape(gr.w/2)
	gr.fixture = phys.newFixture(gr.body, gr.shape)

	gr.fixture:setRestitution(1)

	gr.body:setLinearDamping(100)
	gr.body:setFixedRotation(false)

	return gr

end

function grunt:update(dt)
	self.z = self.y

	self.x = self.body:getX()
	self.y = self.body:getY()+(self.h/2)/2

	if self.to_x and self.to_y then
		local rot = -(math.atan2((self.y-self.to_y), -(self.x-self.to_x)))
		self.dx = math.cos(rot) * 150
		self.dy = math.sin(rot) * 150
		self.body:applyLinearImpulse(self.dx, self.dy)

		if self.x > self.to_x-5 and self.x < self.to_x+5 and self.y > self.to_y-5 and self.y < self.to_y+5 then
			self.to_x = nil
			self.to_y = nil
		end
	end


end

function grunt:draw()


	if self.to_x and self.to_y then
		g.setColor(100, 100, 150)
		g.ellipse("line", self.to_x, self.to_y, self.w+10, 10)
	end

	if self.selected == true then
		g.setColor(100, 150, 100)
	else
		g.setColor(100, 100, 100)
	end
	g.ellipse("line", self.x, self.y, self.w+10, 10)

	g.setColor(150, 100, 100)
	g.rectangle("fill", self.x-self.w/2, self.y-self.h, self.w, self.h)
	g.setColor(0, 0, 0)
	g.rectangle("line", self.x-self.w/2, self.y-self.h, self.w, self.h)

	g.setColor(255, 255, 255)
	--g.rectangle("line", self.x-self.w/2, self.y-self.h/2, self.w, self.h/2)
end

return grunt
