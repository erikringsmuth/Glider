module(..., package.seeall)

local GameObjects = require("GameObjects")

--[[
Rooms
--]]
Room = {
	number = 1,
	gliderStartPositionX = 120,
	gliderStartPositionY = 120,
	roomObjects, -- Don't initialize this here, each instance needs to initialize lists themselves
	backgroundImageName,
	background,
	backgroundLeftRoomImageName,
	backgroundLeftRoom,
	backgroundRightRoomImageName,
	backgroundRightRoom,
	roomDisplayGroup,
}

function Room:new (o)
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function Room:setGliderStartPositionX( x )
	self.gliderStartPositionX = x
end

function Room:setGliderStartPositionY( y )
	self.gliderStartPositionY = y
end

function Room:getGliderStartPositionX()
	return self.gliderStartPositionX
end

function Room:getGliderStartPositionY()
	return self.gliderStartPositionY
end

function Room:setNumber ( number )
	self.number = number
end

function Room:getNumber ()
	return self.number
end

function Room:addObject ( roomObject )
	if not self.roomObjects then
		self.roomObjects = {}
	end
	table.insert(self.roomObjects, roomObject)
end

function Room:getObjects()
	return self.roomObjects
end

function Room:setBackgroundImageName ( backgroundImageName )
	self.backgroundImageName = backgroundImageName
end

function Room:loadRoom()
	if not self.roomDisplayGroup then
		self.roomDisplayGroup = display.newGroup()
	end
	
	-- Load the room background
	self.background = GameObjects.Background:new({ imageName = self.backgroundImageName })
	self.background:loadImage()
	self.roomDisplayGroup:insert(self.background.image)
	
	-- If it's a wide aspect ratio (most Android devices) then show the adjacent room's backgrounds
	if display.screenOriginX < 0 then
		print("wide aspect ratio " .. display.screenOriginX)
		if self.backgroundLeftRoomImageName then
			self.backgroundLeftRoom = GameObjects.BackgroundLeftRoom:new({ imageName = self.backgroundLeftRoomImageName })
			self.backgroundLeftRoom:loadImage()
			self.roomDisplayGroup:insert(self.backgroundLeftRoom.image)
		end
		if self.backgroundRightRoomImageName then
			self.backgroundRightRoom = GameObjects.BackgroundRightRoom:new({ imageName = self.backgroundRightRoomImageName })
			self.backgroundRightRoom:loadImage()
			self.roomDisplayGroup:insert(self.backgroundRightRoom.image)
		end
	elseif display.screenOriginY < 0 then -- If it's a tall aspect ratio (iPad) then add a filler on the top and bottom
		print("tall aspect ratio " .. display.screenOriginY)
		local topFiller = GameObjects.TopFiller:new()
		topFiller:loadImage()
		self.roomDisplayGroup:insert(topFiller.image)
		local bottomFiller = GameObjects.BottomFiller:new()
		bottomFiller:loadImage()
		self.roomDisplayGroup:insert(bottomFiller.image)
	end
	
	-- Load the objects and start any animations
	for _,roomObject in ipairs(self.roomObjects) do
		if roomObject:loadImage() then
			self.roomDisplayGroup:insert(roomObject.image)
		end
	end
end

function Room:unloadRoom()
	-- Remove all the room objects' images from the display group
	for i=self.roomDisplayGroup.numChildren,1,-1 do
        self.roomDisplayGroup[i]:removeSelf()
	end
	self.roomDisplayGroup = nil
	
	-- Nil all the references to the room objects' images
	for i,roomObject in ipairs(self.roomObjects) do
		roomObject.image = nil
	end
	self.background.image = nil
	
	-- Wide aspect ratios need to nil the right and left background images
	if wideAspectRatio then
		if self.backgroundLeftRoom then
			self.backgroundLeftRoom.image = nil
		end
		if self.backgroundRightRoom then
			self.backgroundRightRoom.image = nil
		end
	end
end
