function onInit()
	local pushover = require 'pushover.Client'
	local ret = pushover:send{msg='Hej from lua', title='telldus'}
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
	pushover.send{msg='Office changed status to ' .. state, title='telldus'}
	print("msg sent")
end
