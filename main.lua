--[[
To Do:

-- Game Over Menu can't "retry" a level

-- Add event listeners if the application is exited [http://developer.anscamobile.com/content/events-and-listeners]

-- Research isVisible [http://developer.anscamobile.com/content/memory-management-changes-corona-sdk-beta-8] at bottom

-- The glider sometimes starts on the wrong side after you've played the level once

-- Levels aren't resetting when they're done

-- Fix classes [http://lua-users.org/wiki/SimpleLuaClasses]

-- Re-do the level select menu

-- Create an XML importer for levels

-- Redo menus with the Button class instead of UI2.  Need to do: Main Menu, Level Select Menu, Game Over Menu, Pause Menu (in progress, can't stop touch propagation)

--]]

-- Setup environment
display.setStatusBar( display.HiddenStatusBar )
system.activate( "multitouch" )

-- Global variables
imageDir = "gliderImages/"

-- Start at the main menu
local MainMenu = require("MainMenu")
local mainMenu = MainMenu.MainMenu:new()
mainMenu:loadMenu()
