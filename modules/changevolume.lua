--changevolume.lua
utils = require('modules/utils')
changevol = {}

function changevol:init(x,y,width,height,go)
  self.x,self.y,self.w,self.h,self.g = x,y,width,height,go
end

function changevol:update(player)
  if utils:CheckCollision(player.x,player.y,32,32,self.x,self.y,self.w,self.h) then
    print("changevolume hit")
    main:changeLevel(self.go)
  end
end

return changevol
