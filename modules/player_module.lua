--player_module
self = {};
json = require("modules/json");

function self:init(ico, jsondat, x, y, world)
  self.World = world;
  self.icon = ico;
  self.json = jsondat;
  --player.data = json.decode(player.jsondat);
  self.increment = 0;
  self.frames = {};
  self.frames[0] = love.graphics.newQuad(0,0,32,32,self.icon:getDimensions())
  self.frames[1] = love.graphics.newQuad(32,0,32,32,self.icon:getDimensions())
  self.x = x;
  self.y = y;
  self.speed = 2;
  self.maxammo = 10;
  self.ammo = self.maxammo;
  self.rechargelimit = 1;
  self.rechargetimer = 0;
  self.state = "PLAY";
  self.World:add(self, self.x, self.y, 32, 32)
end


function self:decideMovement(x,y)
  self.x = self.x + (x*self.speed);
  self.y = self.y - (y*self.speed);
  local ax, ay, cols, len = self.World:move(self, self.x, self.y)
    self.x = ax
    self.y = ay
    self.World:update(self, self.x, self.y,32,32);
    for i=1,len do
    print('collided with ' .. tostring(cols[i].other))
  end
end

function self:animate(action)
  if action == "walk" then
    --put in the animation thing
    if self.increment == 1 then
      self.increment = 0;
    else
      self.increment = self.increment+1;
    end
    
    
  end
  
end
return self