local weather = require'weather'

local result = {}

-- A helper function for displaying items on lualine. A (verbose) example usage of this in your init.vim may be:
--
--local function format()
--  return require'weather.lualine'.lualine(function(data)
--    return data.condition_icon .. " " .. math.floor(data.temp.f) .. "°F"
--  end)
--end
--
--require('lualine').setup {
--  sections = {
--    ...
--    lualine_x = { format() },
--  }
--}

result.lualine = function(formatter)
  return function()
    local cached = weather.get_cached()
    if cached then
      local formatted = formatter(cached.success)
      return formatted
    end

    weather.get_default(nil, function(_)
      vim.api.nvim_command('redrawstatus')
    end)
    return weather.config.lualine.fetching_text
  end
end

return result
