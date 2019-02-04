utils = {}
local json = require("modules/dkjson")

function utils:draw(x,y,wx,wy,px,py,src,drawable,z) --TODO: add screen shake
  ---16-player.x+window.x/2-sx
  love.graphics.draw(src,drawable,x-16-px+(wx/2),y-16-py+(wy/2),0,z)
end

function utils:printTable(table,depth)
  if depth == nil then
    depth = 0
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

function utils:create (o)
  o = o or {}   -- create object if user does not provide one
  setmetatable(o, self)
  o.__index = self
  return o
end

function utils:deepCopy(orig)
    print("deepcopy")
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[utils:deepCopy(orig_key)] = utils:deepCopy(orig_value)
        end
        setmetatable(copy, utils:deepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function utils:getRatio(r,g)
  return r/g
end

function utils:getQuads(jsonfile,image)
  f = assert(love.filesystem.read(jsonfile))
  aes_tbl=json.decode (f)
  frames = {}
  i=0
  img = love.graphics.newImage(image)
  for key,frame in pairs(aes_tbl["frames"]) do
    c = frame["frame"]
    i = c["x"]/c["w"] --figure out orger based on width
    frames[i] = love.graphics.newQuad(c["x"],c["y"],c["w"],c["h"],img:getDimensions())
  end
  return frames
end

function utils:round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function utils:file_exists(name)
   return love.filesystem.exists(name)
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
