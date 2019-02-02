--player_module
self = {};
json = require("modules/json");

function self:init(ico, jsondat, x, y, world, map)
  self.map = map
  self.World = world;
  self.icon = ico;
  self.json = jsondat;
  self.health = 10;
  self.alive = true;
  self.increment = 0;
  self.frames = {};
  self.frames[0] = love.graphics.newQuad(0,0,32,32,self.icon:getDimensions())
  self.frames[1] = love.graphics.newQuad(32,0,32,32,self.icon:getDimensions())
  self.x = x;
  self.y = y;
  self.speed = 70;
  self.maxammo = 6;
  self.ammo = self.maxammo;
  self.rechargelimit = 1;
  self.rechargetimer = 0;
  self.state = "PLAY";
  self.World:add(self, self.x, self.y, 20, 20)
  self.playerWalkTimer = 0
  self.substate = "UNDETECTED"
  self.shadowed = false
  --print("shadowdata: ",inspect(self.map.tiles))
end

function self:hurt() --health. TODO: Die properly
  self.health = self.health - 1;
  print(self.health,"health")
  if self.health <= 0 then
    self:die()
  end
end

function self:update(dt)
  if self.state == "PLAY" and self.substate == "UNDETECTED" and self.ammo < self.maxammo then
    self.rechargetimer = self.rechargetimer + dt;
    if self.rechargetimer > self.rechargelimit then
      self:changeammo(1)
      print(self.ammo,"ammorecharge", self.rechargetimer);
      self.rechargetimer = 0;
    end
  end
  if love.keyboard.isDown("w") then
    self:decideMovement(0,1,dt);
  end
  if love.keyboard.isDown("s") then
    self:decideMovement(0,-1,dt);
  end
  if love.keyboard.isDown("a") then
    self:decideMovement(-1,0,dt);
  end
  if love.keyboard.isDown("d") then
    self:decideMovement(1,0,dt);
  end
end

function self:changeammo(i)
  self.ammo = self.ammo + i
end

function self:shoot(player,world,dt,x,y,player,window,bullets) --interface with world shoot function
  self:changeammo(-1)
  print(self.ammo,"ammo");
  if self.ammo > 0 then
    world:shoot(self,x,y,0,player,window,bullets,true); --shoot
  end
end

function self:instantRefill()
  print("instant")
  self.ammo = self.maxammo;
  print(self.ammo)
end

function self:calcShadowed() --is shadowed?
  tx, ty = self.map:convertPixelToTile(self.x,self.y)
  tx = math.floor(tx)+1
  ty = math.floor(ty)+1
  if self.map.layers[2].data[ty][tx] then
    self.shadowed = true
  else
    self.shadowed = false

  end
end

function self:die() --TODO: make matter
  self.alive = false;
end

function self:decideMovement(x,y,dt) --Recieve input
  self.x = self.x + (x*self.speed*dt);
  self.y = self.y - (y*self.speed*dt);
  local ax, ay, cols, len = self.World:move(self, self.x, self.y)
    self.x = ax
    self.y = ay
    self.World:update(self, self.x, self.y,32,32);
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function self:isHit(x,y,ox,oy,wx,wy,bw,bh) --check if hit by bullet
  if CheckCollision(self.x,self.y,32,32,x,y,bw,bh) then
    self:hurt();
    return true;
  else
    return false;
    end
end

function self:animate(action) --animation cycle
  if action == "walk" then
    if self.increment == 1 then
      self.increment = 0;
    else
      self.increment = self.increment+1;
    end
  end
end
return self
