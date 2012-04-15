module(..., package.seeall)

--[[
Status Bar
--]]
StatusBar = {
	scoreText,
	livesText,
	boostText,
	rubberbandsText,
	background,
	statusBarDisplayGroup,
}

function StatusBar:new (o)
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function StatusBar:loadStatusBar(score, lives, boost, rubberbands)
	if not self.statusBarDisplayGroup then
		self.statusBarDisplayGroup = display.newGroup()
	end
	
	self.background = display.newImageRect(imageDir .. "StatusBar.png", 1280, 36)
	self.background.x = display.contentWidth / 2
	self.background.y = 17 + display.screenOriginY
	self.statusBarDisplayGroup:insert(self.background)
	
	self.scoreText = display.newText( "Score: " .. score, 85, display.screenOriginY, native.systemFont, 26 )
	--self.scoreText:setTextColor(0, 0, 0)
	self.statusBarDisplayGroup:insert( self.scoreText )
	self.livesText = display.newText( "Extra Lives: " .. lives, display.contentWidth - 240, display.screenOriginY, native.systemFont, 26 )
	--self.livesText:setTextColor(0, 0, 0)
	self.statusBarDisplayGroup:insert( self.livesText )
	self.boostText = display.newText( "Boost: " .. boost, display.contentWidth - 400, display.screenOriginY, native.systemFont, 26 )
	--self.boostText:setTextColor(0, 0, 0)
	self.statusBarDisplayGroup:insert( self.boostText )
	self.rubberbandsText = display.newText( "Rubberbands: " .. rubberbands, display.contentWidth - 670, display.screenOriginY, native.systemFont, 26 )
	--self.rubberbandsText:setTextColor(0, 0, 0)
	self.statusBarDisplayGroup:insert( self.rubberbandsText )
end

function StatusBar:unloadStatusBar()
	-- Remove all the text objects from the display group
	for i=self.statusBarDisplayGroup.numChildren,1,-1 do
        self.statusBarDisplayGroup[i]:removeSelf()
	end
	self.statusBarDisplayGroup = nil
	
	-- Nil all the references to the text objects
	self.scoreText = nil
	self.livesText = nil
	self.boostText = nil
	self.rubberbandsText = nil
	self.background = nil
end

function StatusBar:setScore(score)
	self.scoreText.text = "Score: " .. score
end

function StatusBar:setLives(lives)
	self.livesText.text = "Extra Lives: " .. lives
end

function StatusBar:setBoost(boost)
	self.boostText.text = "Boost: " .. boost
end

function StatusBar:setRubberbands(rubberbands)
	self.rubberbandsText.text = "Rubberbands: " .. rubberbands
end
