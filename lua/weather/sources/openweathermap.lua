local curl = require'plenary.curl'
local os = require'os'
local util = require'weather.util'

local result = {}

-- Does a raw call to openweathermap, returning a table with either:
-- "success": table containing the parsed json response from https://openweathermap.org/api/one-call-api
-- "failure": string with the error message
result.get_raw = function(args, callback)
  curl.get {
    url = "https://api.openweathermap.org/data/2.5/onecall",
    query = args,
    callback = function(response)
      if response.exit ~= 0 or response.status > 400 or response.status < 200 then
        callback {
          failure = {
            message = response.body
          }
        }
      end
      vim.schedule(function()
        local response_table = vim.fn.json_decode(response.body)
        callback {
          success = response_table
        }
      end)
    end,
  }
end

-- Given the response, returns the icon that should be used.
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

-- Maps a owm object to a Weather object.
local function map_to_weather(owm, config)
  if owm.success then
    local k = owm.success.current.temp
    return {
      success = {
        temp = {
          k = k,
          c = util.k_to_c(k),
          f = util.k_to_f(k),
        },
        humidity = owm.success.current.humidity,
        condition_icon = get_icon(owm.success, config),
      }
    }
  else
    return owm
  end
end

-- Gets a Weather object for owm
result.get = function(location, config, callback)
  assert(config.openweathermap.app_id, "No app_id provided for openweathermap")
  local args = {
    lat = location.lat,
    lon = location.lon,
    appid = config.openweathermap.app_id,
  }
  result.get_raw(args, function(r)
    callback(map_to_weather(r, config))
  end)
end

return result

