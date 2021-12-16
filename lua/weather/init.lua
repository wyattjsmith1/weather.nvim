-- weather.nvim: A nvim plugin to display current weather status
-- Importing this module returns a set of functions which can access weather
local curl = require'plenary.curl'
local owm = require'weather.sources.openweathermap'
local config = require'weather.default_config'.default
local util = require'weather.util'
local async = require'plenary.async'
local os = require'os'

local weather = {}

local subscriptions = {}
local timer = nil

-- Looks up the current location, and returns information about it. This is done via ip address by ip-api.com.
weather.location_lookup = function()
  local response = curl.get{
    url = 'http://ip-api.com/json?fields=status,country,countryCode,region,regionName,city,zip,lat,lon',
  }
  assert(response.exit == 0 and response.status < 400 and response.status >= 200, "Failed to fetch location")
  local response_table = vim.fn.json_decode(response.body)
  assert(response_table.status == "success")
  return {
    country = response_table.country,
    region = response_table.regionName,
    city = response_table.city,
    lat = response_table.lat,
    lon = response_table.lon,
  }
end


local last_update = nil
-- Subscribes to weather updates.
-- - id (any): A unique id to register the listener with. Must be used with `unsubscribe`
-- - callback (function(WeatherResult)): A callback for when weather is fetched. May be called immediately if weather is cached already.
weather.subscribe = function(id, callback)
  assert(subscriptions[id] == nil, "Subscribed to weather updates with existing id: " .. id)
  subscriptions[id] = callback
  if last_update then
    callback(last_update)
  end
end

weather.unsubscribe = function(id)
  table[id] = nil
end

local function update_weather()
  local location = config.location or weather.location_lookup()
  if config.default == 'openweathermap' then
    local result = owm.get(location, config, function(data)
      last_update = data
      for _,v in pairs(subscriptions) do
        v(data)
      end
    end)
    return result
  else
    print("No default weather found")
  end

end

-- Sets up the configuration and begins fetching weather.
weather.setup = function(args)
  -- Merge passed in args into the default config.
  util.table_deep_merge(args or {}, config)
  update_weather()
  if not timer then
    timer = vim.loop.new_timer()
    timer:start(config.update_interval, config.update_interval, update_weather)
  end
end

return weather
