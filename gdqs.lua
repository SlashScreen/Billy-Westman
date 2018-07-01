--testworld.lua
--proof of concept for having multiple worlds without cluttering poor main.lua
--TODO: Do Colission
gdqsworld= {};

function gdqsworld
:load()
  local sti = require ("modules/sti");
  local bump = require ("modules/bump");
  love.graphics.setDefaultFilter("nearest","nearest");
  --Simple-Tiled-Implementation-master-2
  love.graphics.setBackgroundColor(255,255,255);
  love.graphics.setColor(1,1,1);
  window = {}
  window.x = love.graphics:getWidth();
  window.y = love.graphics:getHeight();
  map = sti("assets/maps/techdemomap.lua", {"bump"});
  currentmap = map;
  bumpWorld = bump.newWorld();
  bumptiles = map:bump_init(bumpWorld);
  --print(#bumptiles);
  print(love.getVersion());
  
  gdqsworld.changemapConditionsMet = 0;
  gdqsworld.goto = "test";
  
  player = require "modules/player_module";
  baseenemy = require "modules/enemy_module";
  trigger = require "modules/trigger_module";
  dynamiteClass = require "modules/dynamite_module"
  json = require "modules/json"
  wu = require("modules/worldupdate")
  --TownSpawnList = json.decode("assets/spawntable.json")
  
  player:init(love.graphics.newImage("assets/billywestman.png"), nil, 700, 600, bumpWorld);
  billywestmanimg = love.graphics.newImage("assets/billywestman.png");
  BulletImg = love.graphics.newImage("assets/BillyWestmanBullet.png");
  OTTriggerF = love.graphics.newImage("assets/OneTimeTrigger1False.png");
  OTTriggerT = love.graphics.newImage("assets/OneTimeTrigger1True.png");
  TTriggerF = love.graphics.newImage("assets/ToggleTrigger1-False.png");
  TTriggerT = love.graphics.newImage("assets/ToggleTrigger1-True.png");
  DynamiteImg = love.graphics.newImage("assets/dynamite1.png");
  DynamiteImg:setFilter("nearest","nearest");
  spawnlist = {
    {name = "Enemy1",x = 600, y=550,image = billywestmanimg, class=baseenemy, world = bumpWorld},
    {name = "Enemy2",x = 550, y=400,image = billywestmanimg, class=baseenemy, world = bumpWorld},
    {name = "Enemy3",x = 450, y=700,image = billywestmanimg, class=baseenemy, world = bumpWorld},
    {name = "Enemy4",x = 400, y=300,image = billywestmanimg, class=baseenemy, world = bumpWorld}
  };
  triggerlist = {
    {id = "Test 1", x = 100, y = 50, imgs = {TTriggerF,TTriggerT}, state = 0, btype = "TOGGLE", linkedto={nil}, world = bumpWorld},
    {id = "Test 2", x = 300, y = 100, imgs = {OTTriggerF,OTTriggerT}, state = 0, btype = "ONCE", linkedto={nil},world = bumpWorld}
  }
  
  DynamiteList = {
    {x = 175, y = 175, sprite = DynamiteImg},
    {x = 215, y = 175, sprite = DynamiteImg}
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

function gdqsworld:shoot(body,x,y,coordspace)
  bullets, player = wu:shoot(body,x,y,coordspace,player,window,bullets)
  end
  

function gdqsworld
:shakescreen(val)
  sx = math.random(-val,val);
  sy = math.random(-val,val);
end

function bool_to_number(value)
  return value and 1 or 0
end

function gdqsworld:update(dt)
  wu:update(player, enemies, playerWalkTimer,dt,triggers,dynamite,map,gdqsworld,BulletImg)
end

function gdqsworld:draw()
  wu:draw(player, enemies, playerWalkTimer,dt,triggers,dynamite,map,gdqsworld,BulletImg,crosshair, window)
end

function gdqsworld
:canChange()
  if gdqsworld
.changemapConditionsMet == 1 then
    return true, gdqsworld
.goto;
  else
    return false, gdqsworld
.goto
  end
  
end
function gdqsworld
:setChange(gotomap)
  gdqsworld
.changemapConditionsMet = 1
  gdqsworld
.goto = gotomap;
end

return gdqsworld
;