-- Mail sender plugin has to be installed and configured

function onInit()
	print("Sending mail via Mail sender Plugin")
	local smtp = require "mailsender.SMTP"
	if smtp == nil then
		print("Mail sender plugin is not installed")
		return
	end
	smtp:send{
		receiver='insert email adress here',
		msg='Test mail from lua',
		subject='Lua mailer'
	}
end

function onDeviceStateChanged(device, state, stateValue)
	print("On device state changed %s", device:name())
	if device:name() ~= 'Office' then
		return
	end
	local smtp = require "mailsender.SMTP"
	if smtp == nil then
		print("Mail sender plugin is not installed")
		return
	end
	print("Send msg")
	if state == 1 then
		status = "ON"
	elseif state == 2 then
		status = "OFF"
	end
	local ret = smtp:send{
		receiver='insert email adress here',
		msg='Office changed status to ' .. status ,
		subject='Lua mailer'
	}
	if ret.status == 1 then
		print "Sent successfully"
	end
end
