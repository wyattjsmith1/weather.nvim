local weather = require'weather'

local function default_f_formatter(data)
  return data.condition_icon .. "  " .. math.floor(data.temp.f) .. "°F"
end

local function default_c_formatter(data)
  return data.condition_icon .. "  " .. math.floor(data.temp.c) .. "°C"
end

local result = {}
-- A helper function for displaying items on lualine. A (verbose) example usage of this in your init.vim may be:
--
--local function format(data)
--  return data.condition_icon .. " " .. math.floor(data.temp.f) .. "°F"
--end
--
--require('lualine').setup {
--  sections = {
--    ...
--    lualine_x = { custom(format) },
--  }
--}

result.custom = function(formatter)
  return function()
    print'Calling weather lualine'
    local cached = weather.get_cached()
    print("found cached item:")
    print(cached)
    if cached then
      print'found cached'
      local formatted = formatter(cached.success)
      return formatted
    end

    print("Getting from lualine")
    weather.get_default(nil, function(_)
      print("got weather")
      -- Ignore result here because it should be picked up in the cache on redraw.
      vim.api.nvim_command('redrawstatus')
      print'requested redraw'
    end)
    print'returning default fetching text'
    return weather.config.lualine.fetching_text
  end
end


result.default_f = result.custom(default_f_formatter)
result.default_c = result.custom(default_c_formatter)


return result
