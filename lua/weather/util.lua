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

result.k_to_c = function(k)
  return k - 273.15
end

result.k_to_f = function(k)
  return ((result.k_to_c(k) * 9) / 5) + 32
end

return result

