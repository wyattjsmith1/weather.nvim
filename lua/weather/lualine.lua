local weather = require'weather'
local util = require'weather.util'

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

result.custom = function(formatter, alt_icons)
  local default_icons = {
    pending = '⏳',
    error = '❌',
  }
  util.table_deep_merge(default_icons, alt_icons)
  local text = alt_icons.pending
  weather.subscribe("lualine", function(update)
    if update.error then
      text = alt_icons.error
    else
      text = formatter(update.success)
      vim.schedule(function() vim.api.nvim_command('redrawstatus') end)
    end
  end)
  return function()
    return text
  end
end

result.default_f = function(pending)
  return result.custom(default_f_formatter, pending)
end
result.default_c = function(pending)
  return result.custom(default_c_formatter, pending)
end


return result
