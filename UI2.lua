-- ui.lua (currently includes Button class with labels, font selection and optional event model)

-- Version 1.5 (works with multitouch, adds setText() method to buttons)
--
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.

module(..., package.seeall)

-----------------
-- Helper function for newButton utility function below
local function newButtonHandler( self, event )

	local result = true

	local default = self[1]
	local over = self[2]
	
	-- General "onEvent" function overrides onPress and onRelease, if present
	local onEvent = self._onEvent
	
	local onPress = self._onPress
	local onRelease = self._onRelease

	local buttonEvent = {}
	if (self._id) then
		buttonEvent.id = self._id
	end

	local phase = event.phase
	local bounds = self.contentBounds
	local eventX,eventY = event.x,event.y
	local outOfBounds = bounds.xMin >= eventX or bounds.xMax <= eventX or bounds.yMin >= eventY or bounds.yMax <= eventY
	local inBounds = not outOfBounds
	local notPressed = not isPressed
	
	-- in bounds and not registered as pressed yet
	if inBounds and notPressed or phase == "began" then
		isPressed = true
		
		if over then
			default.isVisible = false
			over.isVisible = true
		end

		if onEvent then
			buttonEvent.phase = "press"
			result = onEvent( buttonEvent )
		elseif onPress then
			result = onPress( event )
		end
	-- going out of bounds or the touch is ending (this doesn't work very well)
	-- i could have the animate function reset the bool values every time and check if the button is hit every time
	elseif outOfBounds or phase == "ended" or phase == "cancelled" then
		isPressed = false
		
		if over then
			default.isVisible = true
			over.isVisible = false
		end
		
		if onEvent then
			buttonEvent.phase = "release"
			result = onEvent( buttonEvent )
		elseif onRelease then
			result = onRelease( event )
		end
	end
	
	--print ("isPressed = " .. tostring(isPressed))
	--print ("outOfBounds = " .. tostring(outOfBounds))
	--print ("xMin = " .. bounds.xMin)
	--print ("eventX = " .. event.x)

	return result
end



---------------
-- Scalable button class

function newButtonRect( params )
	local button, default, over, pressed
	isPressed = false
	
	if params.default then
		button = display.newGroup()
		default = display.newImageRect( params.default, params.width, params.height )
		button:insert( default, true )
	end
	
	if params.over then
		over = display.newImageRect( params.over, params.width, params.height )
		over.isVisible = false
		button:insert( over, true )
	end
	
	if params.x then
		button.x = params.x
	end
	
	if params.y then
		button.y = params.y
	end
	
	if params.alpha then
		button.alpha = params.alpha
	end
	
	if params.id then
		button._id = params.id
	end
	
	-- Public methods
	if ( params.onPress and ( type(params.onPress) == "function" ) ) then
		button._onPress = params.onPress
	end
	if ( params.onRelease and ( type(params.onRelease) == "function" ) ) then
		button._onRelease = params.onRelease
	end
	
	if (params.onEvent and ( type(params.onEvent) == "function" ) ) then
		button._onEvent = params.onEvent
	end
	
	-- Set button as a table listener by setting a table method and adding the button as its own table listener for "touch" events
	button.touch = newButtonHandler
	button:addEventListener( "touch", button )
	
	return button
end

