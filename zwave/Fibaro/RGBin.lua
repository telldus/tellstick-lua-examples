local deviceManager = require "telldus.DeviceManager"

function controlDevice(device, action)
	local device = deviceManager:findByName(device)
	if device == nil then
		return
	end
	if action == "ON" and device:state() == 2 then
		print("%s - %s", device:name(), action)
		device:command("turnon", nil, "RGB")
	elseif action == "OFF" and device:state() == 1 then
		print("%s - %s", device:name(), action)
		device:command("turnoff", nil, "RGB")
	end
end


function onZwaveMessageReceived(device, flags, cmdClass, cmd, data)
	if cmdClass ~= 0x26 or cmd ~= 3 then
		return
	end
	name = device:name()
	print("%s - %s", name, data[0])
	name = string.gsub(name, "IN", "OUT")
	if data[0] < 50 then
		action = "OFF"
	else
		action = "ON"
	end
	controlDevice(name, action)
end
