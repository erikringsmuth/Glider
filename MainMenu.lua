module(..., package.seeall)

local UI = require("UI2")

--[[
Main Menu
--]]
MainMenu = {
	levelSelectButton,
	highScoresButton,
	settingsButton,
	backgound,
	menuDisplayGroup,
}

function MainMenu:new (o)
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function MainMenu:loadMenu()
	if not self.menuDisplayGroup then
		self.menuDisplayGroup = display.newGroup()
	end
	
	-- Menu backgound
	self.background = display.newImageRect(imageDir .. "MainMenuBackground.png", 1280, 800)
	self.menuDisplayGroup:insert(self.background)
	self.background.x = display.contentWidth / 2
	self.background.y = display.contentHeight / 2
	
	-- Button event handlers
	local function levelSelectHandler ( event )
		if event.phase == "release" then
			self:unloadMenu()
			local LevelSelectMenu = require("LevelSelectMenu")
			local levelSelectMenu = LevelSelectMenu.LevelSelectMenu:new()
			levelSelectMenu:loadMenu()
		end
	end
	
	local function highScoresHandler ( event )
		if event.phase == "release" then
			-- High Scores Menu
		end
	end
	
	local function settingsHandler ( event )
		if event.phase == "release" then
			-- Settings Menu
		end
	end
	
	-- Create the buttons and set their event handlers
	self.levelSelectButton = UI.newButtonRect{
			default = imageDir .. "MainMenuLevelSelectButton.png",
			onEvent = levelSelectHandler,
			width = 442,
			height = 88,
			x = display.contentWidth / 2,
			y = display.contentHeight / 4,
	}
	self.menuDisplayGroup:insert( self.levelSelectButton )
	
	self.highScoresButton = UI.newButtonRect{
			default = imageDir .. "MainMenuHighScoresButton.png",
			onEvent = highScoresHandler,
			width = 442,
			height = 88,
			x = display.contentWidth / 2,
			y = display.contentHeight / 2,
	}
	self.menuDisplayGroup:insert( self.highScoresButton )
	
	self.settingsButton = UI.newButtonRect{
			default = imageDir .. "MainMenuSettingsButton.png",
			onEvent = settingsHandler,
			width = 442,
			height = 88,
			x = display.contentWidth / 2,
			y = display.contentHeight * 3 / 4,
	}
	self.menuDisplayGroup:insert( self.settingsButton )
end

function MainMenu:unloadMenu()
	-- Remove all the Main Menu's images from the display group
	for i=self.menuDisplayGroup.numChildren,1,-1 do
        self.menuDisplayGroup[i]:removeSelf()
	end
	self.menuDisplayGroup = nil
	
	-- Nil all the references to the Main Menu's images
	self.levelSelectButton = nil
	self.highScoresButton = nil
	self.settingsButton = nil
	self.background = nil
end
