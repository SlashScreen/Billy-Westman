--enemy_module--player_module
enemy = {};
json = require("modules/json");

function lookat(x1,y1,x2,y2)
  local ygo = (y2-y1)/(x2-x1);
  return ygo;
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function enemy:create (o)
  o = o or {}   -- create object if user does not provide one
      setmetatable(o, self)
      o.__index = self
      return o
    end

function enemy:init(ico, jsondat,x,y, id, world)
  self.icon = ico;
  self.json = jsondat;
  self.World = world;
  --player.data = json.decode(player.jsondat);
  self.increment = 0;
  self.frames = {};
  self.frames[0] = love.graphics.newQuad(0,0,32,32,self.icon:getDimensions())
  self.frames[1] = love.graphics.newQuad(32,0,32,32,self.icon:getDimensions())
  self.x = x;
  self.y = y;
  self.speed = 1;
  self.alive = 1;
  self.id = id;
  self.World:add(self, self.x, self.y, 32, 32);
  --[[
  player.cels = {};
  for i,v in ipairs(player.data.frames) do
    player.frames[i] = player.data.frames[i];
  end
  for o,k in ipairs(player.frames) do
    player.cels[o] = love.graphics.newQuad(player.frames[o].frame,player.icon:getDimensions()) --player.data.frames[i];
  end
  print(player.frames);
  ]]--
end

function enemy:die()
  self.alive = 0;
  print ("dead", self.x, self.y);
end



function lerp (a,b,t)
  return a + (b - a) * t;
end



function enemy:decideMovement(playerx,playery,dt)
  --[[
  local deltax = lerp(enemy.x, player.x, .5);
  local deltay = lerp(enemy.y, player.y, .5);
  enemy.x = enemy.x + deltax;
  enemy.y = enemy.y + deltay;
  ]]--
  local deltax = 0;
  local deltay = 0;
  if (self.x < playerx) then
    deltax = 1;
  else if (self.x > playerx) then
    deltax = -1;
  end
end

  if (self.y < playery) then
    deltay = 1;
  else if (self.y > playery) then
    deltay = -1;
  end
  end
  self.x = self.x + (deltax * self.speed);
  self.y = self.y + (deltay * self.speed);
  local ax, ay, cols, len = self.World:move(self, self.x, self.y)
    self.x = ax
    self.y = ay
    self.World:update(self, self.x, self.y,32,32);
    --for i=1,len do
    --print('collided with ' .. tostring(cols[i].other),self.x,self.y)
  --end
  --print(enemy.x, enemy.y, playerx, playery);
end

function enemy:animate(action)
  if action == "walk" then
    --put in the animation thing
    if self.increment == 1 then
      self.increment = 0;
    else
      self.increment = self.increment+1;
    end
    
    
  end
  
end

function enemy:isHit(x,y,ox,oy,wx,wy,bw,bh)
  if CheckCollision(self.x,self.y,32, 32,x,y,bw,bh) then
    self:die();
    return true;
  else
    return false;
    end
end


return enemy;