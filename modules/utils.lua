utils = {}
local json = require("modules/dkjson")

function utils:printTable(table,depth)
  if depth == nil then
    depth = 1
  end
  for key,value in pairs(table) do
    if type(value) == "table" then
      print(string.rep("   ",depth)..key)
      utils:printTable(value,depth+1)
    else
      print(string.rep("   ",depth)..key,value)
    end
  end
end

function utils:getQuads(jsonfile,image)
  f = assert(io.open(jsonfile, "r")):read("*all")
  aes_tbl=json.decode (f)
  --utils:printTable(aes_tbl)
  frames = {}
  i=0
  img = love.graphics.newImage(image)
  for key,frame in pairs(aes_tbl["frames"]) do
    --utils:printTable(frame)
    print(i)
    c = frame["frame"]
    frames[i] = love.graphics.newQuad(c["x"],c["y"],c["w"],c["h"],img:getDimensions())
    i = i+1
  end
  --utils:printTable(frames)
  return frames
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

function utils:pickPointInRadius(ox,oy,r)
  math.randomseed(os.time())
  x = ox + math.random(-r, r)
  y = oy + math.random(-r, r)
  return x,y
end

function utils:CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

return utils
