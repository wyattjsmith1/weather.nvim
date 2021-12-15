local curl = require'plenary.curl'
local owm = require'weather.sources.openweathermap'
local config = require'weather.default_config'.default
local util = require'weather.util'
local async = require'plenary.async.async'
local os = require'os'

local weather = {}
local cache = nil

local function is_cache_valid()
  return cache and cache.updated < os.time() + config.cache_ttl and cache.item
end

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
  location = location or weather.location_lookup()
  if config.default == 'openweathermap' then
    local result = owm.get(location, config)
    return result
  else
    print("No default weather found")
  end
end

weather.get_cached = function()
  if is_cache_valid() then
    return cache.item
  end
end

weather.get_default = function(location, callback)
  if is_cache_valid() then
    callback(cache.item)
  elseif cache == nil then
    cache = {
      pending = { callback }
    }
    async.run(
      function() return weather.get_default_blocking(location) end,
      function(r)
        cache.updated = os.time()
        cache.item = r
        for _,v in ipairs(cache.pending) do
          v(r)
        end
        cache.pending = nil
      end
    )
  else
    table.insert(cache.pending, callback)
  end
end

weather.setup = function(args)
  -- Merge passed in args into the default config.
  util.table_deep_merge(args or {}, config)
end

return weather
