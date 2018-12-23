--worldupdate.lua
worldupdate = {}
local inspect = require('modules/inspect')
local utils = require('modules/utils')

function worldupdate:init(px,py,map,bosses,world)
  bosses = bosses or {}
  local sti = require ("modules/sti");
  local bump = require ("modules/bump");
  main = require ("../main");
  love.graphics.setDefaultFilter("nearest","nearest");
  love.graphics.setBackgroundColor(255,255,255);
  love.graphics.setColor(1,1,1);
  window = {}
  window.x = love.graphics:getWidth();
  window.y = love.graphics:getHeight();


  billywestmanimg = love.graphics.newImage("assets/player.png");
  ammoboximg = love.graphics.newImage("assets/ammoboxsprite.png");
  enemyimg = love.graphics.newImage("assets/enemy.png");
  BulletImg = love.graphics.newImage("assets/billywestmanbullet.png");
  OTTriggerF = love.graphics.newImage("assets/onetimetrigger1false.png");
  OTTriggerT = love.graphics.newImage("assets/onetimetrigger1true.png");
  TTriggerF = love.graphics.newImage("assets/toggletrigger1-false.png");
  TTriggerT = love.graphics.newImage("assets/toggletrigger1-true.png");
  DynamiteImg = love.graphics.newImage("assets/dynamite1.png");
  EastImg = love.graphics.newImage("assets/eman.png");
  DynamiteImg:setFilter("nearest","nearest");

  baseenemy = require "modules/enemy_module";
  spreadenemy = require "modules/spread_enemy_module";
  eastman_boss = require "modules/eastman_boss";
  trigger = require "modules/trigger_module";
  lchangeobj = require "modules/changevolume";
  dynamiteClass = require "modules/dynamite_module"
  ammoboxclass = require "modules/ammobox"

  --#LISTS AND utils:makeObj#
  triggers = {};
  enemies = {};
  dynamite = {};
  item = {};
  lchange = {};
  --#NEW STI METHOD#

  objlayer = map.layers["objs"].objects --get object layer

  for key,value in pairs(objlayer) do --loop through object layer
    object = value -- added this so I don't have to retype 5 billion things
    if object["type"] == "basic_enemy" then --Add basic enemy
      newobj = utils:makeObj(baseenemy) --make the object
      newobj:init("assets/enemy.png","assets/enemy.json",object["x"],object["y"],object["name"],world) --init the object
      enemies[#enemies+1] = newobj; --add it to the table
      --others below are the same, just with inits tailored to the object
    elseif object["type"] == "spread_enemy" then --spead enemy
      newobj = utils:makeObj(spreadenemy)
      newobj:init(enemyimg,object["x"],object["y"],object["name"],world)
      enemies[#enemies+1] = newobj;
    elseif object["type"] == "dynamite" then --dynamite
      newobj = utils:makeObj(dynamiteClass)
      newobj:init(object["x"],object["y"],DynamiteImg)
      dynamite[#dynamite+1] = newobj;
    elseif object["type"] == "ammo" then --ammo box
      newobj = utils:makeObj(ammoboxclass)
      newobj:init(ammoboximg,object["x"],object["y"],object["name"],world)
      item[#item+1] = newobj;
    elseif object["type"] == "trigger" then -- trigger: finish implementing
      newobj = utils:makeObj(trigger)
      newobj:init(object["x"],object["y"],true,"OT",OTTriggerF,object["name"],nil,world)
      triggers[#triggers+1] = newobj;
    elseif object["type"] == "changevolume" then -- trigger: finish implementing
      newobj = utils:makeObj(lchangeobj)
      newobj:init(object["x"],object["y"],object["width"],object["height"],object["name"])
      lchange[#lchange+1] = newobj;
    elseif object["type"] == "spawn" then --spawn point
      player:init(love.graphics.newImage("assets/player.png"), nil, object["x"], object["y"], world,map); --init player at x and y of object
    end
  end
  crosshair = love.graphics.newImage("assets/crosshair.png");
  bulletSpeed = 300
	bullets = {}
  playerWalkTimer = 0;
  zoom = 1;
  sx = 0;
  sy = 0;
  return player,BulletImg,triggers,enemies,dynamite,item,crosshair,zoom,sx,sy,window,bosses
end



function worldupdate:shoot(body,x,y,coordspace,player,window,bullets,playershooting)
  --print("shoot",debug.traceback())
  player.state = "FIRE";
		local startX = body.x
		local startY = body.y
    local dist = 50
    if coordspace == 0 then
      mouseX = body.x + x - window.x / 2
      mouseY = body.y + y - window.y / 2
    else
      mouseX =  x
      mouseY =  y
    end
		local angle = math.atan2((mouseY - startY), (mouseX - startX))
    startX = startX + (math.cos(angle)*dist)
    startY = startY + (math.sin(angle)*dist)
		local bulletDx = bulletSpeed * math.cos(angle)
		local bulletDy = bulletSpeed * math.sin(angle)
    local bulletTime = 3;
		table.insert(bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy, t = bulletTime})
    return bullets,player
end



function worldupdate:update(player,BulletImg,triggers,enemies,dynamite,item,crosshair,zoom,sx,sy,window,bosses,map,world,shader,dt)
  map:update(dt)
  player:update(dt)

  --PLAYER
  if not player.alive then
    main:reset()
  end

  player:calcShadowed()
  player.playerWalkTimer = player.playerWalkTimer + dt --increment walk timer by dt; don't be like fallout 76 lmao
  if player.playerWalkTimer > .5 then
    player:animate("walk"); --animate walk
    for key,i in pairs(enemies) do
      i:animate("walk"); --walk enemies by iter through them
    end

    player.playerWalkTimer = 0;
  end
  for key,value in pairs(item) do
    value:animate("float",dt); --walk items by iter through them
  end
detected = false
if bosses.alive == 1 then --if the enemy isn't dead
  if bosses.detectedplayer then --If any of them detected the player the player is detected now
    detected = true
  end
  bosses:update(player.x,player.y,dt)
  bosses:decideMovement(player.x,player.y,dt); --walk
  bosses:shoot(player,world,dt) --do shoot calcculations
  for o,v in ipairs(bullets) do -- is hit by bullets?
    if bosses:isHit(v.x, v.y, player.x, player.y, window.x, window.y,BulletImg:getWidth(),BulletImg:getHeight()) or player:isHit(v.x, v.y, player.x, player.y, window.x, window.y,BulletImg:getWidth(),BulletImg:getHeight()) then
      print("hit",v.x,v.y);
      table.remove(bullets,o);
      math.randomseed(player.x);
      world:shakescreen(10);
    end
  end
end
--ENEMIES
for key,i in pairs(enemies) do -- main interaction IG w enemies
    if i.alive == 1 then --if the enemy isn't dead
      if i.detectedplayer then --If any of them detected the player the player is detected now
        detected = true
      end
      i:update(player.x,player.y,dt) --update
      i:decideMovement(player.x,player.y,dt); --walk

      i:shoot(player,world,dt) --do shoot calcculations
      for o,v in ipairs(bullets) do -- is hit by bullets?
        if i:isHit(v.x, v.y, player.x, player.y, window.x, window.y,BulletImg:getWidth(),BulletImg:getHeight()) or player:isHit(v.x, v.y, player.x, player.y, window.x, window.y,BulletImg:getWidth(),BulletImg:getHeight()) then
          print("hit",v.x,v.y);
          table.remove(bullets,o);
          math.randomseed(player.x);
          world:shakescreen(50);
        end
      end
  end
end
--CHANGE VOLUME
for key,i in pairs(lchange) do
  i:update(player,main)
end
--DETECTED
if detected then -- followup to player detection
  player.substate = "DETECTED"
else
  player.substate = "UNDETECTED"
end
--TRIGGERS
  for key,i in pairs(triggers) do -- main interaction for Triggers
    if i.id == "Test 1" then --hardcoded: change
      world:setChange("westham");
    end

      for o,v in ipairs(bullets) do --is hit
        if i:isHit(v.x, v.y, player.x, player.y, window.x, window.y,BulletImg:getWidth(),BulletImg:getHeight()) then
          print("hit",v.x,v.y);
          table.remove(bullets,o);
          math.randomseed(player.x);
          world:shakescreen(30);
          --print(sx,sy);
        end
      end
  end
--BULLETS
for i,v in ipairs(bullets) do --bullet script
    v.t = v.t-dt; --timer decrement
		v.x = v.x + (v.dx * dt) --move x
		v.y = v.y + (v.dy * dt) --move y
    if v.t < 0 then --if timer ran out then remove bullet
      table.remove(bullets,i);
    end

	end
--DYNAMITE
for key,i in pairs(dynamite) do
    i:update(bullets,enemies,player,dynamite,BulletImg:getWidth(),BulletImg:getHeight(),dt); --update
  end

  if player.state == "FIRE" then --reset recharge timer while shooting
    player.rechargetimer = 0;
  end
--CONTROL
if love.keyboard.isDown("w") then
  player:decideMovement(0,1,dt);
end
if love.keyboard.isDown("s") then
  player:decideMovement(0,-1,dt);
end
if love.keyboard.isDown("a") then
  player:decideMovement(-1,0,dt);
end
if love.keyboard.isDown("d") then
  player:decideMovement(1,0,dt);
end

if not love.mouse.isDown(1) then
  player.state = "PLAY";
end
function love.mousepressed(x, y, button)
	if button == 1 and player.ammo > 0 then
    player:shoot(player,world,dt,x,y,player,window,bullets)
  end
end
--ITEMS
for key,i in pairs(item) do
  if i.type == "ammo" then --if ammo
    if not i.taken then --if not taken already
      if i:iscolliding(player.x,player.y,32,32) then --is colliding?
        player:instantRefill() --refill ammo
        i:take() --make item taken
      end
    end
  end
end
return sx,sy
end

function worldupdate:draw(player,BulletImg,triggers,enemies,dynamite,item,crosshair,zoom,sx,sy,window,bosses,map,world,shader)
  --SHADER
  love.graphics.setShader(shader)
  --MAP
  map:draw(window.x/2-player.x-sx-16,window.y/2-player.y-sy-16);
  --PLAYER
  love.graphics.draw(player.icon,player.frames[player.increment],window.x/2-16-sx,window.y/2-16-sy,0);
  --ENEMIES
  for key,i in pairs(enemies) do
    if i.alive == 1 then --if alive then
      love.graphics.draw(i.icon,i.frames[i.increment],(i.x-16-player.x+window.x/2-sx),(i.y-16-player.y+window.y/2-sy),0,zoom); --draw enemies
    end
  end
  --BOSS
  if bosses.alive == 1 then --if alive then
    love.graphics.draw(bosses.icon,bosses.frames[bosses.increment],(bosses.x-16-player.x+window.x/2-sx),(bosses.y-16-player.y+window.y/2-sy),0,zoom); --draw bosses
  end
  --TRIGGERS
  for key,i in pairs(triggers) do
    love.graphics.draw(i.imgs[bool_to_number(i.state) + 1],(i.x-16-player.x+window.x/2-sx),(i.y-16-player.y+window.y/2-sy),0,zoom); --draw triggers
  end
  --ITEMS
  for key,i in pairs(item) do
    if i.type == "ammo" then
      if not i.taken then --if not taken
        love.graphics.draw(i.img,i.frames[i.increment],(i.x-16-player.x+window.x/2-sx),(i.y-16-player.y+window.y/2-sy),0,zoom); --draw items
      end
    end
  end
  --DYNAMITE
  for key,i in pairs(dynamite) do
    if i.intact == 1 then
      love.graphics.draw(i.sprite,(i.x-player.x+window.x/2-sx),(i.y-player.y+window.y/2-sy),0,zoom*2); --draw dynamite
      love.graphics.draw(i.explosionParticles, (i.x-player.x+window.x/2-sx), (i.y-player.y+window.y/2-sy),0,0,20,20)
    end
  end
  --BULLETS
  for i,v in ipairs(bullets) do
		love.graphics.draw(BulletImg, (v.x-player.x+window.x/2-sx), (v.y-player.y+window.y/2-sy)) --draw bullet
	end
  --CROSSHAIR
  love.graphics.draw(crosshair, love.mouse.getX()-(crosshair:getWidth()/2), love.mouse.getY()-(crosshair:getHeight()/2)) --crosshair
end

return worldupdate
