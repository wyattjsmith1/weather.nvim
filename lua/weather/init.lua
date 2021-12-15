local curl = require'plenary.curl'
local owm = require'weather.sources.openweathermap'
local config = require'weather.default_config'.default
local util = require'weather.util'
local async = require'plenary.async.async'
local os = require'os'

local weather = {}
local cache = nil

weather.location_lookup = function()
  local response = curl.get{
    url = 'http://ip-api.com/json?fields=status,country,countryCode,region,regionName,city,zip,lat,lon',
  }
  assert(response.exit == 0 and response.status < 400 and response.status >= 200, "Failed to fetch location")
  local response_table = vim.fn.json_decode(response.body)
  assert(response_table.status == "success")
  return {
    country = response_table.country,
    region = response_table.region,
    city = response_table.city,
    lat = response_table.lat,
    lon = response_table.lon,
  }
end

weather.get_default_blocking = function(location)
  if cache and cache.updated < os.time() + config.cache_ttl then
    return cache.item
  end

  location = location or weather.location_lookup()
  if config.default == 'openweathermap' then
    local result = owm.get(location, config)
    cache = {
      updated = os.time(),
      item = result
    }
    return result
  else
    print("No default found")
  end
end

weather.get_default = function(args, callback)
  async.run(function() weather.get_default_blocking(args) end, callback)
end

weather.setup = function(args)
  -- Merge passed in args into the default config.
  util.table_deep_merge(args or {}, config)
end

return weather
