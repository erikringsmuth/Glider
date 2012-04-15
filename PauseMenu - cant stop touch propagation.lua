module(..., package.seeall)

local Button = require("Button")

--[[
Pause Menu
--]]
PauseMenu = {
	resumeButton,
	endLevelButton,
	background,
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
	local function resumeButtonReleased (  )
		self:unloadMenu()
	end
	
	local function endLevelButtonReleased (  )
		self:unloadMenu()
		level:gameOver()
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
	self.resumeButton = Button.Button:new{
			imageDefaultName = imageDir .. "PauseMenuResumeButton.png",
			onRelease = resumeButtonReleased,
			width = 442,
			height = 88,
			x = display.contentWidth / 2,
			y = display.contentHeight / 3,
	}
	self.resumeButton:loadButton()
	self.menuDisplayGroup:insert( self.resumeButton.buttonDisplayGroup )
	
	self.endLevelButton = Button.Button:new{
			imageDefaultName = imageDir .. "PauseMenuEndLevelButton.png",
			onRelease = endLevelButtonReleased,
			width = 442,
			height = 88,
			x = display.contentWidth / 2,
			y = display.contentHeight * 2 / 3,
	}
	self.endLevelButton:loadButton()
	self.menuDisplayGroup:insert( self.endLevelButton.buttonDisplayGroup )
end

function PauseMenu:unloadMenu()
	self.resumeButton:unloadButton()
	self.endLevelButton:unloadButton()
	
	-- Remove all the menu's images from the display group
	for i=self.menuDisplayGroup.numChildren,1,-1 do
        self.menuDisplayGroup[i]:removeSelf()
	end
	self.menuDisplayGroup = nil
	
	-- Nil all the references to the menu's images
	self.resumeButton = nil
	self.endLevelButton = nil
	self.background = nil
end