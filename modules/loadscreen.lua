--loadscreen.lua
loadscreen = {}
local utils = require ("modules/utils");

function loadscreen:load(json,img)
  self.state = 0
  main = require ("main");
  self.img = love.graphics.newImage(img); --fix later with actual path here
  self.destination = nil
  self.currentframe = 0
  --TODO: FIGURE OUT JSON AND STOP HARDCODING THIS. maybe utils function?
  self.frames = utils:getQuads(json,img)
  utils:printTable(self.frames)
  --0 idle,1 intro,2 load,3 outro
  timer = 0
  tmax = 1
end

function loadscreen:loadscreen(dest)
  print("loadscreen")
  self.destination = dest --must me world object
  self.state = 1
  print(self.state)
end

function loadscreen:update(dt)
  timer = timer+dt

  --STATE 1
  if self.state == 1 then
    if timer == tmax then
      timer = 0
      self.currentframe = self.currentframe +1
    end
    if self.currentframe == 4 then
      self.state = 2
    end
  end
  --STATE 2
  if self.state == 2 then
    self.destination:load()
    main.currentworld = self.destination
    self.state = 3
  end
  --STATE 3
  if self.state == 3 then
    if not self.state == #self.frames-1 then
      if timer == tmax then
        timer = 0
        self.currentframe = self.currentframe +1
      end
    else
      self.currentframe = 0
      self.state = 0
    end
  end
  if not self.currentframe == 0 then
    print(self.currentframe)
  end

end

function loadscreen:draw()
  --print(self.currentframe)
  love.graphics.draw(self.img,self.frames[self.currentframe],0,0)
end

return loadscreen
