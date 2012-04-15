module(..., package.seeall)

local UI = require("UI2")

--[[
Pause Menu
--]]
PauseMenu = {
	resume,
	endLevel,
	menuDisplayGroup,
}

function PauseMenu:new (o)
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function PauseMenu:loadMenu(level)
	if not self.menuDisplayGroup then
		self.menuDisplayGroup = display.newGroup()
	end
	
	-- Button event handlers
	local function resumeHandler ( event )
		if event.phase == "release" then
			self:unloadMenu()
		end
	end
	
	local function endLevelHandler ( event )
		if event.phase == "release" then
			self:unloadMenu()
			level:gameOver()
		end
	end
	
	local function stopTouchPropagation ( event )
		return true
	end
	
	-- Menu backgound
	self.background = display.newImageRect(imageDir .. "PauseMenuBackground.png", 1280, 800)
	self.menuDisplayGroup:insert(self.background)
	self.background.x = display.contentWidth / 2
	self.background.y = display.contentHeight / 2
	self.background.alpha = .9
	self.background:addEventListener( "touch", stopTouchPropagation )
	
	-- Create the buttons and set their event handlers
	self.resume = UI.newButtonRect{
			default = imageDir .. "PauseMenuResumeButton.png",
			onEvent = resumeHandler,
			width = 442,
			height = 88,
			x = display.contentWidth / 2,
			y = display.contentHeight / 3,
	}
	self.menuDisplayGroup:insert( self.resume )
	
	self.endLevel = UI.newButtonRect{
			default = imageDir .. "PauseMenuEndLevelButton.png",
			onEvent = endLevelHandler,
			width = 442,
			height = 88,
			x = display.contentWidth / 2,
			y = display.contentHeight * 2 / 3,
	}
	self.menuDisplayGroup:insert( self.endLevel )

end

function PauseMenu:unloadMenu()
	-- Remove all the menu's images from the display group
	for i=self.menuDisplayGroup.numChildren,1,-1 do
        self.menuDisplayGroup[i]:removeSelf()
	end
	self.menuDisplayGroup = nil
	
	-- Nil all the references to the menu's images
	self.resume = nil
	self.endLevel = nil
	self.background = nil
end