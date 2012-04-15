module(..., package.seeall)

local Glider = require("Glider")
local Controls = require("Controls")
local Room = require("Room")
local StatusBar = require("StatusBar")

--[[
Levels
--]]
Level = {
	fileName,
	score = 0,
	lives = 2,  -- This will be defaulted to 5
	boost = 0,
	rubberbands = 0,
	rooms,
	currentRoomNumber = 1,
	glider,
	controls,
	statusBar,
	paused = true,
	newRoomLoaded = false, -- When a new room is loaded the glider needs to stop checking interaction in the current room, checking this allows it to break from the loop
	levelDisplayGroup,
}

function Level:new (o)
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function Level:getFileName()
	return self.fileName
end

function Level:getScore()
	return self.score
end

function Level:addScore(points)
	self.score = self.score + points
	self.statusBar:setScore(self.score)
end

function Level:addLife()
	if self.lives <= 99 then
		self.lives = self.lives + 1
		self.statusBar:setLives(self.lives)
	end
end

function Level:getLives()
	return self.lives
end

function Level:loseLife()
	self.lives = self.lives - 1
	if self.lives >= 0 then
		self.statusBar:setLives(self.lives)
	else
		self:gameOver()
	end
end

function Level:addBoost()
	self.boost = self.boost + 50
	if self.boost > 100 then
		self.boost = 100
	end
	self.statusBar:setBoost(self.boost)
end

function Level:useBoost()
	if self.boost > 0 then
		self.boost = self.boost - 1
		self.statusBar:setBoost(self.boost)
		return true
	end
	return false
end

function Level:addRubberbands()
	self.rubberbands = self.rubberbands + 5
	if self.rubberbands > 20 then
		self.rubberbands = 20
	end
	self.statusBar:setRubberbands(self.rubberbands)
end

function Level:useRubberband()
	if self.rubberbands > 0 then
		self.rubberbands = self.rubberbands - 1
		self.statusBar:setRubberbands(self.rubberbands)
		return true
	end
	return false
end

function Level:addRoom( room )
	if not self.rooms then
		self.rooms = {}
	end
	table.insert(self.rooms, room:getNumber(), room)
end

function Level:setCurrentRoomNumber ( currentRoomNumber )
	self.currentRoomNumber = currentRoomNumber
end

function Level:getCurrentRoom()
	return self.rooms[self.currentRoomNumber]
end

function Level:moveToRoom( roomNumber )
	self.newRoomLoaded = true
	self:getCurrentRoom():unloadRoom()
	self:setCurrentRoomNumber(roomNumber)
	self:getCurrentRoom():loadRoom()
	self:orderDisplayObjects()
end

function Level:getGlider()
	return self.glider
end

function Level:getControls()
	return self.controls -- ****** Error, says self is a nil value *******
end

function Level:pause()
	self.paused = true
end

function Level:unpause()
	self.paused = false
end

function Level:checkNewRoomLoaded()
	return self.newRoomLoaded
end

function Level:acknowledgeNewRoomLoaded()
	self.newRoomLoaded = false
end

function Level:orderDisplayObjects()
	self.levelDisplayGroup:insert(self:getCurrentRoom().roomDisplayGroup)
	self.levelDisplayGroup:insert(self.statusBar.statusBarDisplayGroup)
	self.levelDisplayGroup:insert(self.controls.controlsDisplayGroup)
	self.levelDisplayGroup:insert(self.glider.image)
end

function Level:startLevel()
	if not self.levelDisplayGroup then
		self.levelDisplayGroup = display.newGroup()
	end
	
	-- Load the current room
	self:getCurrentRoom():loadRoom()
	
	-- Load the status bar
	self.statusBar = StatusBar.StatusBar:new()
	self.statusBar:loadStatusBar(self.score, self.lives, self.boost, self.rubberbands)
	
	-- Load the controls
	self.controls = Controls.Controls:new()
	self.controls:loadControls(self)
	
	-- Initialize the glider object
	self.glider = Glider.Glider:new( {level = self, x = self:getCurrentRoom().gliderStartPositionX, y = self:getCurrentRoom().gliderStartPositionY} )
	self.glider:loadImage()
	self.glider:startAnimation()
	
	-- Order all display objects
	self:orderDisplayObjects()
end

function Level:gameOver()
	-- Show "Game Over" and the score over a faded background
	local GameOverMenu = require("GameOverMenu")
	local gameOverMenu = GameOverMenu.GameOverMenu:new()
	gameOverMenu:loadMenu(self)
end

function Level:unloadLevel()
	-- Unload the level objects
	self:getCurrentRoom():unloadRoom()
	self.controls:unloadControls()
	self.statusBar:unloadStatusBar()
	self.glider:stopAnimation()
	self.glider:unloadImage()
	
	-- Remove objects in the level's display group
	for i=self.levelDisplayGroup.numChildren,1,-1 do
        self.levelDisplayGroup[i]:removeSelf()
	end
	self.levelDisplayGroup = nil
end
