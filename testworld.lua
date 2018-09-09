--testworld.lua
--proof of concept for having multiple worlds without cluttering poor main.lua
--TODO: Do Colission
testworld = {};




function testworld:load()
  local sti = require ("modules/sti");
  local bump = require ("modules/bump");
  map = sti("assets/maps/testmap.lua", {"bump"});
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
  wu = require("modules/worldupdate")
  json = require "modules/json"
  --TownSpawnList = json.decode("assets/spawntable.json")


  spawnlist = {
    {name = "Enemy1",x = -100, y=150,image = "billyimage", class=baseenemy, world = bumpWorld},
    {name = "Enemy2",x = 200, y=150,image = "billyimage", class=baseenemy, world = bumpWorld},
    {name = "Enemy3",x = 100, y=0,image = "billyimage", class=baseenemy, world = bumpWorld},
    {name = "Enemy4",x = 0, y=300,image = "billyimage", class=baseenemy, world = bumpWorld}
  };
  triggerlist = {
    {id = "Test 1", x = 100, y = 50, imgs = "TT", state = 0, btype = "TOGGLE", linkedto={nil}, world = bumpWorld},
    {id = "Test 2", x = 300, y = 100, imgs = "OT", state = 0, btype = "ONCE", linkedto={nil},world = bumpWorld}
  }

  DynamiteList = {
    {x = 175, y = 175, sprite = "dynamite"},
    {x = 215, y = 175, sprite = "dynamite"}
  }

  --{id = "Test 2", x = 100, y = 0, imgs = {OTTriggerF,OTTriggerT}, state = 0, btype = "ONCE", linkedto={nil}}
  player, billywestmanimg,BulletImg,OTTriggerF,OTTriggerT,TTriggerF,TTriggerT,DynamiteImg,trig,enemies,dynamite,crosshair,zoom,sx,sy,window = wu:init(spawnlist,DynamiteList,triggerlist, 150, 150,map)
end

function testworld:shoot(body,x,y,coordspace)
  bullets, player = wu:shoot(body,x,y,coordspace,player,window,bullets)
end

function testworld:shakescreen(val)
  sx = math.random(-val,val);
  sy = math.random(-val,val);
end

function bool_to_number(value)
  return value and 1 or 0
end

function testworld:update(dt)
  wu:update(player, enemies, playerWalkTimer,dt,triggers,dynamite,map,testworld,BulletImg)
end

function love.mousepressed(x, y, button)
	if button == 1 and player.ammo > 0 then
    testworld:shoot(player,x,y,0);
  end

end

function testworld:draw()
  wu:draw(player, enemies, playerWalkTimer,dt,triggers,dynamite,map,testworld,BulletImg,crosshair, window)
end
function testworld:setChange(gotomap)
  testworld.changemapConditionsMet = 1
  testworld.goto = gotomap;
end

return testworld;
