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

function utils:round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function utils:file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function utils:makeObj(class)
  local mt = { __index = class }
  local obj = setmetatable({}, mt)
  return obj;
end

return utils
