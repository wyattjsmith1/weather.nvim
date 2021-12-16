-- weather.nvim: A nvim plugin to display current weather status
-- Importing this module returns a set of functions which can access weather
local curl = require'plenary.curl'
local owm = require'weather.sources.openweathermap'
local config = require'weather.default_config'.default
local util = require'weather.util'
local async = require'plenary.async'
local os = require'os'

local weather = {}
local cache = nil

local function is_cache_valid()
  print(cache)
  if cache ~= nil then
    print(cache.updated)
    print(cache.item)
  end
  return (cache ~= nil) and (cache.updated or 0) < (os.time() + config.cache_ttl) and cache.item
end

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

-- Looks up weather according to the default in the config file.
-- - location: a table with { lat: x, lon: x } for location. If not passed, uses `location_lookup`
weather.get_default_blocking = function(location)
  print'Fetching weather'
  location = location or weather.location_lookup()
  if config.default == 'openweathermap' then
    local result = owm.get(location, config)
    return result
  else
    print("No default weather found")
  end
end

-- Gets cached weather. Either returns a Weather object, or nil.
weather.get_cached = function()
  if is_cache_valid() then
    return cache.item
  end
end

--local function get_default_callback(location, callback)
--  callback(weather.get_default_blocking(location))
--end

--local get_default_coroutine = async.wrap(get_default_callback, 2)
--weather.get_default = function(location, callback)
--  a.run(get_default_coroutine, {location, callback})
--end
weather.get_default_async = async.wrap(function(location, callback)
  callback(weather.get_default_blocking(location))
end, 2)
-- Gets weather from the default source async.
-- - location: same as get_default_blocking.
-- - callback: function(Weather)
weather.get_default = function(location, callback)
  if is_cache_valid() then
    callback(cache.item)
  elseif cache == nil then
    cache = {
      pending = { callback }
    }
    print("Starting async task")
    async.void(function(l)
      local r = weather.get_default_blocking(l)
      cache.updated = os.time()
      cache.item = r
      for _,v in ipairs(cache.pending) do
        v(r)
      end
      cache.pending = {}
    end)(location)
    --async.run(
    --  function() print("running in async") return weather.get_default_blocking(location) end,
    --  function(r)
    --    print("callback")
    --    cache.updated = os.time()
    --    cache.item = r
    --    for _,v in ipairs(cache.pending) do
    --      v(r)
    --    end
    --    cache.pending = nil
    --  end
    --)
  else
    table.insert(cache.pending, callback)
  end
  print("end get weather")
end

-- Sets up the configuration.
weather.setup = function(args)
  -- Merge passed in args into the default config.
  util.table_deep_merge(args or {}, config)
end

return weather
