-- *************************************************************************************************************************************************************************
-- Lua script for managing ID-locks (www.idlock.no/www.idlock.se) with TellStick ZNet Lite. Author Johan Stålnacke (johan@steelneck.net)
-- This script will help you associate multiple RFID-tags over one or more ID-locks installed on your TellStick ZNet Lite.
-- By setting up dummy devices in Telldus Live!, the script will trigger them as individually as the a specific lock is opened by a specific RFID-tag.
-- In Telldus Live! you can then trigger events as a specific tag opens a specific lock
-- If configured, the script also triggers dummy devices for all other locking events provided by the ID-locks
-- Here is an instruction of how to set up dummy devices: http://download.telldus.com/TellStick/Guides/Telldus_Guide_Create_Dummy_Device_en.pdf

-- Start the configuration of you ID-lock set up here:

-- Step 1: Register all the RFID-tags you want to use on one of your ID-locks. Remember the order in which you registered them to make it easier to identify them later.
-- Step 2: Include all ID-locks in your TellStick ZNet Lite
-- Step 3: Create a dummy device in Telldus Live! for each combination of lock and registered RFID-tag. 
--         These dummy devices will be triggered whenever the associated lock is opened with the associated RFID-tag as set up below
--         Give the devices names you can understand. I.e. "Basement door - Johan" or "Front door - Child 1"
-- Step 4: Run the script once in the TellStick Local Access Lua script handler.
--         This will print a list of all devices currently associated with your TellStick ZNet controller.
-- Step 5: Use the printout to add all device ids of all ID-locks included in the system to the list below in any order
--         EXAMPLE: local idLocks = list.new(1, 2)
local idLocks = list.new()

-- Step 6: Use the printout to add all device ids of all dummy devices created to the list below in any order
--         EXAMPLE: local rfidDummyDevices = list.new(3, 4, 5, 6, 7, 8)
local rfidDummyDevices = list.new()

-- Step 7: For each entry in the list of dummy devices above, add the corresponding device id of the associated ID-lock from the first list in the same order
--         EXAMPLE: local rfidDummyDeviceLocks = list.new(1, 1, 1, 2, 2, 2)
local rfidDummyDeviceLocks = list.new()

-- Step 8: Run the script again in the TellStick Local Access Lua script handler. After a while the RFID tag configuraton will be displayed in the console
--         N.B! If not tag configuration is displayed, try again. You might also try removing ALL batteries from your lock(s) and start over           
--         For each entry in the list of dummy devices above, add the corresponding RFID-tag code of the associated RFID-tag
--         EXAMPLE: local rfidDummyDeviceTagCodes = list.new("73ac2af1", "123d9e8", "ca329ea2", "73ac2af1", "123d9e8", "ca329ea2")
local rfidDummyDeviceTagCodes = list.new()

-- Step 9: Add additional dummy devices in Telldus Live! for each lock and each of the below listed events (if you want to)
--         Manual lock, Manual unlock, Remote unlock, Master PIN unlock, Service PIN unlock, Wrong PIN used, Tampering with door, Fire by door
--         Use the device printout and add the device ids of the new dummy devices to the lists below in the same order as the locks was listed first (idLocks above)
--         EXAMPLE: manualLockDummyDevices = list.new(9, 10)
local manualLockDummyDevices = list.new()
local manualUnlockDummyDevices = list.new()
local remoteUnlockDummyDevices = list.new()
local masterPinUnlockDummyDevices = list.new()
local servicePinUnlockDummyDevices = list.new()
local wrongPinDummyDevices = list.new()
local tamperingDummyDevices = list.new()
local fireDummyDevices = list.new()

-- ***************************************************************************************************************************************************************************

DEBUG_PRINTOUTS = true

COMMAND_CLASS_CONFIGURATION = 0x70
CONFIGURATION_GET = 0x5
START_TAG_INDEX = 10
END_TAG_INDEX = 59

COMMAND_CLASS_NOTIFICATION_V4 = 0x71
NOTIFICATION_TYPE_LOCK_OPERATION = 0x06
NOTIFICATION_TYPE_LOCK_TAMPERING = 0x07
NOTIFICATION_TYPE_LOCK_FIRE = 0x0A
NOTIFICATION_EVENT_MANUAL_LOCK = 0x01
NOTIFICATION_EVENT_MANUAL_UNLOCK = 0x02
NOTIFICATION_EVENT_RFID_UNLOCK = 0x04
NOTIFICATION_EVENT_KEYPAD_OR_REMOTE_UNLOCK = 0x06
NOTIFICATION_EVENT_KEYPAD_WRONG_PIN = 0x14
NOTIFICATION_PARAM1_REMOTE_UNLOCK = 0x00
NOTIFICATION_PARAM1_MASTER_PIN_UNLOCK = 0x01
NOTIFICATION_PARAM1_SERVICE_PIN_UNLOCK = 0x02

local deviceManager = require "telldus.DeviceManager"

local lockId = list.new()
local tagIndex = list.new()
local tagCode = list.new()
local configuredIDLocks = list.new()
local configurationPrinted = false

function onInit()
	printDevices()

	if list.len(idLocks) > 0 then
		print("Starting initial retrieval of all registered tags on all listed ID-locks")
		refreshAllValidTags()
	end
end

function onZwaveMessageReceived(device, flags, cmdClass, cmd, data)
	local currentDeviceId = device:id()

	if not isIdLockDevice(currentDeviceId) then
		return
	end

	if cmdClass == COMMAND_CLASS_CONFIGURATION then
		local currentTagId = makeTagId(data)
		local currentIndex = data[0]
		local indexReceivedBefore = indexRegistered(currentDeviceId, currentIndex)

		if DEBUG_PRINTOUTS then 
			print("Receiving tag config %s for index %s on door %s", currentTagId, currentIndex, currentDeviceId)
			if (indexReceivedBefore == 1) then 
				print("Index already received, skipping")
			end
		end

		if indexReceivedBefore == -1 then
			addValidTag(currentDeviceId, currentIndex, currentTagId)
			if currentTagId ~= "0000" and currentIndex < END_TAG_INDEX then
				requestRFIDConfiguration(currentDeviceId, currentIndex + 1)
			else
				finishedLockConfiguration(currentDeviceId)
			end
		end

		if checkLockConfigurationFinished() == 1 and not configurationPrinted then
			print("Configuration refresh finished. Here are all valid tags:")
			printValidTags()
			configurationPrinted = true
		end
		return
	end
	
	if cmdClass ~= COMMAND_CLASS_NOTIFICATION_V4 then
		return
	end

	local notType = data[4]
	local notEvent = data[5]
	local notPara1 = data[7]

	if notType == NOTIFICATION_TYPE_LOCK_OPERATION then
		if notEvent == NOTIFICATION_EVENT_MANUAL_LOCK then
			local dummyDeviceId = getManualLockDummyDeviceId(currentDeviceId)
			if dummyDeviceId ~= -1 then
				triggerDummyDevice(dummyDeviceId)
			end
		end

		if notEvent == NOTIFICATION_EVENT_MANUAL_UNLOCK then
			local dummyDeviceId = getManualUnlockDummyDeviceId(currentDeviceId)
			if dummyDeviceId ~= -1 then
				triggerDummyDevice(dummyDeviceId)
			end
		end

		if notEvent == NOTIFICATION_EVENT_RFID_UNLOCK then
			if DEBUG_PRINTOUTS then
				print("RFID unlock by index %s", notPara1)
				print("getRfidDummyDeviceId(%s, %s) = %s", currentDeviceId, notPara1, getRfidDummyDeviceId(currentDeviceId, notPara1))
			end
			local dummyDeviceId = getRfidDummyDeviceId(currentDeviceId, notPara1)
			if dummyDeviceId ~= -1 then
				triggerDummyDevice(dummyDeviceId)
			end
		end

		if notEvent == NOTIFICATION_EVENT_KEYPAD_OR_REMOTE_UNLOCK then
			if notPara1 == NOTIFICATION_PARAM1_REMOTE_UNLOCK then
				local dummyDeviceId = getRemoteUnlockDummyDeviceId(currentDeviceId)
				if dummyDeviceId ~= -1 then
					triggerDummyDevice(dummyDeviceId)
				end
			end
			if notPara1 == NOTIFICATION_PARAM1_MASTER_PIN_UNLOCK then
				local dummyDeviceId = getMasterPinUnlockDummyDeviceId(currentDeviceId)
				if dummyDeviceId ~= -1 then
					triggerDummyDevice(dummyDeviceId)
				end
			end
			if notPara1 == NOTIFICATION_PARAM1_SERVICE_PIN_UNLOCK then
				local dummyDeviceId = getServicePinUnlockDummyDeviceId(currentDeviceId)
				if dummyDeviceId ~= -1 then
					triggerDummyDevice(dummyDeviceId)
				end
			end
		end

		if notEvent == NOTIFICATION_EVENT_KEYPAD_WRONG_PIN then
			local dummyDeviceId = getWrongPinDummyDeviceId(currentDeviceId)
			if dummyDeviceId ~= -1 then
				triggerDummyDevice(dummyDeviceId)
			end
		end
	end

	if notType == NOTIFICATION_TYPE_LOCK_TAMPERING then
		local dummyDeviceId = getTamperingDummyDeviceId(currentDeviceId)
		if dummyDeviceId ~= -1 then
			triggerDummyDevice(dummyDeviceId)
		end
	end

	if notType == NOTIFICATION_TYPE_LOCK_FIRE then
		local dummyDeviceId = getFireDummyDeviceId(currentDeviceId)
		if dummyDeviceId ~= -1 then
			triggerDummyDevice(dummyDeviceId)
		end
	end
end

function refreshAllValidTags()
	lockId = list.new()
	tagIndex = list.new()
	tagCode = list.new()
	configuredIDLocks = list.new()

	for i = 0, list.len(idLocks) - 1, 1 do
		requestRFIDConfiguration(idLocks[i], START_TAG_INDEX)
	end
end

function finishedLockConfiguration(doorDeviceId)
	for i = 0, list.len(configuredIDLocks) - 1, 1 do
		if configuredIDLocks[i] == doorDeviceId then
			return
		end
	end
	configuredIDLocks.append(doorDeviceId)
end

function checkLockConfigurationFinished()
	if list.len(idLocks) == list.len(configuredIDLocks) then
		return 1
	else
		return 0
	end
end

function requestRFIDConfiguration(doorDeviceId, index)
	if DEBUG_PRINTOUTS then print ("Requesting tag nr %s from door %s", index, doorDeviceId) end
	local data = list.new(index)
	local device = deviceManager:device(doorDeviceId)
	local zwaveNode = device:zwaveNode()
	zwaveNode:sendMsg(COMMAND_CLASS_CONFIGURATION, CONFIGURATION_GET, data)
end

function addValidTag(doorDeviceId, index, code)
	if (code ~= "0000") then
		lockId.append(doorDeviceId)
		tagIndex.append(index)
		tagCode.append(code)
	end
end

function indexRegistered(doorDeviceId, index)
	for i = 0, list.len(lockId) - 1, 1 do
		if lockId[i] == doorDeviceId and tagIndex[i] == index then
			return 1
		end
	end
	return -1
end

function makeTagId(rawData)
	return string.format("%x%x%x%x", rawData[2], rawData[3], rawData[4], rawData[5])
end

function isIdLockDevice(deviceId)
	for i = 0, list.len(idLocks) - 1, 1 do
		if (idLocks[i] == deviceId) then
			return true
		end
	end
	return false
end

function printValidTags()
	for i = 0, list.len(tagCode) - 1, 1 do
		print("Door ID: %s, Index: %s, Tag: %s", lockId[i], tagIndex[i], tagCode[i])
	end
end

function printDevices()
	local deviceCount = list.len(deviceManager:retrieveDevices())
	local counter = 0
	local deviceId = 0

	print ("Devices on your TellStick ZNet controller:")
	while counter < deviceCount do
		local device = deviceManager:device(deviceId)
		if device ~= nil then
			print("ID: %s (%s)", device:id(), device:name())
			counter = counter + 1
		end
		deviceId = deviceId + 1
	end
end

function getRfidDummyDeviceId(doorDeviceId, index)
	local foundTag = 0

	for i = 0, list.len(lockId) - 1, 1 do
		if lockId[i] == doorDeviceId and tagIndex[i] == index then
			foundTag = tagCode[i]
			break
		end
	end

	if foundTag == 0 then
		return -1
	end

	for i = 0, list.len(rfidDummyDevices) - 1, 1 do
		if rfidDummyDeviceLocks[i] == doorDeviceId and rfidDummyDeviceTagCodes[i] == foundTag then
			return rfidDummyDevices[i]
		end
	end
	return -1
end

function getManualLockDummyDeviceId(doorDeviceId)
	for i = 0, list.len(manualLockDummyDevices) - 1, 1 do
		if idLocks[i] == doorDeviceId then
			return manualLockDummyDevices[i]
		end
	end
	return -1
end

function getManualUnlockDummyDeviceId(doorDeviceId)
	for i = 0, list.len(manualUnlockDummyDevices) - 1, 1 do
		if idLocks[i] == doorDeviceId then
			return manualUnlockDummyDevices[i]
		end
	end
	return -1
end

function getRemoteUnlockDummyDeviceId(doorDeviceId)
	for i = 0, list.len(remoteUnlockDummyDevices) - 1, 1 do
		if idLocks[i] == doorDeviceId then
			return remoteUnlockDummyDevices[i]
		end
	end
	return -1
end

function getMasterPinUnlockDummyDeviceId(doorDeviceId)
	for i = 0, list.len(masterPinUnlockDummyDevices) - 1, 1 do
		if idLocks[i] == doorDeviceId then
			return masterPinUnlockDummyDevices[i]
		end
	end
	return -1
end

function getServicePinUnlockDummyDeviceId(doorDeviceId)
	for i = 0, list.len(servicePinUnlockDummyDevices) - 1, 1 do
		if idLocks[i] == doorDeviceId then
			return servicePinUnlockDummyDevices[i]
		end
	end
	return -1
end

function getWrongPinDummyDeviceId(doorDeviceId)
	for i = 0, list.len(wrongPinDummyDevices) - 1, 1 do
		if idLocks[i] == doorDeviceId then
			return wrongPinDummyDevices[i]
		end
	end
	return -1
end

function getTamperingDummyDeviceId(doorDeviceId)
	for i = 0, list.len(tamperingDummyDevices) - 1, 1 do
		if idLocks[i] == doorDeviceId then
			return tamperingDummyDevices[i]
		end
	end
	return -1
end

function getFireDummyDeviceId(doorDeviceId)
	for i = 0, list.len(fireDummyDevices) - 1, 1 do
		if idLocks[i] == doorDeviceId then
			return fireDummyDevices[i]
		end
	end
	return -1
end

function triggerDummyDevice(deviceId)
	local device = deviceManager:device(deviceId)
	device:command("turnon")
end

