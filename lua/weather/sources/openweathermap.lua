local curl = require'plenary.curl'
local os = require'os'

local result = {}

result.get_raw = function(args)
  local response = curl.get {
    url = "https://api.openweathermap.org/data/2.5/onecall",
    query = args,
  }
  assert(response.exit == 0 and response.status < 400 and response.status >= 200, "Failed to fetch weather: " .. response.body)
  local response_table = vim.fn.json_decode(response.body)
  return response_table
end

local function get_icon(owm, config)
  local id = owm.current.weather[1].id
  local val = config.openweathermap.weather_code_to_icons[id]
  local now = os.time()
  local icons = config.weather_icons.night
  if now > owm.current.sunrise and now < owm.current.sunset then
    icons = config.weather_icons.day
  end
  return icons[val] or val
end

result.map_to_weather = function(owm, config)
  return {
    temp = owm.current.temp,
    humidity = owm.current.humidity,
    condition_icon = get_icon(owm, config),
  }
end

result.get = function(location, config)
  assert(config.openweathermap.app_id, "No app_id provided for openweathermap")
  local args = {
    lat = location.lat,
    lon = location.lon,
    appid = config.openweathermap.app_id,
  }
  return result.map_to_weather(result.get_raw(args), config)
end

return result
