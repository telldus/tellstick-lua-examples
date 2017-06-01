-- Scene script for Fibaro Dimmer 2
-- One click turns on a device, double click turns it off. 
-- Please note that configuration 28 has to be set to activated to handle scene commands.
-- Define the names on your devices here:
local remotecontrol = "Dimmer 2"
local device = "test"
debug = true

-- DO NOT EDIT BELOW THIS LINE --

COMMAND_CLASS_SCENE_ACTIVATION = 0x2B

S1_KEY_PRESS = 0x10
S1_KEY_DOUBLE = 0x0E
--S1_KEY_TRIPPLE is reserved for Node Information Frame
S1_KEY_HOLD = 0x0C
S1_KEY_RELEASE = 0x0D

S2_KEY_PRESS = 0x1A
S2_KEY_DOUBLE = 0x18
S2_KEY_TRIPPLE = 0x19
S2_KEY_HOLD = 0x16
S2_KEY_RELEASE = 0x17

local deviceManager = require "telldus.DeviceManager"


function sceneS1KeyPress()
	dbg("Do nothing")
end

function sceneS1KeyDouble()
	dbg("Do nothing")
end

function sceneS1KeyHold()
	dbg("Do nothing")
end

function sceneS1KeyRelease()
	dbg("Do nothing")
end

function sceneS2KeyPress()
	local device = deviceManager:findByName(device)
	device:command("turnon", nil, "Scene")
	if debug == true then
		print("Turning on device: %s", device:name())
	end
end

function sceneS2KeyDouble()
	local device = deviceManager:findByName(device)
	device:command("turnoff", nil, "Scene")
	if debug == true then
		print("Turning off device: %s", device:name())
	end
end

function sceneS2KeyTripple()
	dbg("Do nothing")
end

function sceneS2KeyHold()
	dbg("Do nothing")
end

function sceneS2KeyRelease()
	dbg("Do nothing")
end

function onZwaveMessageReceived(device, flags, cmdClass, cmd, data)
	if device:name() ~= remotecontrol then
		return
	end
	if cmdClass ~= COMMAND_CLASS_SCENE_ACTIVATION then
		return
	end
	local scene = data[0]
	if debug == true then
		print("COMMAND_CLASS_SCENE_ACTIVATION from Device: %s, Scene: %s", device:name(), scene)
	end
	if scene == S1_KEY_PRESS then
		dbg("S1 KEY_PRESS")
		sceneS1KeyPress()
	elseif scene == S1_KEY_DOUBLE then
		dbg("S1 KEY_DOUBLE")
		sceneS1KeyDouble()
	elseif scene == S1_KEY_TRIPPLE then
		dbg("S1 KEY_TRIPPLE")
		sceneS1KeyTripple()
	elseif scene == S1_KEY_HOLD then
		dbg("S1 KEY_HOLD")
		sceneS1KeyHold()
	elseif scene == S1_KEY_RELEASE then
		dbg("S1 KEY_RELEASE")
		sceneS1KeyRelease()
	elseif scene == S2_KEY_PRESS then
		dbg("S2 KEY_PRESS")
		sceneS2KeyPress()
	elseif scene == S2_KEY_DOUBLE then
		dbg("S2 KEY_DOUBLE")
		sceneS2KeyDouble()
	elseif scene == S2_KEY_TRIPPLE then
		dbg("S2 KEY_TRIPPLE")
		sceneS2KeyTripple()
	elseif scene == S2_KEY_HOLD then
		dbg("S2 KEY_HOLD")
		sceneS2KeyHold()
	elseif scene == S2_KEY_RELEASE then
		dbg("S2 KEY_RELEASE")
		sceneS2KeyRelease()
	end
end
	
function dbg(str)
	if debug == true then
		print(str)
	end
end
