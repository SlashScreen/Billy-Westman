--testworld.lua
--proof of concept for having multiple worlds without cluttering poor main.lua
--TODO: Do Colission
testworld = {};
function testworld:load()
  local sti = require ("modules/sti");
  local bump = require ("modules/bump");
  --Simple-Tiled-Implementation-master-2
  love.graphics.setBackgroundColor(255,255,255);
  love.graphics.setColor(1,1,1);
  window = {}
  window.x = love.graphics:getWidth();
  window.y = love.graphics:getHeight();
  testmap = sti("assets/maps/testmap.lua", {"bump"});
  currentmap = testmap;
  bumpWorld = bump.newWorld();
  bumptiles = testmap:bump_init(bumpWorld);
  --print(#bumptiles);
  print(love.getVersion());
  
  testworld.changemapConditionsMet = 0;
  testworld.goto = "";
  
  player = require "modules/player_module";
  baseenemy = require "modules/enemy_module";
  trigger = require "modules/trigger_module";
  dynamiteClass = require "modules/dynamite_module"
  json = require "modules/json"
  --TownSpawnList = json.decode("assets/spawntable.json")
  
  player:init(love.graphics.newImage("assets/billywestman.png"), nil, 300, 350, bumpWorld);
  billywestmanimg = love.graphics.newImage("assets/billywestman.png");
  BulletImg = love.graphics.newImage("assets/BillyWestmanBullet.png");
  OTTriggerF = love.graphics.newImage("assets/OneTimeTrigger1False.png");
  OTTriggerT = love.graphics.newImage("assets/OneTimeTrigger1True.png");
  TTriggerF = love.graphics.newImage("assets/ToggleTrigger1-False.png");
  TTriggerT = love.graphics.newImage("assets/ToggleTrigger1-True.png");
  DynamiteImg = love.graphics.newImage("assets/dynamite1.png");
  spawnlist = {
    {name = "Enemy1",x = -100, y=150,image = billywestmanimg, class=baseenemy, world = bumpWorld},
    {name = "Enemy2",x = 200, y=150,image = billywestmanimg, class=baseenemy, world = bumpWorld},
    {name = "Enemy3",x = 100, y=0,image = billywestmanimg, class=baseenemy, world = bumpWorld},
    {name = "Enemy4",x = 0, y=300,image = billywestmanimg, class=baseenemy, world = bumpWorld}
  };
  triggerlist = {
    {id = "Test 1", x = 100, y = 50, imgs = {TTriggerF,TTriggerT}, state = 0, btype = "TOGGLE", linkedto={nil}, world = bumpWorld},
    {id = "Test 2", x = 300, y = 100, imgs = {OTTriggerF,OTTriggerT}, state = 0, btype = "ONCE", linkedto={nil},world = bumpWorld}
  }
  
  DynamiteList = {
    {x = 175, y = 175, sprite = DynamiteImg}
  }
  
  --{id = "Test 2", x = 100, y = 0, imgs = {OTTriggerF,OTTriggerT}, state = 0, btype = "ONCE", linkedto={nil}}
  triggers = {};
  enemies = {};
  dynamite = {};
  local function makeObj(class)
    local mt = { __index = class }
    local obj = setmetatable({}, mt)
    return obj;
  end
  for i=1, #spawnlist do
    enemies[i] = makeObj(spawnlist[i].class);
    enemies[i]:init(spawnlist[i].image,nil,spawnlist[i].x,spawnlist[i].y,spawnlist[i].name,spawnlist[i].world);
  end
  for i=1, #DynamiteList do
    dynamite[i] = makeObj(dynamiteClass);
    dynamite[i]:init(DynamiteList[i].x,DynamiteList[i].y,DynamiteList[i].sprite);
  end
  for i=1, #triggerlist do
    triggers[i] = makeObj(trigger);
    triggers[i]:init(triggerlist[i].x,triggerlist[i].y,triggerlist[i].state,triggerlist[i].btype,triggerlist[i].imgs,triggerlist[i].id,triggerlist[i].linkedto,triggerlist[i].world);
    --bumpWorld:add(triggers[i], triggerlist[i].x, triggerlist[i].y, 16, 16);
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
function testworld:update(dt)
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
    if enemies[i].alive == 1 then
      enemies[i]:decideMovement(player.x,player.y,dt);
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
    if triggers[i].id == "Test 1" then
      testworld:setChange("westham");
    end
    
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
    for i=1, #dynamite do
    dynamite[i]:update(bullets,enemies,player,dynamite)
  end
end
function testworld:draw()
  testmap:draw(window.x/2-player.x-sx-16,window.y/2-player.y-sy-16);
  --testmap:bump_draw(bumpWorld,window.x/2-player.x-sx-16,window.y/2-player.y-sy-16);
  love.graphics.draw(player.icon,player.frames[player.increment],window.x/2-16-sx,window.y/2-16-sy,0,zoom);
  
  for i = 1, #enemies do
    if enemies[i].alive == 1 then --if alive then
      love.graphics.draw(
        enemies[i].icon,
        enemies[i].frames[enemies[i].increment],
        enemies[i].x-16-player.x+window.x/2-sx,
        enemies[i].y-16-player.y+window.y/2-sy,
        0,
        zoom
        ); --draw enemies
  end
  for i = 1, #triggers do
    love.graphics.draw(
      triggers[i].imgs[bool_to_number(triggers[i].state) + 1],
      triggers[i].x-16-player.x+window.x/2-sx,
      triggers[i].y-16-player.y+window.y/2-sy,
      0,
      zoom
      );
  end
  
end

for i=1, #dynamite do
  if dynamite[i].intact == 1 then
    love.graphics.draw(
      dynamite[i].sprite,
      dynamite[i].x-16-player.x+window.x/2-sx,
      dynamite[i].y-16-player.y+window.y/2-sy,
      0,
      zoom
    );
  end
  
end


  for i,v in ipairs(bullets) do
		love.graphics.draw(BulletImg, v.x-player.x+window.x/2-sx, v.y-player.y+window.y/2-sy) --draw bullet
	end
  
  love.graphics.draw(crosshair, love.mouse.getX()-(crosshair:getWidth()/2), love.mouse.getY()-(crosshair:getHeight()/2))
end

function testworld:canChange()
  if testworld.changemapConditionsMet == 1 then
    return true, testworld.goto;
  else
    return false, testworld.goto
  end
  
end
function testworld:setChange(gotomap)
  testworld.changemapConditionsMet = 1
  testworld.goto = gotomap;
end

return testworld;