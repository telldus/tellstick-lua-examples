--------------------------------------------------------------------------------
-- This script will set the watt value for your Foogadgets WPC3 sensor. This
-- is helpful if you have connected WPC3 to your power meters impulsing LED.
--
-- You can buy your own Wireless Pulse Counter 3 here:
-- http://foogadgets.tictail.com/product/wpc3
--------------------------------------------------------------------------------

-- EDIT THIS

local powerSensor = 16
local impulsesPerKiloWattHour = 1000

-- DO NOT EDIT BELOW THIS LINE

TYPE_TEMPERATURE = 1
TYPE_HUMIDITY = 2
TYPE_WATT = 256

function onSensorValueUpdated(device, valueType, value, scale)
  if device:id() == powerSensor and valueType == TYPE_TEMPERATURE then
    local powerValue = 0
    local humidityValue = device:sensorValue(TYPE_HUMIDITY, 0)

    if value >= 0 then
      powerValue = humidityValue * 4096 + (10 * value)
    else
      powerValue = humidityValue * 4096 - (10 * value) + 2048
    end

    local kWhValue = powerValue / impulsesPerKiloWattHour

    device:setSensorValue(TYPE_WATT, kWhValue, 0)
  end
end
