module(..., package.seeall)

--[[
Button
--]]
Button = {
	imageDefaultName,
	imageDefault,
	imageOverName,
	imageOver,
	width = 100,
	height = 100,
	x = 100,
	y = 100,
	alpha = 1,
	onPress, -- Run this function if the button is pressed or dragged over
	onRelease, -- Run this function if the button is released and you are still within the button's area (this will also run if you drag out of the area and there is an onPress event)
	isPressed = false,
	buttonDisplayGroup,
	touchEventID,
}

function Button:new (o)
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function Button:touch(event)
	-- Possible phases are began, moved, stationary, ended, cancelled
	local phase = event.phase
	local bounds = self.imageDefault.contentBounds
	local eventX,eventY = event.x,event.y
	local inBounds = not (bounds.xMin >= eventX or bounds.xMax <= eventX or bounds.yMin >= eventY or bounds.yMax <= eventY)
	
	-- in bounds and not registered as pressed yet
	if inBounds and not (self.isPressed or phase == "ended" or phase == "cancelled") then
		self.touchEventID = event.id
		self.isPressed = true
		if self.imageOver then
			self.imageDefault.isVisible = false
			self.imageOver.isVisible = true
		end
		if self.onPress then
			self.onPress()
		end
	elseif self.touchEventID == event.id and self.isPressed and ((not inBounds) or phase == "ended" or phase == "cancelled") then -- going out of bounds or the touch is ending
		self.touchEventID = nil
		self.isPressed = false
		if self.imageOver then
			self.imageDefault.isVisible = true
			self.imageOver.isVisible = false
		end
		if self.onRelease and (inBounds or self.onPress) then
			self.onRelease()
		end
	end
end

function Button:loadButton()
	self.isPressed = false
	
	if not self.buttonDisplayGroup then
		self.buttonDisplayGroup = display.newGroup()
	end
	
	if self.imageDefaultName then
		buttonDisplayGroup = display.newGroup()
		self.imageDefault = display.newImageRect( self.imageDefaultName, self.width, self.height )
		self.buttonDisplayGroup:insert( self.imageDefault )
	end
	
	if self.imageOverName then
		self.imageOver = display.newImageRect( self.imageOverName, self.width, self.height )
		self.imageOver.isVisible = false
		self.buttonDisplayGroup:insert( self.imageOver )
	end
	
	self.buttonDisplayGroup.x = self.x
	self.buttonDisplayGroup.y = self.y
	self.buttonDisplayGroup.alpha = self.alpha
	
	Runtime:addEventListener( "touch", self )
end

function Button:unloadButton()
	Runtime:removeEventListener( "touch", self )
	
	-- Remove all the button's images from the display group
	for i=self.buttonDisplayGroup.numChildren,1,-1 do
        self.buttonDisplayGroup[i]:removeSelf()
	end
	self.buttonDisplayGroup = nil
	
	-- Nil all the references to the button's images
	self.imageDefaultName = nil
	self.imageDefault = nil
	self.imageOverName = nil
	self.imageOver = nil
	
	self.onPressEvent = nil
	self.onReleaseEvent = nil
	self.width = nil
	self.height = nil
	self.x = nil
	self.y = nil
	self.alpha = nil
	self.isPressed = nil
end
