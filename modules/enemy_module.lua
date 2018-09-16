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

function enemy:init(ico,x,y, id, world)
  self.icon = ico;
  self.World = world;
  --player.data = json.decode(player.jsondat);
  self.increment = 0;
  self.frames = {};
  self.frames[0] = love.graphics.newQuad(0,0,32,32,self.icon:getDimensions())
  self.frames[1] = love.graphics.newQuad(32,0,32,32,self.icon:getDimensions())
  self.origx = x
  self.origy = y
  self.x = x;
  self.y = y;
  self.speed = 1;
  self.alive = 1;
  self.id = id;
  self.shoottimer = 0.0;
  self.shootmax = 5;
  self.ammo = 10;
  self.World:add(self, self.x, self.y, 32, 32);
  self.detectedplayer = false
  self.state = "WANDER"
  maxsearch = 5
  self.searchtimer = maxsearch
end

function enemy:shoot(player,world,dt)
  if self.detectedplayer then
    self.shoottimer = self.shoottimer+dt
  else
    self.shoottimer = 0
  end

  if self.shoottimer > self.shootmax then
    world:shoot(self,player.x,player.y,1);
    --print("enemyshoot",player.x,player.y)
    self.shoottimer = 0;
  end
end


function enemy:die()
  self.alive = 0;
  self.World:remove(self);
  --print ("dead", self.x, self.y);
end

function enemy:hurt()
  self:die();
end


function lerp (a,b,t)
  return a + (b - a) * t;
end

function enemy:pointDetectable(px,py,sx,sy,shadowed)
  --print("px:",px,"py:",py,"sx:",sx,"sy:",sy,"shadowed:",shadowed)
  local dist = 0
  if (shadowed) then
    dist = 0
  else
    dist = 150
  end
  return math.sqrt(math.pow(sx-px,2)+math.pow(sy-py,2))< dist
  --return true
end

function enemy:decideMovement(playerx,playery,dt)
  print (self.state)
  local deltax = 0;
  local deltay = 0;
  if (self.detectedplayer) then
      self.state = "PERSUE"
    end
    if self.state == "PERSUE" then
      if (self.x < playerx) then
        deltax = 1;
      else if (self.x > playerx) then
        deltax = -1;
      end


      if (self.y < playery) then
        deltay = 1;
      else if (self.y > playery) then
        deltay = -1;
      end
    end


  if self.state == "WANDER" then
    print("wander")
    if (self.x < self.origx) then
      deltax = 1;
    else if (self.x > self.origx) then
      deltax = -1;
    end


    if (self.y < self.origy) then
      deltay = 1;
    else if (self.y > self.origy) then
      deltay = -1;
    end
  end
end

  if self.state == "WANDER" and mathf.math.random() > .5 then
      print(self.state)
      if mathf.math.random() >= .5 then
        deltax = 1;
      else
        deltax = -1;
      end
      if mathf.math.random() >= .5 then
        deltay = 1;
      else
        deltay = -1;
      end
  end
  end
  self.x = self.x + (deltax * self.speed);
  self.y = self.y + (deltay * self.speed);
  local ax, ay, cols, len = self.World:move(self, self.x, self.y)
  self.x = ax
  self.y = ay
  self.World:update(self, self.x, self.y,32,32);
end
end
end


function enemy:update(playerx,playery,dt)
  if self.state == "PERSUE" and not self.pointDetectable(0,playerx,playery,self.x,self.y,player.shadowed) then
    self.searchtimer = self.searchtimer-dt
    print (self.searchtimer)
    if self.searchtimer <= 0 then
      self.state = "WANDER"
      self.detectedplayer = false
    end
else if (self.pointDetectable(0,playerx,playery,self.x,self.y,player.shadowed)) then
    self.searchtimer = maxsearch
    self.state = "PERSUE"
    self.detectedplayer = true
end
end
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
