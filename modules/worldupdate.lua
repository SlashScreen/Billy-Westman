--worldupdate.lua
worldupdate = {}
local inspect = require('modules/inspect')

function printTable(table)
  for key,value in pairs(table) do
    if type(value) == "table" then
      print(key)
      printTable(value)
    else
      print(key,value)
    end
  end
end

function worldupdate:init(spawnlist,DynamiteList,triggerlist,px,py,map,bosses,items,world)
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

  player:init(love.graphics.newImage("assets/player.png"), nil, px, py, bumpWorld,map);
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
  eastman_boss = require "modules/eastman_boss";
  trigger = require "modules/trigger_module";
  dynamiteClass = require "modules/dynamite_module"
  ammoboxclass = require "modules/ammobox"

  --#LISTS AND MAKEOBJ#
  triggers = {};
  enemies = {};
  dynamite = {};
  item = {};
  local function makeObj(class)
    local mt = { __index = class }
    local obj = setmetatable({}, mt)
    return obj;
  end

  --#NEW STI METHOD#

  objlayer = map.layers["objs"].objects
  print("Incoming")
  --inspect(objlayer)
  i = 1
  for key,value in pairs(objlayer) do
    object = {}
    for key,value in pairs(value) do
    --  print(key,value)
      object[key] = value
    end
    for key,value in pairs(object) do
      print(key,value)
    end
    print("TYPE--",object["type"])
    if object["type"] == "base_enemy" then
      print("made enemy")
      enemies[i] = makeObj(baseenemy);
      enemies[i]:init(enemyimg,object["x"],object["y"],object["name"],world);
    elseif object["type"] == "dynamite" then
      print("made dynamite")
      dynamite[i] = makeObj(dynamiteClass);
      dynamite[i]:init(object["x"],object["y"],DynamiteImg);
    elseif object["type"] == "ammo" then
      print("made ammo")
      dynamite[i] = makeObj(ammoboxclass);
      dynamite[i]:init(ammoboximg,object["x"],object["y"],object["name"],world);
    elseif object["type"] == "trigger" then -- finish implementing
      print("made trigger")
      triggers[i] = makeObj(trigger);
      triggers[i]:init(object["x"],object["y"],true,"OT",OTTriggerF,object["name"],nil,world);
    end
    i = i+1
  end
  print("end")
  --#ENEMIES#
  --[[
  for i=1, #spawnlist do
    print(i)
    if spawnlist[i].image == "billyimage" then
      spawnlist[i].image = billywestmanimg
    elseif spawnlist[i].image == "enemybase" then
      spawnlist[i].image = enemyimg
    end
    enemies[i] = makeObj(spawnlist[i].class);
    enemies[i]:init(spawnlist[i].image,spawnlist[i].x,spawnlist[i].y,spawnlist[i].name,spawnlist[i].world);
  end
  --#ITEMS#
  --items is the list, item is the item objects
  for i=1, #items do
    print(items[i].name)
    item[i] = makeObj(items[i].class);
    item[i]:init(ammoboximg,items[i].x,items[i].y,items[i].name,items[i].world);
  end
  --#BOSS#


  if bosses.image == "east" then
    bosses.image = EastImg
  end
  boss = makeObj(bosses.class);
  print(bosses.image,bosses.x,bosses.y,bosses.name,bosses.world,"boss")
  boss:init(bosses.image,bosses.x,bosses.y,bosses.name,bosses.world);


  --#DYNAMITE#
  for i=1, #DynamiteList do
    if DynamiteList[i].sprite == "dynamite" then
      DynamiteList[i].sprite = DynamiteImg
    end
    dynamite[i] = makeObj(dynamiteClass);
    dynamite[i]:init(DynamiteList[i].x,DynamiteList[i].y,DynamiteList[i].sprite);
  end
  for i=1, #triggerlist do

    if triggerlist[i].imgs == "TT" then
      triggerlist[i].imgs = {TTriggerF,TTriggerT}
    elseif triggerlist[i].imgs == "OT" then
      triggerlist[i].imgs = {OTTriggerF,OTTriggerT}
    end

    triggers[i] = makeObj(trigger);
    triggers[i]:init(triggerlist[i].x,triggerlist[i].y,triggerlist[i].state,triggerlist[i].btype,triggerlist[i].imgs,triggerlist[i].id,triggerlist[i].linkedto,triggerlist[i].world);
  end
  --]]
  crosshair = love.graphics.newImage("assets/crosshair.png");
  bulletSpeed = 300
	bullets = {}
  playerWalkTimer = 0;
  zoom = 1;
  sx = 0;
  sy = 0;
  return player, billywestmanimg,BulletImg,OTTriggerF,OTTriggerT,TTriggerF,TTriggerT,DynamiteImg,trig,enemies,dynamite,crosshair,zoom,sx,sy,window,bosses,item
end




function worldupdate:shoot(body,x,y,coordspace,player,window,bullets)
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
    player.ammo = player.ammo - 1;
    print(player.ammo,"ammo");
    return bullets,player
end

function worldupdate:update(player, enemies, playerWalkTimer,dt,triggers,dynamite,map,world,BulletImg,bosses,item)
  map:update(dt)
  --SHAKESCREEN
  if math.abs(sx) > 0 then
    sx,sy = -sx+sx/2,-sy+sy/2;
    if sx < .1 then
      sx,sy=0,0
    end
  end
  --PLAYER
  if not player.alive then
    main:reset()
  end

  player:calcShadowed()
  player.playerWalkTimer = player.playerWalkTimer + dt
  if player.playerWalkTimer > .5 then
    player:animate("walk");

    for i = 1, #enemies do
      enemies[i]:animate("walk");
    end

    player.playerWalkTimer = 0;
  end
  for i = 1, #item do
    item[i]:animate("float",dt);
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
      table.remove(bullets,i);
      math.randomseed(player.x);
      world:shakescreen(10);
    end
  end
end
--ENEMIES
for i = 1, #enemies do -- main interaction IG w enemies
    if enemies[i].alive == 1 then --if the enemy isn't dead
      if enemies[i].detectedplayer then --If any of them detected the player the player is detected now
        detected = true
      end
      enemies[i]:update(player.x,player.y,dt)
      enemies[i]:decideMovement(player.x,player.y,dt); --walk
      enemies[i]:shoot(player,world,dt) --do shoot calcculations
      for o,v in ipairs(bullets) do -- is hit by bullets?
        if enemies[i]:isHit(v.x, v.y, player.x, player.y, window.x, window.y,BulletImg:getWidth(),BulletImg:getHeight()) or player:isHit(v.x, v.y, player.x, player.y, window.x, window.y,BulletImg:getWidth(),BulletImg:getHeight()) then
          print("hit",v.x,v.y);
          table.remove(bullets,o);
          table.remove(bullets,i);
          math.randomseed(player.x);
          world:shakescreen(10);
        end
      end


  end
end
--DETECTED
if detected then -- followup to player detection
  player.substate = "DETECTED"
else
  player.substate = "UNDETECTED"
end
--TRIGGERS
  for i = 1, #triggers do -- main interaction for Triggers
    if triggers[i].id == "Test 1" then --hardcoded: change
      world:setChange("westham");
    end

      for o,v in ipairs(bullets) do --is hit
        if triggers[i]:isHit(v.x, v.y, player.x, player.y, window.x, window.y,BulletImg:getWidth(),BulletImg:getHeight()) then
          print("hit",v.x,v.y);
          table.remove(bullets,o);
          math.randomseed(player.x);
          world:shakescreen(10);
          --print(sx,sy);
        end
      end
  end
--BULLETS
for i,v in ipairs(bullets) do --bullet script
    v.t = v.t-dt;
		v.x = v.x + (v.dx * dt)
		v.y = v.y + (v.dy * dt)
    if v.t < 0 then --if timer ran out then remove bullet
      table.remove(bullets,i);
    end

	end
--DYNAMITE
--printTable(dynamite)
--print(BulletImg,bullets,enemies,dt,player)
--print(player)
for i=1, #dynamite do
    --print(dynamite[i],i)
    dynamite[i]:update(bullets,enemies,player,dynamite,BulletImg:getWidth(),BulletImg:getHeight(),dt);
  end

  if player.state == "FIRE" then
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
--ITEMS
for i = 1, #item do
  if item[i].type == "ammo" then
    if not item[i].taken then
      if item[i]:iscolliding(player.x,player.y,32,32) then
        player:instantRefill()
        item[i]:take()
      end
  end
  end
end

--RECHARGE
if player.state == "PLAY" and player.substate == "UNDETECTED" and player.ammo < player.maxammo then
    player.rechargetimer = player.rechargetimer + dt;
    if player.rechargetimer > player.rechargelimit then
        player:changeammo(1)
        print(player.ammo,"ammorecharge", player.rechargetimer);
        player.rechargetimer = 0;
    end
  end
end

function worldupdate:draw(bosses, player, enemies, playerWalkTimer,dt,triggers,dynamite,map,world,BulletImg,crosshair, window,shader,item)
  --SHADER
  love.graphics.setShader(shader)
  --MAP
  map:draw(window.x/2-player.x-sx-16,window.y/2-player.y-sy-16);
  --PLAYER
  love.graphics.draw(player.icon,player.frames[player.increment],window.x/2-16-sx,window.y/2-16-sy,0);
  --ENEMIES
  for i = 1, #enemies do
    if enemies[i].alive == 1 then --if alive then
      love.graphics.draw(enemies[i].icon,enemies[i].frames[enemies[i].increment],(enemies[i].x-16-player.x+window.x/2-sx),(enemies[i].y-16-player.y+window.y/2-sy),0,zoom); --draw enemies
    end
  end
  --BOSS
  if bosses.alive == 1 then --if alive then
    love.graphics.draw(bosses.icon,bosses.frames[bosses.increment],(bosses.x-16-player.x+window.x/2-sx),(bosses.y-16-player.y+window.y/2-sy),0,zoom); --draw bosses
  end
  --TRIGGERS
  for i = 1, #triggers do
    love.graphics.draw(triggers[i].imgs[bool_to_number(triggers[i].state) + 1],(triggers[i].x-16-player.x+window.x/2-sx),(triggers[i].y-16-player.y+window.y/2-sy),0,zoom); --draw triggers
  end
  --ITEMS
  for i = 1, #item do
    if item[i].type == "ammo" then
      if not item[i].taken then

        love.graphics.draw(item[i].img,item[i].frames[item[i].increment],(item[i].x-16-player.x+window.x/2-sx),(item[i].y-16-player.y+window.y/2-sy),0,zoom); --draw items
      end
    end
  end
  --DYNAMITE
  for i=1, #dynamite do
    if dynamite[i].intact == 1 then
      love.graphics.draw(dynamite[i].sprite,(dynamite[i].x-player.x+window.x/2-sx),(dynamite[i].y-player.y+window.y/2-sy),0,zoom*2); --draw dynamite
      love.graphics.draw(dynamite[i].explosionParticles, (dynamite[i].x-player.x+window.x/2-sx), (dynamite[i].y-player.y+window.y/2-sy),0,0,20,20)
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
