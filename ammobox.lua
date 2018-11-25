--ammobox.lua
ammobox = {}

function ammobox:init(x,y)
  self.x = x
  self.y = y
  self.w = 30
  self.h = 20
end

function ammobox:iscolliding(x1,y1,w1,h1)
  return x1 < self.x+self.w and
         self.x < x1+w1 and
         y1 < self.y+self.h and
         self.y < y1+h1
end

return ammobox
