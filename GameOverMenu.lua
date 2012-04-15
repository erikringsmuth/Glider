module(..., package.seeall)

local UI = require("UI2")

--[[
Game Over Menu
--]]
GameOverMenu = {
	scoreText,
	retry,
	mainMenu,
	menuDisplayGroup,
}

function GameOverMenu:new (o)
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function GameOverMenu:loadMenu(level)
	if not self.menuDisplayGroup then
		self.menuDisplayGroup = display.newGroup()
	end
	
	-- Button event handlers
	local function retryHandler ( event )
		if event.phase == "release" then
			--[[
			local levelFileName = level:getFileName()
			local ThisLevel = require(levelFileName)
			local thisLevel = ThisLevel.ThisLevel:new() -- The variable after the dot needs to be spelled as the level name
			self:unloadMenu()
			level:unloadLevel()
			thisLevel:startLevel()
			--]]
			level = level:new()
			self:unloadMenu()
			level:unloadLevel()
			level:startLevel()
		end
	end
	
	local function mainMenuHandler ( event )
		if event.phase == "release" then
			-- Unload the Game Over Menu and the Level
			self:unloadMenu()
			level:unloadLevel()
			
			-- Go to the main menu
			local MainMenu = require("MainMenu")
			local mainMenu = MainMenu.MainMenu:new()
			mainMenu:loadMenu()
		end
	end
	
	local function stopTouchPropagation ( event )
		return true -- Any touch event that returns true stops propagation of the event
	end
	
	-- Menu backgound
	self.background = display.newImageRect(imageDir .. "PauseMenuBackground.png", 1280, 800)
	self.menuDisplayGroup:insert(self.background)
	self.background.x = display.contentWidth / 2
	self.background.y = display.contentHeight / 2
	self.background.alpha = .9
	self.background:addEventListener( "touch", stopTouchPropagation )
	
	-- Score text
	self.scoreText = display.newText( "Score: " .. level:getScore(), 280, display.contentHeight / 4, native.systemFont, 56 )
	self.menuDisplayGroup:insert( self.scoreText )
	
	-- Create the buttons and set their event handlers
	self.retry = UI.newButtonRect{
			default = imageDir .. "GameOverMenuRetryButton.png",
			onEvent = retryHandler,
			width = 442,
			height = 88,
			x = display.contentWidth / 2,
			y = display.contentHeight / 2,
	}
	self.menuDisplayGroup:insert( self.retry )
	
	self.mainMenu = UI.newButtonRect{
			default = imageDir .. "GameOverMenuMainMenuButton.png",
			onEvent = mainMenuHandler,
			width = 442,
			height = 88,
			x = display.contentWidth / 2,
			y = display.contentHeight * 3 / 4,
	}
	self.menuDisplayGroup:insert( self.mainMenu )

end

function GameOverMenu:unloadMenu()
	-- Remove all the menu's images from the display group
	for i=self.menuDisplayGroup.numChildren,1,-1 do
        self.menuDisplayGroup[i]:removeSelf()
	end
	self.menuDisplayGroup = nil
	
	-- Nil all the references to the menu's images
	self.scoreText = nil
	self.retry = nil
	self.mainMenu = nil
	self.background = nil
end