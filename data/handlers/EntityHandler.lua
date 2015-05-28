local e_handler = {}

function e_handler:init()
	self.entities = {}
end

function e_handler:addEntity(entity)
	local e = deepCopy(entity)
	table.insert(self.entities, e)
end

function e_handler:update(dt)
	table.sort(self.entities, function(a, b) return a.z < b.z end)

	for i,v in pairs(self.entities) do
		if v.update then
			 v:update(dt)
		end
	end
end

function e_handler:draw()
	for i,v in pairs(self.entities) do
		if v.draw then
			v:draw()
		end
	end
	if self.leader then
		g.print(tostring(self.leader))
	end
end

function e_handler:mousepressed(x, y, b)
	if Selector.placing then return end

	for i,v in pairs(self.entities) do
		if v.mousepressed then
			v:mousepressed(x, y, b)
		end
	end

	local dx, dy = MainCam:worldCoords(x, y)
	if b == "r" then
		if not self.leader then
			self:chooseLeader()
		end

		for i,v in pairs(self.entities) do

			if v.selected then
				if v.isLeader then
					self.leader.to_x = dx
					self.leader.to_y = dy
				else
					local s = self:getSelected()
					v.to_x = math.random(self.leader.to_x-16*s/2, self.leader.to_x+16*s/2)
					v.to_y = math.random(self.leader.to_y-16*s/2, self.leader.to_y+16*s/2)
				end
			end
		end
		for i,v in pairs(self.entities) do v.isLeader = false end
		self.leader = nil
	end
end

function e_handler:getSelected()
	local s = 0
	for i,v in pairs(self.entities) do
		if v.selected then s = s + 1 end
	end
	return s
end

function e_handler:chooseLeader()
	for i,v in pairs(self.entities) do
		if v.selected then
			v.isLeader = true
			self.leader = v
			break
		end
	end
end

return e_handler
