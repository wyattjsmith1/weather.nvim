local result = {}

-- Merges everything from `a` into `b`. subtables are merged too.
result.table_deep_merge = function(a, b)
  for k,v in pairs(a) do
    if type(v) == 'table' and type(b[k]) == 'table' then
      result.table_deep_merge(v, b[k])
    else
      b[k] = v
    end
  end
end

-- Convert Kelvin to Celius
result.k_to_c = function(k)
  return k - 273.15
end

-- Convert Kelvin to fahrenheit
result.k_to_f = function(k)
  return ((result.k_to_c(k) * 9) / 5) + 32
end

-- Borrowed from http://lua-users.org/wiki/StringRecipes
result.wrap_text = function(str, limit, indent, indent1)
   indent = indent or ""
   indent1 = indent1 or indent
   limit = limit or 72
   local here = 1-#indent1
   local function check(_, st, word, fi)
      if fi - here > limit then
         here = st - #indent
         return "\n"..indent..word
      end
   end
   return indent1..str:gsub("(%s+)()(%S+)()", check)
end

return result

