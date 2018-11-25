--ammobox.lua
ammobox = {}

function ammobox:init(img,x,y,name,world)
  self.type = "ammo"
  self.taken = false
  self.x = x
  self.y = y
  self.img = img
  self.w = 30
  self.h = 20
  self.frame = 0
end

function ammobox:take()
  self.taken = true
end

function ammobox:incrementframe(i)
  self.frame = self.frame + i
end

function ammobox:iscolliding(x1,y1,w1,h1)
  return x1 < self.x+self.w and
         self.x < x1+w1 and
         y1 < self.y+self.h and
         self.y < y1+h1
end

return ammobox
