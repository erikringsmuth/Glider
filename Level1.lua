module(..., package.seeall)

local GameObjects = require("GameObjects")
local Room = require("Room")
local Level = require("Level")

--[[
Level 1
--]]
Level1 = Level.Level:new{
	fileName = "Level1",
	
	rooms = {
		Room.Room:new{
			number = 1,
			backgroundImageName = imageDir .. "Room1-1.png",
			backgroundLeftRoomImageName = imageDir .. "Room1-2.png",
			backgroundRightRoomImageName = imageDir .. "Room1-2.png",
			roomObjects = {
				GameObjects.LeftWall:new(),
				GameObjects.RightScreenTeleport:new({moveToRoom = 2}),
				GameObjects.Floor:new(),
				GameObjects.FloorVent:new({x = 330}),
				GameObjects.FloorVent:new({x = 540}),
				GameObjects.FloorVent:new({x = 710}),
			},
		},
		
		Room.Room:new{
			number = 2,
			backgroundImageName = imageDir .. "Room1-2.png",
			backgroundLeftRoomImageName = imageDir .. "Room1-1.png",
			backgroundRightRoomImageName = imageDir .. "Room1-1.png",
			roomObjects = {
				GameObjects.LeftScreenTeleport:new({moveToRoom = 1}),
				GameObjects.RightWall:new(),
				GameObjects.Floor:new(),
				GameObjects.FloorVent:new({x = 200}),
				GameObjects.FloorVent:new({x = 400}),
			},
		},
	},
}
