local deviceManager = require "telldus.DeviceManager"
local filter = deviceManager:findByName('') -- Name of a filtered device. Leave empty for no filter

CommandClass = {}
CommandClass[0x71] = "NOTIFICATION"
CommandClass[0x22] = "APPLICATION_STATUS"
CommandClass[0x9B] = "ASSOCIATION_COMMAND_CONFIGURATION"
CommandClass[0x85] = "ASSOCIATION"
CommandClass[0x59] = "ASSOCIATION_GRP_INFO"
CommandClass[0x95] = "AV_CONTENT_DIRECTORY_MD"
CommandClass[0x97] = "AV_CONTENT_SEARCH_MD"
CommandClass[0x96] = "AV_RENDERER_STATUS"
CommandClass[0x99] = "AV_TAGGING_MD"
CommandClass[0x36] = "BASIC_TARIFF_INFO"
CommandClass[0x50] = "BASIC_WINDOW_COVERING"
CommandClass[0x20] = "BASIC"
CommandClass[0x80] = "BATTERY"
CommandClass[0x5B] = "CENTRAL_SCENE"
CommandClass[0x2A] = "CHIMNEY_FAN"
CommandClass[0x46] = "CLIMATE_CONTROL_SCHEDULE"
CommandClass[0x81] = "CLOCK"
CommandClass[0x70] = "CONFIGURATION"
CommandClass[0x21] = "CONTROLLER_REPLICATION"
CommandClass[0x56] = "CRC_16_ENCAP"
CommandClass[0x3A] = "DCP_CONFIG"
CommandClass[0x3B] = "DCP_MONITOR"
CommandClass[0x5A] = "DEVICE_RESET_LOCALLY"
CommandClass[0x4C] = "DOOR_LOCK_LOGGING"
CommandClass[0x62] = "DOOR_LOCK"
CommandClass[0x90] = "ENERGY_PRODUCTION"
CommandClass[0x7A] = "FIRMWARE_UPDATE_MD"
CommandClass[0x8C] = "GEOGRAPHIC_LOCATION"
CommandClass[0x7B] = "GROUPING_NAME"
CommandClass[0x82] = "HAIL"
CommandClass[0x39] = "HRV_CONTROL"
CommandClass[0x37] = "HRV_STATUS"
CommandClass[0x87] = "INDICATOR"
CommandClass[0x9A] = "IP_CONFIGURATION"
CommandClass[0x89] = "LANGUAGE"
CommandClass[0x76] = "LOCK"
CommandClass[0x91] = "MANUFACTURER_PROPRIETARY"
CommandClass[0x72] = "MANUFACTURER_SPECIFIC"
CommandClass[0xEF] = "MARK"
CommandClass[0x35] = "METER_PULSE"
CommandClass[0x3C] = "METER_TBL_CONFIG"
CommandClass[0x3D] = "METER_TBL_MONITOR"
CommandClass[0x3E] = "METER_TBL_PUSH"
CommandClass[0x32] = "METER"
CommandClass[0x51] = "MTP_WINDOW_COVERING"
CommandClass[0x8E] = "MULTI_CHANNEL_ASSOCIATION_V2"
CommandClass[0x60] = "MULTI_CHANNEL_V2"
CommandClass[0x8F] = "MULTI_CMD"
CommandClass[0x8E] = "MULTI_INSTANCE_ASSOCIATION"
CommandClass[0x60] = "MULTI_INSTANCE"
CommandClass[0x52] = "NETWORK_MANAGEMENT_PROXY"
CommandClass[0x4D] = "NETWORK_MANAGEMENT_BASIC"
CommandClass[0x34] = "NETWORK_MANAGEMENT_INCLUSION"
CommandClass[0x00] = "NO_OPERATION"
CommandClass[0x77] = "NODE_NAMING"
CommandClass[0xF0] = "NON_INTEROPERABLE"
CommandClass[0x73] = "POWERLEVEL"
CommandClass[0x41] = "PREPAYMENT_ENCAPSULATION"
CommandClass[0x3F] = "PREPAYMENT"
CommandClass[0x88] = "PROPRIETARY"
CommandClass[0x75] = "PROTECTION"
CommandClass[0x48] = "RATE_TBL_CONFIG"
CommandClass[0x49] = "RATE_TBL_MONITOR"
CommandClass[0x7C] = "REMOTE_ASSOCIATION_ACTIVATE"
CommandClass[0x7D] = "REMOTE_ASSOCIATION"
CommandClass[0x2B] = "SCENE_ACTIVATION"
CommandClass[0x2C] = "SCENE_ACTUATOR_CONF"
CommandClass[0x2D] = "SCENE_CONTROLLER_CONF"
CommandClass[0x4E] = "SCHEDULE_ENTRY_LOCK"
CommandClass[0x93] = "SCREEN_ATTRIBUTES"
CommandClass[0x92] = "SCREEN_MD"
CommandClass[0x24] = "SECURITY_PANEL_MODE"
CommandClass[0x2F] = "SECURITY_PANEL_ZONE_SENSOR"
CommandClass[0x2E] = "SECURITY_PANEL_ZONE"
CommandClass[0x98] = "SECURITY"
CommandClass[0x9C] = "SENSOR_ALARM"
CommandClass[0x30] = "SENSOR_BINARY"
CommandClass[0x9E] = "SENSOR_CONFIGURATION"
CommandClass[0x31] = "SENSOR_MULTILEVEL"
CommandClass[0x9D] = "SILENCE_ALARM"
CommandClass[0x94] = "SIMPLE_AV_CONTROL"
CommandClass[0x27] = "SWITCH_ALL"
CommandClass[0x25] = "SWITCH_BINARY"
CommandClass[0x26] = "SWITCH_MULTILEVEL"
CommandClass[0x28] = "SWITCH_TOGGLE_BINARY"
CommandClass[0x29] = "SWITCH_TOGGLE_MULTILEVEL"
CommandClass[0x4A] = "TARIFF_CONFIG"
CommandClass[0x4B] = "TARIFF_TBL_MONITOR"
CommandClass[0x44] = "THERMOSTAT_FAN_MODE"
CommandClass[0x45] = "THERMOSTAT_FAN_STATE"
CommandClass[0x38] = "THERMOSTAT_HEATING"
CommandClass[0x40] = "THERMOSTAT_MODE"
CommandClass[0x42] = "THERMOSTAT_OPERATING_STATE"
CommandClass[0x47] = "THERMOSTAT_SETBACK"
CommandClass[0x43] = "THERMOSTAT_SETPOINT"
CommandClass[0x8B] = "TIME_PARAMETERS"
CommandClass[0x8A] = "TIME"
CommandClass[0x55] = "TRANSPORT_SERVICE"
CommandClass[0x63] = "USER_CODE"
CommandClass[0x86] = "VERSION"
CommandClass[0x84] = "WAKE_UP"
CommandClass[0x4F] = "ZIP_6LOWPAN"
CommandClass[0x23] = "ZIP"
CommandClass[0x5E] = "ZWAVEPLUS_INFO"
CommandClass[0x57] = "APPLICATION_CAPABILITY"
CommandClass[0x33] = "COLOR_CONTROL"

function onZwaveMessageReceived(device, flags, cmdClass, cmd, data)
	if filter ~= nil and device:id() ~= filter:id() then
		return
	end
	if cmdClass == 0x80 then
		battery(device, cmd, data)
	elseif cmdClass == 0x31 then
		sensorMultilevel(cmd, data)
	end
	if cmdClass == 0x71 then
		notification(cmd, data)
	end
	if CommandClass[cmdClass] == None then
		print("UTC: %s | Z-Wave msg received from %s. CmdClass %s, cmd %s: %s", os.date("%X"), device:name(), cmdClass , cmd, data)
	else
		print("UTC: %s | Z-Wave msg received from %s. CmdClass %s, cmd %s: %s", os.date("%X"), device:name(), CommandClass[cmdClass] , cmd, data)
	end
end

function notification(cmd, data)
	type = {}
	type[0x00] = "Reserved"
	type[0x01] = "Smoke Alarm"
	type[0x02] = "CO Alarm"
	type[0x03] = "CO2 Alarm"
	type[0x04] = "Heat Alarm"
	type[0x05] = "Water Alarm"
	type[0x06] = "Access Control"
	type[0x07] = "Home Security"
	type[0x08] = "Power Management"
	type[0x09] = "System"
	type[0x0A] = "Emergency Alarm"
	type[0x0B] = "Clock"
	type[0x0C] = "Appliance"
	type[0x0D] = "Home Health"
	type[0x0E] = "Siren"
	type[0x0F] = "Water Valve"
	type[0x10] = "Weather Alarm"
	type[0x11] = "Irrigation"
	type[0x12] = "Gas Alarm"
	type[0x13] = "Pest control"
	home_event = {}
	home_event[0x00] = "Event inactive"
	home_event[0x01] = "Intrusion"
	home_event[0x02] = "Intrusion, Unknown Location"
	home_event[0x03] = "Tampering, Product covering removed"
	home_event[0x04] = "Tampering, Invalid Code"
	home_event[0x05] = "Glass Breakage"
	home_event[0x06] = "Glass Breakage, Unknown Location"
	home_event[0x07] = "Motion Detection"
	home_event[0x08] = "Motion Detection, Unknown Location"
	home_event[0x09] = "Tampering, Product Moved"
	home_event[0xFE] = "Unknown Event"
	system_event = {}
	system_event[0x00] = "Event inactive"
	system_event[0x01] = "System hardware failure"
	system_event[0x02] = "System software failure"
	system_event[0x03] = "System hardware failure with manufacturer proprietary failure code"
	system_event[0x04] = "System software failure with manufacturer proprietary failure code"
	system_event[0x05] = "Heartbeat"
	system_event[0x06] = "Tampering, Product covering removed"
	system_event[0x07] = "Emergency Shutoff"
	system_event[0xFE] = "Unknown Event"
	notificationtype = data[4]
	event = data[5]
	if notificationtype == 0x09 then
		event_type = system_event[event]
	elseif notificationtype == 0x07 then
		event_type = home_event[event]
	else
		event_type = event
	end
	print("UTC: %s | Notification, Type: %s, Event: %s", os.date("%X"), type[notificationtype], event_type)
end
	
function battery(device, cmd, data)
	if cmd == 3 then
		if data[0] == 0xFF then
			msg = "LOW BATTERY WARNING"
		else
			msg = tonumber(data[0])
		end
	print("UTC: %s | Battery Level Report from %s: %s", os.date("%X"), device:name(), msg)
	end
end

function sensorMultilevel(cmd, data)
	type = {}
	type[0x00] = "Reserved"
	type[0x01] = "Air Temperature"
	type[0x02] = "General Purpose"
	type[0x03] = "Luminance"
	type[0x04] = "Power"
	type[0x05] = "Humidity"
	type[0x06] = "Velocity"
	type[0x07] = "Direction"
	type[0x08] = "Atmospheric Pressure"
	type[0x09] = "Barometric Pressure"
	type[0x0A] = "Solar Radiation"
	type[0x0B] = "Dew point"
	type[0x0C] = "Rain rate"
	type[0x0D] = "Tide level"
	type[0x0E] = "Weight"
	type[0x0F] = "Voltage"
	type[0x10] = "Current"
	type[0x11] = "Carbon Dioxide CO2-level"
	type[0x12] = "Air flow"
	type[0x13] = "Tank capacity"
	type[0x14] = "Distance"
	type[0x15] = "Angle Position"
	type[0x16] = "Rotation"
	type[0x17] = "Water Temperature"
	type[0x18] = "Soil Temperature"
	type[0x19] = "Seismic Intensity"
	type[0x1A] = "Seismic Magnitude"
	type[0x1B] = "Ultraviolet"
	type[0x1C] = "Electrical Resistivity"
	type[0x1D] = "Electrical  Conductivity"
	type[0x1E] = "Loudness"
	type[0x1F] = "Moisture"
	type[0x20] = "Frequency"
	type[0x21] = "Time"
	type[0x22] = "Target Temperature"
	type[0x23] = "Particulate Matter 2.5"
	type[0x24] = "Formaldehyde CH2O-level"
	type[0x25] = "Radon Concentration"
	type[0x26] = "Methane Density CH4"
	type[0x27] = "Volatile Organic Compound"
	type[0x28] = "Carbon Monoxide CO-level"
	type[0x29] = "Soil Humidity"
	type[0x2A] = "Soil Reactivity"
	type[0x2B] = "Soil Salinity"
	type[0x2C] = "Heart Rate"
	type[0x2D] = "Blood Pressure"
	type[0x2E] = "Muscle Mass"
	type[0x2F] = "Fat Mass"
	type[0x30] = "Bone Mass"
	type[0x31] = "Total Body Water, TBW"
	type[0x32] = "Basic Metabolic Rate, BMR"
	type[0x33] = "Body Mass Index, BMI"
	type[0x34] = "Acceleration, X-axis"
	type[0x35] = "Acceleration, Y-axis"
	type[0x36] = "Acceleration, Z-axis"
	type[0x37] = "Smoke Density"
	type[0x38] = "Water Flow"
	type[0x39] = "Water Pressure"
	type[0x3A] = "RF Signal Strength"
	type[0x3B] = "Particulate Matter 10"
	type[0x3B] = "Respiratory Rate"
	sensortype = data[0]
	if sensortype == 0x01 then -- temperature
		scale = data[2]
		if scale == 0x00 then
			precision = data[1]
			scale = "Celsius"
			value = data[3]
		end
	end
	if sensortype == 0x03 then  -- luminance
		scale = data[1]
		if scale == 0x01 then
			scale = "Lux"
			value = data[2]
		end
	end
	print("UTC: %s | SensorMultilevel Sensortype: %s, Value: %s, Scale: %s", os.date("%X"), type[sensortype], value, scale)

end
