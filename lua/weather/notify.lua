local weather = require'weather'
local util = require'weather.util'

local result = {}

result.start = function(text_wrap, notify_level, notify_opts)
  local wrap = text_wrap or 70
  local l = notify_level or "error"
  local opts = notify_opts or {
    icon = "⚠️",
  }
  weather.subscribe('notify', function(w)
    if w.failure then
      return
    end

    for _,a in ipairs(w.success.alerts) do
      local contents = (a.title or "") .. "\n" .. (a.description or "")
      opts.title = a.from or ""
      vim.notify(util.wrap_text(contents, wrap), l, opts)
    end
  end)
end

return result

