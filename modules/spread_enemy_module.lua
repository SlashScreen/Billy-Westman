--spread_module--player_module
spread = {};
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

function spread:create (o)
  o = o or {}   -- create object if user does not provide one
      setmetatable(o, self)
      o.__index = self
      return o
    end

function spread:init(ico,json,x,y, id, world)
  print (ico,json,x,y, id, world)
  if id == nil then
    self.alive = 0
    return
  else
    self.alive = 1;
  end
  self.icon = love.graphics.newImage(ico);
  self.World = world;
  self.increment = 0;
  self.frames = utils:getQuads(json,ico)
  self.origx = x
  self.origy = y
  self.x = x;
  self.y = y;
  self.speed = 45;
  self.id = id;
  self.shoottimer = 0.0;
  self.shootmax = 3;
  self.ammo = 10;
  self.World:add(self, self.x, self.y, 32, 32);
  self.detectedplayer = false
  self.state = 0
  maxsearch = 5
  self.goalx = 0
  self.goaly = 0
  self.searchtimer = maxsearch
  self.fidget = 0.0
  self.lost = false
end

function spread:shoot(player,world,dt) --interface with world shoot function
  sd = 7
  if self.detectedplayer then
    self.shoottimer = self.shoottimer+dt --cooldown
  else
    self.shoottimer = 0
  end

  if self.shoottimer > self.shootmax then
    world:shoot(self,player.x,player.y,1);
    world:shoot(self,player.x+sd,player.y+sd,1); --shoot if cooldown sufficient
    world:shoot(self,player.x-sd,player.y-sd,1);
    self.shoottimer = 0;
  end
end


function spread:die() --spread die
  self.alive = 0;
  self.World:remove(self);
end

function spread:hurt() --hurt; right now redirects to die but is helpful for future tougher enemies
  self:die();
end


function lerp (a,b,t) --lerp, might be deprecated
  return a + (b - a) * t;
end

function spread:pointDetectable(px,py,sx,sy,shadowed) --is point visible to spread?
  local dist = 0
  if (shadowed) then
    dist = 10 --if shadowed, raadius is lower
  else
    dist = 100 --else higher
  end
  return math.sqrt(math.pow(sx-px,2)+math.pow(sy-py,2))< dist --is pythag from spread to point less than distance?
end

function spread:decideMovement(playerx,playery,dt)
  local deltax = 0;
  local deltay = 0;
  --states: 0 is idle, 1 is persue
  if self.state == 1 then --If persuing player, goal is player
    self.goalx = playerx
    self.goaly = playery
  end
  if self.lost and goalx == playerx and goaly == playery then
    self.lost = false
    self.state = 2
  end
  descision = math.random()
  if self.state == 0 and descision < self.fidget or self.state == 2 and descision < self.fidget then --function for random wandering. bind to fidget variable for future searching state?
    math.randomseed(os.time())
    self.goalx = self.goalx + math.random(-20, 20)
    self.goaly = self.goaly + math.random(-20, 20)
  elseif self.state == 0 and descision < .15 and descision > .2 then
    self.goalx = self.origx
    self.goaly = self.origy
  end
  --pathfinding for goal. TODO: make smarter
  if (self.x < self.goalx) then
    deltax = 1;
  elseif (self.x > self.goalx) then
    deltax = -1;
  end

  if (self.y < self.goaly) then
    deltay = 1;
  elseif (self.y > self.goaly) then
    deltay = -1;
  end

  self.x = self.x + (deltax * self.speed *dt); --make it so it moves delta every second, not frame
  self.y = self.y + (deltay * self.speed *dt);
  local ax, ay, cols, len = self.World:move(self, self.x, self.y) --interface with bumpmap
  self.x = ax
  self.y = ay
  self.World:update(self, self.x, self.y,32,32); --update world
end

function spread:update(playerx,playery,dt)
  --Search timer function where they "lose" you; same as yellow state in MGS
  if self.state == 1 and not self.pointDetectable(0,playerx,playery,self.x,self.y,player.shadowed) then
    self.lost = true
    self.fidget = .1
    self.searchtimer = self.searchtimer-dt
    if self.searchtimer <= 0 then --if search runs out before finding player, switch to state 0
      self.fidget = .05
      self.goalx = self.origx
      self.goaly = self.origy
      self.state = 0
      self.detectedplayer = false
    end
  elseif (self.pointDetectable(0,playerx,playery,self.x,self.y,player.shadowed)) then --else, refresh timer
    self.searchtimer = maxsearch
    if self.state == 0 then
      self.state = 1
    end
    self.detectedplayer = true
  end
end

function spread:animate(action) --the animation cycle
  if action == "walk" then
    if self.increment == 1 then
      self.increment = 0;
    else
      self.increment = self.increment+1;
    end
  end
end

function spread:isHit(x,y,ox,oy,wx,wy,bw,bh) --check if hit by bullet
  if CheckCollision(self.x,self.y,32, 32,x,y,bw,bh) then
    self:die();
    return true;
  else
    return false;
    end
end

return spread;
