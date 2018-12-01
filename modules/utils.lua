utils = {}

function utils:printTable(table)
  for key,value in pairs(table) do
    if type(value) == "table" then
      print(key)
      utils:printTable(value)
    else
      print(key,value)
    end
  end
end

function utils:makeObj(class)
  local mt = { __index = class }
  local obj = setmetatable({}, mt)
  return obj;
end

return utils
