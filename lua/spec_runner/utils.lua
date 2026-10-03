local Utils = {}

---Checks if the given string `str` contains the specified Lua pattern
---
---@param str string The string to search
---@param pattern string The Lua pattern to search for
---@return boolean
function Utils.contains(str, pattern)
  return string.find(str, pattern, 1, false) ~= nil
end

---Splits the given string `str` using the specified `delimiter` as separator, and returns an array containing the resulting strings
---
---@param str string The string to be splitted
---@param delimiter string The delimiter/separator to split the string on
---@return string[]
function Utils.split(str, delimiter)
  local result = {}
  for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
    table.insert(result, match)
  end
  return result
end

---Checks if the given string `str` starts with the specified `prefix`
---
---@param str string The string to check
---@param prefix string The literal prefix to look for
---@return boolean
function Utils.starts_with(str, prefix)
  return string.find(str, prefix, 1, true) == 1
end

---Removes whitespace characters, if any, from the given string `str`
---
---@param str string The string to remove whitespace characters from
---@return string
function Utils.strip(str)
  return (str:gsub("^%s*(.-)%s*$", "%1"))
end

return Utils
