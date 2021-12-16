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
local is_pending = false

result.custom = function(formatter, pending_text)
  return function()
    local cached = weather.get_cached()
    if cached then
      local formatted = formatter(cached.success)
      return formatted
    end

    if not is_pending then
      is_pending = true
      weather.get_default(nil, function(_)
        -- Ignore result here because it should be picked up in the cache on redraw.
        is_pending = false
        vim.api.nvim_command('redrawstatus')
      end)
    end
    return pending_text or "Fetching weather..."
  end
end


result.default_f = function(pending)
  return result.custom(default_f_formatter, pending)
end
result.default_c = function(pending)
  return result.custom(default_c_formatter, pending)
end


return result
