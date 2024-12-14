
M = {}

function M.split(str, delimiter)
  local result = {}
  for match in (str..delimiter):gmatch("(.-)"..delimiter) do
    table.insert(result, match)
  end
  return result
end

return M

