local u_handler = {}

function u_handler:init()
	self.units = {}
end

function u_handler:addUnit(unit)
	local u = deepCopy(unit)
	table.insert(self.units, u)
end

function u_handler:update(dt)
	table.sort(self.units, function(a, b) return a.z < b.z end)

	for i,v in pairs(self.units) do
		if v.update then
			 v:update(dt)
		end
	end
end

function u_handler:draw()
	for i,v in pairs(self.units) do
		if v.draw then
			v:draw()
		end
	end
	if self.leader then
		g.print(tostring(self.leader))
	end
end

function u_handler:mousepressed(x, y, b)
	if Selector.placing then return end
	local dx, dy = MainCam:worldCoords(x, y)
	if b == "r" then
		if not self.leader then
			self:chooseLeader()
		end

		for i,v in pairs(self.units) do

			if v.selected then
				if v.isLeader then
					self.leader.to_x = dx
					self.leader.to_y = dy
				else
					local s = self:getSelected()
					v.to_x = math.random(self.leader.to_x-16*s, self.leader.to_x+16*s)
					v.to_y = math.random(self.leader.to_y-16*s, self.leader.to_y+16*s)
				end
			end
		end
		for i,v in pairs(self.units) do v.isLeader = false end
		self.leader = nil
	end
end

function u_handler:getSelected()
	local s = 0
	for i,v in pairs(self.units) do
		if v.selected then s = s + 1 end
	end
	return s
end

function u_handler:chooseLeader()
	for i,v in pairs(self.units) do
		if v.selected then
			v.isLeader = true
			self.leader = v
			break
		end
	end
end

return u_handler
