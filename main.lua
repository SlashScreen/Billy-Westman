--main.lua
function love.load()
  local sti = require ("modules/sti");
  --Simple-Tiled-Implementation-master-2
  love.graphics.setBackgroundColor(255,255,255);
  love.graphics.setColor(1,1,1);
  window = {}
  window.x = love.graphics:getWidth();
  window.y = love.graphics:getHeight();
  testmap = sti("assets/maps/testmap.lua");
  testworld = require "testworld"
  currentmap = testmap;
  print(love.getVersion());
  
  player = require "modules/player_module";
  baseenemy = require "modules/enemy_module";
  trigger = require "modules/trigger_module";
  json = require "modules/json"
  --TownSpawnList = json.decode("assets/spawntable.json")
  
  player:init(love.graphics.newImage("assets/billywestman.png"), nil, 0, 0);
  billywestmanimg = love.graphics.newImage("assets/billywestman.png");
  BulletImg = love.graphics.newImage("assets/BillyWestmanBullet.png");
  OTTriggerF = love.graphics.newImage("assets/OneTimeTrigger1False.png");
  OTTriggerT = love.graphics.newImage("assets/OneTimeTrigger1True.png");
  TTriggerF = love.graphics.newImage("assets/ToggleTrigger1-False.png");
  TTriggerT = love.graphics.newImage("assets/ToggleTrigger1-True.png");
  spawnlist = {
    {name = "Enemy1",x = -100, y=150,image = billywestmanimg, class=baseenemy},
    {name = "Enemy2",x = 200, y=150,image = billywestmanimg, class=baseenemy},
    {name = "Enemy3",x = 100, y=0,image = billywestmanimg, class=baseenemy},
    {name = "Enemy4",x = 0, y=300,image = billywestmanimg, class=baseenemy}
  };
  triggerlist = {{id = "Test 1", x = -100, y = 0, imgs = {TTriggerF,TTriggerT}, state = 0, btype = "TOGGLE", linkedto={nil}}}
  triggers = {};
  enemies = {};
  local function makeObj(class)
    local mt = { __index = class }
    local obj = setmetatable({}, mt)
    return obj;
  end
  for i=1, #spawnlist do
    enemies[i] = makeObj(spawnlist[i].class);
    enemies[i]:init(spawnlist[i].image,nil,spawnlist[i].x,spawnlist[i].y,spawnlist[i].name);
  end
  for i=1, #triggerlist do
    triggers[i] = makeObj(trigger);
    triggers[i]:init(triggerlist[i].x,triggerlist[i].y,triggerlist[i].state,triggerlist[i].btype,triggerlist[i].imgs,triggerlist[i].id,triggerlist[i].linkedto);
  end
  crosshair = love.graphics.newImage("assets/crosshair.png");
  
  bulletSpeed = 150
 
	bullets = {}
  
  
  playerWalkTimer = 0;
  zoom = 1;
  
  sx = 0;
  sy = 0;
end
function bool_to_number(value)
  return value and 1 or 0
end
function love.update(dt)
  testmap:update(dt)
  if math.abs(sx) > 0 then
    sx,sy = 0,0;
  end
  
  playerWalkTimer = playerWalkTimer + dt
  if playerWalkTimer > .5 then
    player:animate("walk");
    for i = 1, #enemies do
      enemies[i]:animate("walk");
    end
    playerWalkTimer = 0;
  end
for i = 1, #enemies do -- main interaction IG
    enemies[i]:decideMovement(player.x,player.y,dt);
    if enemies[i].alive == 1 then
      for o,v in ipairs(bullets) do
        if enemies[i]:isHit(v.x, v.y, player.x, player.y, window.x, window.y,BulletImg:getWidth(),BulletImg:getHeight()) then
          print("hit",v.x,v.y);
          table.remove(bullets,o);
          math.randomseed(player.x);
          sx = math.random(-10,10);
          sy = math.random(-10,10);
          --print(sx,sy);
        end
      end
      
      
  end
  for i = 1, #triggers do -- main interaction for Triggers
      for o,v in ipairs(bullets) do
        if triggers[i]:isHit(v.x, v.y, player.x, player.y, window.x, window.y,BulletImg:getWidth(),BulletImg:getHeight()) then
          print("hit",v.x,v.y);
          table.remove(bullets,o);
          math.randomseed(player.x);
          sx = math.random(-10,10);
          sy = math.random(-10,10);
          --print(sx,sy);
        end
      end
  end
for i,v in ipairs(bullets) do --bullet script
    v.t = v.t-dt;
		v.x = v.x + (v.dx * dt)
		v.y = v.y + (v.dy * dt)
    if v.t < 0 then
      table.remove(bullets,i);
    end
    
	end

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
if player.state == "PLAY" and player.ammo < 10 then
    player.rechargetimer = player.rechargetimer + dt;
    if player.rechargetimer > player.rechargelimit then
        player.ammo = player.ammo+1;
        print(player.ammo,"ammorecharge", player.rechargetimer);
        player.rechargetimer = 0;
    end
  end
end
function love.mousepressed(x, y, button)
	if button == 1 and player.ammo > 0 then
    player.state = "FIRE";
		local startX = player.x--window.x / 2
		local startY = player.y--window.y / 2
		local mouseX = player.x + x - window.x / 2
		local mouseY = player.y + y - window.y / 2
 
		local angle = math.atan2((mouseY - startY), (mouseX - startX))
 
		local bulletDx = bulletSpeed * math.cos(angle)
		local bulletDy = bulletSpeed * math.sin(angle)
    
    local bulletTime = 3;
 
		table.insert(bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy, t = bulletTime})
    
    player.ammo = player.ammo - 1;
    print(player.ammo,"ammo");
  end
end

function love.draw()
  testmap:draw(-player.x-sx,-player.y-sy);
  love.graphics.draw(player.icon,player.frames[player.increment],window.x/2-16-sx,window.y/2-16-sy,0,zoom);
  for i = 1, #enemies do
    if enemies[i].alive == 1 then --if alive then
      love.graphics.draw(enemies[i].icon,enemies[i].frames[enemies[i].increment],enemies[i].x-16-player.x+window.x/2-sx,enemies[i].y-16-player.y+window.y/2-sy,0,zoom); --draw enemies
  end
  for i = 1, #triggers do
    love.graphics.draw(triggers[i].imgs[bool_to_number(triggers[i].state) + 1],triggers[i].x-16-player.x+window.x/2-sx,triggers[i].y-16-player.y+window.y/2-sy, 0, zoom);
  end
  
  end
  for i,v in ipairs(bullets) do
		love.graphics.draw(BulletImg, v.x-player.x+window.x/2-sx, v.y-player.y+window.y/2-sy) --draw bullet
	end
  
  love.graphics.draw(crosshair, love.mouse.getX()-(crosshair:getWidth()/2), love.mouse.getY()-(crosshair:getHeight()/2))
  testworld:draw();
end
