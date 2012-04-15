module(..., package.seeall)

local GameObject = require("GameObject")

--[[
Glider
--]]
Glider = GameObject.GameObject:new{
	imageRight,
	imageRightName = imageDir .. "Paratrooper.png",
	imageLeft,
	imageLeftName = imageDir .. "Paratrooper.png",
	width = 100,
	height = 100,
	x = 120,
	y = 120,
	isAnimated = true,
	
	-- The glider needs a reference to the level because it acts as the model in an MVC
	level,
	
	-- Glider state
	isRotatedRight = false,
	isRotatedLeft = false,
	userReady = false,
	gliderMotionIsPaused = false,
	isPointedRight = true
}

-- Need to override some GameObject functions because the Glider has two images.  One points right and one points left.
function Glider:loadImage ()
	if self.imageRightName and self.imageLeftName and self.width and self.height and self.x and self.y then
		self.image = display.newGroup()
		
		self.imageRight = display.newImageRect(self.imageRightName, self.width, self.height)
		self.imageRight.isVisible = true
		self.image:insert(self.imageRight)
		
		self.imageLeft = display.newImageRect(self.imageLeftName, self.width, self.height)
		self.imageLeft.isVisible = false
		self.image:insert(self.imageLeft)
		
		self.image.x = self.x
		self.image.y = self.y
		return true
	end
	return false
end

function Glider:unloadImage ()
	for i=self.image.numChildren,1,-1 do
        self.image[i]:removeSelf()
	end
	self.image = nil
	
	self.imageRight = nil
	self.imageLeft = nil
end

-- Actions that can be performed on the glider
function Glider:pointRight()
	self.imageRight.isVisible = true
	self.imageLeft.isVisible = false
	self.isPointedRight = true
end

function Glider:pointLeft()
	self.imageRight.isVisible = false
	self.imageLeft.isVisible = true
	self.isPointedRight = false
end

function Glider:isPointedRight()
	return self.isPointedRight
end

function Glider:setGliderPosition( params )
	return function (event)
		if params.x then
			self:setX(params.x)
		end
		if params.y then
			self:setY(params.y)
		end
	end
end

function Glider:fadeOutGlider()
	self:transitionTo({ time = 400, alpha = 0 })
end

function Glider:pauseGliderMotion()
	self.gliderMotionIsPaused = true
end

function Glider:fadeGliderOutIn( func )
	local function fadeInGlider()
		self:transitionTo({ time = 400, alpha = 1 })
	end
	local function resumeGliderMotion()
		self.gliderMotionIsPaused = false
	end
	self:pauseGliderMotion()
	self:fadeOutGlider()
	timer.performWithDelay(400, func)
	timer.performWithDelay(500, fadeInGlider)
	timer.performWithDelay(900, resumeGliderMotion)
end

function Glider:loseLife()
	self.level:loseLife()
	if self.level:getLives() < 0 then
		self:pauseGliderMotion()
	else
		self:fadeGliderOutIn(self:setGliderPosition({x = self.level:getCurrentRoom().gliderStartPositionX, y= self.level:getCurrentRoom().gliderStartPositionY }))
	end
end

function Glider:enterFrame(event)
	local controls = self.level.controls
	
	-- Wait for the user to press an arrow to start the game
	if self.level.paused then
		if controls.moveLeft or controls.moveRight then
			self.level.paused = false
		end
	end
	
	if (not self.level.paused) and (not self.gliderMotionIsPaused) then
		-- Check for glider interaction with level objects
		for i,object in ipairs(self.level:getCurrentRoom().roomObjects) do
			-- Check if a new room is loaded
			if self.level:checkNewRoomLoaded() then
				self.level:acknowledgeNewRoomLoaded()
				break
			end
			object:checkGliderInteraction(self)
		end
		
		-- The glider hasn't interacted with anything at this point.  Move the glider to it's next x and y position.
		
		-- Move down
		self:setY(self:getY() + 3)
		
		-- Move left
		if controls.moveLeft then
			if not self.isRotatedLeft then
				self:rotate(-10)
				self.isRotatedLeft = true
			end
			
			if controls.boost then
				self:setX(self:getX() - 9)
			else
				self:setX(self:getX() - 4)
			end
		elseif self.isRotatedLeft then
			self:rotate(10)
			self.isRotatedLeft = false
		end
		
		-- Move right
		if controls.moveRight then
			if not self.isRotatedRight then
				self:rotate(10)
				self.isRotatedRight = true
			end
			
			if controls.boost then
				self:setX(self:getX() + 9)
			else
				self:setX(self:getX() + 4)
			end
		elseif self.isRotatedRight then
			self:rotate(-10)
			self.isRotatedRight = false
		end
	end
end
