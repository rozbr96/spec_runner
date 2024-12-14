
M = {}

function M.split(str, delimiter)
  local result = {}
  for match in (str..delimiter):gmatch("(.-)"..delimiter) do
    table.insert(result, match)
  end
  return result
end

function M.strip(str)
  return (str:gsub("^%s*(.-)%s*$", "%1"))
end

function M.starts_with(str, prefix)
  return string.find(str, prefix, 1, true) == 1
end

return M

