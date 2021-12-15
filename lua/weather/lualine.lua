local weather = require'weather'

local result = {}

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
    return "Getting weather..."
  end
end

return result
