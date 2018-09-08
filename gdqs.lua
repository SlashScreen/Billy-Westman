--testworld.lua
--proof of concept for having multiple worlds without cluttering poor main.lua
--TODO: Do Colission
gdqsworld= {};

function gdqsworld:load()
  local sti = require ("modules/sti");
  local bump = require ("modules/bump");
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
  
  spawnlist = {
    {name = "Enemy1",x = 600, y=550,image = "billyimage", class=baseenemy, world = bumpWorld},
    {name = "Enemy2",x = 550, y=400,image = "billyimage", class=baseenemy, world = bumpWorld},
    {name = "Enemy3",x = 450, y=700,image = "billyimage", class=baseenemy, world = bumpWorld},
    {name = "Enemy4",x = 400, y=350,image = "billyimage", class=baseenemy, world = bumpWorld}
  };
  triggerlist = {
    
  }
  
  DynamiteList = {
    {x = 300, y = 300, sprite = "dynamite"},
    {x = 300, y = 335, sprite = "dynamite"}
  }
  
  --{id = "Test 2", x = 100, y = 0, imgs = {OTTriggerF,OTTriggerT}, state = 0, btype = "ONCE", linkedto={nil}}
  player, billywestmanimg,BulletImg,OTTriggerF,OTTriggerT,TTriggerF,TTriggerT,DynamiteImg,trig,enemies,dynamite,crosshair,zoom,sx,sy,window = wu:init(spawnlist,DynamiteList,triggerlist,350,300)
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