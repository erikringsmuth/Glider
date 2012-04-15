module(..., package.seeall)

--[[
Generic game object
--]]
GameObject = {
	imageName, -- The file name of the image
	image, -- Load the image when the object is viewable
	x, -- The object's x position
	y, -- The object's y position
	width, -- The object's width
	height, -- The object's height
}

function GameObject:new (o)
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function GameObject:loadImage ()
	if self.imageName and self.width and self.height and self.x and self.y then
		self.image = display.newImageRect(self.imageName, self.width, self.height)
		self.image.x = self.x
		self.image.y = self.y
		return true
	end
	return false
end

function GameObject:unloadImage ()
	self.image:removeSelf()
	self.image = nil
end

function GameObject:setX (x)
	self.x = x
	if self.image then
		self.image.x = x
	end
end

function GameObject:getX ()
	if self.image then
		return self.image.x
	else
		return self.x
	end
end

function GameObject:setY (y)
	self.y = y
	if self.image then
		self.image.y = y
	end
end

function GameObject:getY ()
	if self.image then
		return self.image.y
	else
		return self.y
	end
end

function GameObject:rotate (dTheta)
	if self.image then
		self.image:rotate (dTheta)
	end
end

function GameObject:transitionTo ( params )
	if self.image then
		transition.to(self.image, params)
	end
end

function GameObject:enterFrame ( glider, frameRateVariation )
	-- Override this function to create animations and check for interaction with the glider
end
