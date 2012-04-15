--[[
Currently available objects:
	- Background (not used as a game object)
	- LeftWall
	- RightWall
	- Floor
	- FloorVent
	

-- Custom game objects to make
	- Paper (extra life)
	- Rubber bands
	- Battery (boost)
	- Light switch
	- Outlet
	- Tables
	- Cupboards
	- Windows (back and side)
	- Doors
	- File cabnits
	- Basketball
	- Dripping water
	- Clawing cat
	- Candle
	- Fan
	- Top vent
	- Enemy gliders
	- Level backgounds

--]]

module(..., package.seeall)

local GameObject = require("GameObject")


--[[
Room background
--]]
Background = GameObject.GameObject:new{
	imageName = imageDir .. "RoomTemplate1024x648.png",
	width = 1024,
	height = 648,
	x = display.contentWidth * 0.5,
	y = 16 + display.contentHeight * 0.5,
}

--[[
Wide aspect ratio left room background
--]]
BackgroundLeftRoom = GameObject.GameObject:new{
	imageName = imageDir .. "RoomTemplate1024x648.png",
	width = 1024,
	height = 648,
	x = - display.contentWidth * 0.5,
	y = 16 + display.contentHeight * 0.5,
}

--[[
Wide aspect ratio right room background
--]]
BackgroundRightRoom = GameObject.GameObject:new{
	imageName = imageDir .. "RoomTemplate1024x648.png",
	width = 1024,
	height = 648,
	x = display.contentWidth * 1.5,
	y = 16 + display.contentHeight * 0.5,
}

--[[
Tall aspect ratio filler
--]]
TopFiller = GameObject.GameObject:new{
	imageName = imageDir .. "TopAndBottomFiller.png",
	width = 1224,
	height = 43,
	x = display.contentWidth * 0.5,
	y = 11,
}

--[[
Tall aspect ratio filler
--]]
BottomFiller = GameObject.GameObject:new{
	imageName = imageDir .. "TopAndBottomFiller.png",
	width = 1224,
	height = 43,
	x = display.contentWidth * 0.5,
	y = display.contentHeight + 21,
}


--[[
Left Wall
--]]
LeftWall = GameObject.GameObject:new{
	wallPosition = 75,
	inTransition = false,
}

function LeftWall:enterFrame ( glider, frameRateVariation )
	if not self.inTransition then
		if glider:getX() <= self.wallPosition then
			self.inTransition = true
			glider:transitionTo({ time = 250, delta = true, x = 20, transition = easing.outQuad })
			timer.performWithDelay(250, function (event) self.inTransition = false end)
		end
	end
end

--[[
Right Wall
--]]
RightWall = GameObject.GameObject:new{
	wallPosition = display.contentWidth - 75,
	inTransition = false,
}

function RightWall:enterFrame ( glider, frameRateVariation )
	if not self.inTransition then
		if glider:getX() >= self.wallPosition then
			self.inTransition = true
			glider:transitionTo({ time = 250, delta = true, x = -20, transition = easing.outQuad })
			timer.performWithDelay(250, function (event) self.inTransition = false end)
		end
	end
end

--[[
Left Screen Teleport
--]]
LeftScreenTeleport = GameObject.GameObject:new{
	moveToRoom = 1,
}

function LeftScreenTeleport:enterFrame ( glider, frameRateVariation )
	if glider:getX() <= 0 then
		glider.level:moveToRoom( self.moveToRoom )
		glider:pointLeft()
		glider:setX(display.contentWidth - 10)
		glider.level:getCurrentRoom():setGliderStartPositionX(display.contentWidth - 120)
	end
end

--[[
Right Screen Teleport
--]]
RightScreenTeleport = GameObject.GameObject:new{
	moveToRoom = 1,
}

function RightScreenTeleport:enterFrame ( glider, frameRateVariation )
	if glider:getX() >= display.contentWidth then
		glider.level:moveToRoom( self.moveToRoom )
		glider:pointRight()
		glider:setX(10)
		glider.level:getCurrentRoom():setGliderStartPositionX(120)
	end
end


--[[
Floor
--]]
Floor = GameObject.GameObject:new{
	y = display.contentHeight - 35,
}

function Floor:enterFrame ( glider )
	if glider:getY() >= self.y then
		glider:loseLife()
	end
end


--[[
Floor Vent
--]]
FloorVent = GameObject.GameObject:new{
	imageName = imageDir .. "FloorVent.png",
	width = 100,
	height = 40,
	airHeight = 530,
	x = 30,
	y = display.contentHeight - 32,
	inTransition = false,
}

function FloorVent:setAirHeight ( airHeight)
	self.airHeight = airHeight
end

function FloorVent:getAirHeight ()
	return self.airHeight
end

function FloorVent:enterFrame ( glider, frameRateVariation )
	if not self.inTransition then
		local xDif = self:getX() - glider:getX()
		if xDif < 60 and xDif > -60 then --Within x area, check y area
			local ventTopY = self:getY() - self.airHeight
			if glider:getY() > ventTopY + 5 then -- When you are 20 pixels from the top of the vent - move up at a constant rate
				glider:setY(glider:getY() - 7 * frameRateVariation)
			elseif glider:getY() > ventTopY then -- When you are 15 pixels from the top of the vent - Transition up at a variable rate
				self.inTransition = true
				glider:transitionTo({ time = 330, y = -30, delta = true, transition = easing.outQuad })
				timer.performWithDelay(330, function (event) self.inTransition = false end)
			end
		end
	end
end
