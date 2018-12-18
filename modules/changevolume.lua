--changevolume.lua
changevol = {}

function changevol:init(x,y,width,height,go)
  self.x,self.y,self.w,self.h,self.g = x,y,width,height,go
end

return changevol
