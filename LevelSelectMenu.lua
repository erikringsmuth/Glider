module(..., package.seeall)

local UI = require("UI2")

--[[
Level Select Menu
--]]
LevelSelectMenu = {
	back,
	backgound,
	level1,
	level2,
	menuDisplayGroup,
}

function LevelSelectMenu:new (o)
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function LevelSelectMenu:loadMenu()
	if not self.menuDisplayGroup then
		self.menuDisplayGroup = display.newGroup()
	end
	
	-- Menu backgound
	self.background = display.newImageRect(imageDir .. "MainMenuBackground.png", 1280, 800)
	self.menuDisplayGroup:insert(self.background)
	self.background.x = display.contentWidth / 2
	self.background.y = display.contentHeight / 2
	
	-- Button event handlers
	local function backHandler ( event )
		if event.phase == "release" then
			self:unloadMenu()
			local MainMenu = require("MainMenu")
			local mainMenu = MainMenu.MainMenu:new()
			mainMenu:loadMenu()
		end
	end
	
	local function level1Handler ( event )
		if event.phase == "release" then
			self:unloadMenu()
			local Level1 = require("Level1")
			local level1 = Level1.Level1:new()
			level1:startLevel()
		end
	end
	
	local function level2Handler ( event )
		if event.phase == "release" then
			self:unloadMenu()
			local Level2 = require("Level2")
			local level2 = Level2.Level2:new()
			level2:startLevel()
		end
	end
	
	-- Create the buttons and set their event handlers
	self.backButton = UI.newButtonRect{
			default = imageDir .. "BackButton.png",
			onEvent = backHandler,
			width = 154,
			height = 68,
			x = 80,
			y = 40,
	}
	self.menuDisplayGroup:insert( self.backButton )
	
	self.level1Button = UI.newButtonRect{
			default = imageDir .. "Level1Button.png",
			onEvent = level1Handler,
			width = 442,
			height = 88,
			x = display.contentWidth / 2,
			y = display.contentHeight / 4,
	}
	self.menuDisplayGroup:insert( self.level1Button )
	
	self.level2Button = UI.newButtonRect{
			default = imageDir .. "Level2Button.png",
			onEvent = level2Handler,
			width = 442,
			height = 88,
			x = display.contentWidth / 2,
			y = display.contentHeight / 2,
	}
	self.menuDisplayGroup:insert( self.level2Button )

end

function LevelSelectMenu:unloadMenu()
	-- Remove all the menu's images from the display group
	for i=self.menuDisplayGroup.numChildren,1,-1 do
        self.menuDisplayGroup[i]:removeSelf()
	end
	self.menuDisplayGroup = nil
	
	-- Nil all the references to the menu's images
	self.level1 = nil
	self.level2 = nil
	self.back = nil
	self.background = nil
end