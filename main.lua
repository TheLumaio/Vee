
Gamestate = require ("lib.hump.gamestate")
Camera = require ("lib.hump.camera")
Class = require ("lib.hump.class")

Options = require ("states.Options")
Menu = require ("states.Menu")
Play = require ("states.Play")

require ("data")

function love.load()
	MainCam = Camera(0, 0)

	phys = love.physics
	key = love.keyboard
	g = love.graphics

	MainFont = g.newFont("res/fonts/Anonymous.ttf", 16)
	Title = g.newFont("res/fonts/Anonymous.ttf", 100)
	Option = g.newFont("res/fonts/Anonymous.ttf", 50)

	World = phys.newWorld(0, 0, true)

	g.setBackgroundColor(50, 50, 50)
	g.setFont(MainFont)

	phys.setMeter(16)

	Gamestate.switch(Menu)
	Gamestate.registerEvents()
end

function love.update(dt)
	World:update(dt)
end

function love.draw()
end

--[[
-- Utility functions for ease of use
--]]

function deepCopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function love.graphics.ellipse(fillmode, x, y, width, height)
	if height == nil then
		love.graphics.circle( fillMode, x, y, width/2, 50 )
	elseif width == height then
		love.graphics.circle( fillMode, x, y, (width+height)/2, 50 )
	else
		local a = width/2
		local b = height/2
		local stp=50
		local rot=0
		local n,m=math,rad,al,sa,ca,sb,cb,ox,oy,x1,y1,ast
		m = math; rad = m.pi/180; ast = rad * 360/stp;
		sb = m.sin(-rot * rad); cb = m.cos(-rot * rad)
		for n = 0, stp, 1 do
			ox = x1; oy = y1;
			sa = m.sin(ast*n) * b; ca = m.cos(ast*n) * a
			x1 = x + ca * cb - sa * sb
			y1 = y + ca * sb + sa * cb
			if (n > 0) then love.graphics.line( ox, oy, x1, y1) end
		end
	end
end
