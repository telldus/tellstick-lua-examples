function onInit()
	local pushover = require 'pushover.Client'
	local ret = pushover:send{msg='Test message from Lua', title='Telldus'}
	if ret.status == 1 then
		print "Sent successfully"
	end
end

function onDeviceStateChanged(device, state, stateValue)
	print("On device state changed %s", device:name())
	if device:name() ~= 'Office' then
		return
	end
	local pushover = require 'pushover.Client'
	if pushover == nil then
		print("Pushover plugin is not installed")
		return
	end
	print("Send msg")
	if state == 1 then
		status = "ON"
	elseif state == 2 then
		status = "OFF"
	end
	local ret = pushover:send{msg='Office changed status to ' .. status , title='Telldus'}
	if ret.status == 1 then
		print "Sent successfully"
	end
end
