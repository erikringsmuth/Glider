module(..., package.seeall)

local Button = require("Button")

--[[
Controls
--]]
Controls = {
	moveRight = false,
	moveLeft = false,
	boost = false,
	rubberband = false,
	buttonLeft,
	buttonRight,
	buttonRubberband,
	buttonBoost,
	buttonPause,
	controlsDisplayGroup,
}

function Controls:new (o)
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function Controls:loadControls(level)
	if not self.controlsDisplayGroup then
		self.controlsDisplayGroup = display.newGroup()
	end
	
	-- Button event handlers
	local function leftButtonPress ( )
		self.moveLeft = true
	end

	local function leftButtonRelease ( )
		self.moveLeft = false
	end

	local function rightButtonPress ( )
		self.moveRight = true
	end

	local function rightButtonRelease ( )
		self.moveRight = false
	end
	
	local function boostButtonPress ( )
		self.boost = true
	end

	local function boostButtonRelease ( )
		self.boost = false
	end

	local function rubberbandButtonPress ( )
		-- Shoot rubberband
	end
	
	local function pauseButtonRelease ( )
		level:pause()
		local PauseMenu = require("PauseMenu")
		local pauseMenu = PauseMenu.PauseMenu:new()
		pauseMenu:loadMenu(level)
	end
	
	-- Create the buttons and set their event handlers
	self.buttonLeft = Button.Button:new{
			imageDefaultName = imageDir .. "ButtonArrowRight.png",
			imageOverName = imageDir .. "ButtonArrowRightDark.png",
			onPress = leftButtonPress,
			onRelease = leftButtonRelease,
			width = 106,
			height = 106,
			x = 75 + display.screenOriginX,
			y = display.contentHeight - 64,
			alpha = .7,
	}
	self.buttonLeft:loadButton()
	self.buttonLeft.buttonDisplayGroup:rotate(180)
	self.controlsDisplayGroup:insert( self.buttonLeft.buttonDisplayGroup )

	self.buttonRight = Button.Button:new{
			imageDefaultName = imageDir .. "ButtonArrowRight.png",
			imageOverName = imageDir .. "ButtonArrowRightDark.png",
			onPress = rightButtonPress,
			onRelease = rightButtonRelease,
			width = 106,
			height = 106,
			x = 195 + display.screenOriginX,
			y = display.contentHeight - 64,
			alpha = .7,
	}
	self.buttonRight:loadButton()
	self.controlsDisplayGroup:insert( self.buttonRight.buttonDisplayGroup )
	
	self.buttonBoost = Button.Button:new{
			imageDefaultName = imageDir .. "ButtonBoost.png",
			imageOverName = imageDir .. "ButtonBoostDark.png",
			onPress = boostButtonPress,
			onRelease = boostButtonRelease,
			width = 106,
			height = 106,
			x = display.contentWidth - 180 - display.screenOriginX,
			y = display.contentHeight - 80,
			alpha = .7,
	}
	self.buttonBoost:loadButton()
	self.controlsDisplayGroup:insert( self.buttonBoost.buttonDisplayGroup )

	self.buttonRubberband = Button.Button:new{
			imageDefaultName = imageDir .. "ButtonRubberband.png",
			imageOverName = imageDir .. "ButtonRubberbandDark.png",
			onPress = rubberbandButtonPress,
			width = 106,
			height = 106,
			x = display.contentWidth - 72  - display.screenOriginX,
			y = display.contentHeight - 150,
			alpha = .7,
	}
	self.buttonRubberband:loadButton()
	self.controlsDisplayGroup:insert( self.buttonRubberband.buttonDisplayGroup )
	
	self.buttonPause = Button.Button:new{
			imageDefaultName = imageDir .. "ButtonPause.png",
			onRelease = pauseButtonRelease,
			width = 100,
			height = 70,
			x = 20,
			y = 40 + display.screenOriginY,
			alpha = .7,
	}
	self.buttonPause:loadButton()
	self.controlsDisplayGroup:insert( self.buttonPause.buttonDisplayGroup )
end

function Controls:unloadControls()
	-- Unload all the buttons
	self.buttonLeft:unloadButton()
	self.buttonRight:unloadButton()
	self.buttonRubberband:unloadButton()
	self.buttonBoost:unloadButton()
	self.buttonPause:unloadButton()
	
	-- Remove all the controls' images from the display group
	for i=self.controlsDisplayGroup.numChildren,1,-1 do
        self.controlsDisplayGroup[i]:removeSelf()
	end
	self.controlsDisplayGroup = nil
	
	-- Nil all the references to the controls' images
	self.buttonLeft = nil
	self.buttonRight = nil
	self.buttonRubberband = nil
	self.buttonBoost = nil
	self.buttonPause = nil
end