--worldupdate.lua
worldupdate = {}

function worldupdate:init(spawnlist,DynamiteList,triggerlist,px,py,map,bosses)
  bosses = bosses or {}
  local sti = require ("modules/sti");
  local bump = require ("modules/bump");
  love.graphics.setDefaultFilter("nearest","nearest");
  love.graphics.setBackgroundColor(255,255,255);
  love.graphics.setColor(1,1,1);
  window = {}
  window.x = love.graphics:getWidth();
  window.y = love.graphics:getHeight();

  player:init(love.graphics.newImage("assets/player.png"), nil, px, py, bumpWorld,map);
  billywestmanimg = love.graphics.newImage("assets/player.png");
  enemyimg = love.graphics.newImage("assets/enemy.png");
  BulletImg = love.graphics.newImage("assets/BillyWestmanBullet.png");
  OTTriggerF = love.graphics.newImage("assets/OneTimeTrigger1False.png");
  OTTriggerT = love.graphics.newImage("assets/OneTimeTrigger1True.png");
  TTriggerF = love.graphics.newImage("assets/ToggleTrigger1-False.png");
  TTriggerT = love.graphics.newImage("assets/ToggleTrigger1-True.png");
  DynamiteImg = love.graphics.newImage("assets/dynamite1.png");
  EastImg = love.graphics.newImage("assets/eman.png");
  DynamiteImg:setFilter("nearest","nearest");

  triggers = {};
  enemies = {};
  dynamite = {};
  local function makeObj(class)
    local mt = { __index = class }
    local obj = setmetatable({}, mt)
    return obj;
  end
  --#ENEMIES#
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
  crosshair = love.graphics.newImage("assets/crosshair.png");
  bulletSpeed = 300
	bullets = {}
  playerWalkTimer = 0;
  zoom = 1;
  sx = 0;
  sy = 0;
  return player, billywestmanimg,BulletImg,OTTriggerF,OTTriggerT,TTriggerF,TTriggerT,DynamiteImg,trig,enemies,dynamite,crosshair,zoom,sx,sy,window,bosses
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

function worldupdate:update(player, enemies, playerWalkTimer,dt,triggers,dynamite,map,world,BulletImg,bosses)
  map:update(dt)
  if math.abs(sx) > 0 then
    sx,sy = -sx+sx/2,-sy+sy/2;
    if sx < .1 then
      sx,sy=0,0
    end
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
if detected then -- followup to player detection
  player.substate = "DETECTED"
else
  player.substate = "UNDETECTED"
end

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
for i,v in ipairs(bullets) do --bullet script
    v.t = v.t-dt;
		v.x = v.x + (v.dx * dt)
		v.y = v.y + (v.dy * dt)
    if v.t < 0 then --if timer ran out then remove bullet
      table.remove(bullets,i);
    end

	end
 for i=1, #dynamite do

  end

for i=1, #dynamite do
    dynamite[i]:update(bullets,enemies,player,dynamite,BulletImg:getWidth(),BulletImg:getHeight(),dt);
  end

  if player.state == "FIRE" then
    player.rechargetimer = 0;
  end

if love.keyboard.isDown("w") then
  player:decideMovement(0,1);
end
if love.keyboard.isDown("s") then
  player:decideMovement(0,-1);
end
if love.keyboard.isDown("a") then
  player:decideMovement(-1,0);
end
if love.keyboard.isDown("d") then
  player:decideMovement(1,0);
end

if not love.mouse.isDown(1) then
  player.state = "PLAY";
end
--print(player.state);
if player.state == "PLAY" and player.substate == "UNDETECTED" and player.ammo < 10 then
    player.rechargetimer = player.rechargetimer + dt;
    if player.rechargetimer > player.rechargelimit then
        player.ammo = player.ammo+1;
        print(player.ammo,"ammorecharge", player.rechargetimer);
        player.rechargetimer = 0;
    end
  end
end

function worldupdate:draw(bosses, player, enemies, playerWalkTimer,dt,triggers,dynamite,map,world,BulletImg,crosshair, window,shader)
  love.graphics.setShader(shader)
  map:draw(window.x/2-player.x-sx-16,window.y/2-player.y-sy-16);
  love.graphics.draw(player.icon,player.frames[player.increment],window.x/2-16-sx,window.y/2-16-sy,0);

  for i = 1, #enemies do
    if enemies[i].alive == 1 then --if alive then
      love.graphics.draw(enemies[i].icon,enemies[i].frames[enemies[i].increment],(enemies[i].x-16-player.x+window.x/2-sx),(enemies[i].y-16-player.y+window.y/2-sy),0,zoom); --draw enemies
    end
  end
  if bosses.alive == 1 then --if alive then
    love.graphics.draw(bosses.icon,bosses.frames[bosses.increment],(bosses.x-16-player.x+window.x/2-sx),(bosses.y-16-player.y+window.y/2-sy),0,zoom); --draw bosses
  end
  for i = 1, #triggers do
    love.graphics.draw(triggers[i].imgs[bool_to_number(triggers[i].state) + 1],(triggers[i].x-16-player.x+window.x/2-sx),(triggers[i].y-16-player.y+window.y/2-sy),0,zoom); --draw triggers
  end
  for i=1, #dynamite do
    if dynamite[i].intact == 1 then
      love.graphics.draw(dynamite[i].sprite,(dynamite[i].x-player.x+window.x/2-sx),(dynamite[i].y-player.y+window.y/2-sy),0,zoom*2); --draw dynamite
      love.graphics.draw(dynamite[i].explosionParticles, (dynamite[i].x-player.x+window.x/2-sx), (dynamite[i].y-player.y+window.y/2-sy),0,0,20,20)
    end
  end
  for i,v in ipairs(bullets) do
		love.graphics.draw(BulletImg, (v.x-player.x+window.x/2-sx), (v.y-player.y+window.y/2-sy),zoom) --draw bullet
	end

  love.graphics.draw(crosshair, love.mouse.getX()-(crosshair:getWidth()/2), love.mouse.getY()-(crosshair:getHeight()/2)) --crosshair
end

return worldupdate
