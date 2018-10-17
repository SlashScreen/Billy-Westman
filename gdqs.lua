--gdjs.lua - test demo
local gdshader = require "modules/shader"
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
  gdqsworld.go_to = "test"

  gradient = gdshader:constructGradient({["r"]=gdshader:toOneBase(255),["g"]=gdshader:toOneBase(255),["b"]=gdshader:toOneBase(255)},{["r"]=gdshader:toOneBase(0),["g"]=gdshader:toOneBase(0),["b"]=gdshader:toOneBase(0)})
  shader = gdshader:gradShader(gradient)

  player = require "modules/player_module";
  baseenemy = require "modules/enemy_module";
  eastman_boss = require "modules/eastman_boss";
  trigger = require "modules/trigger_module";
  dynamiteClass = require "modules/dynamite_module"
  json = require "modules/json"
  wu = require("modules/worldupdate")
  --TownSpawnList = json.decode("assets/spawntable.json")

  spawnlist = {
    {name = "Enemy1",x = 600, y=550,image = "enemybase", class=baseenemy, world = bumpWorld},
    {name = "Enemy2",x = 550, y=400,image = "enemybase", class=baseenemy, world = bumpWorld},
    {name = "Enemy3",x = 450, y=700,image = "enemybase", class=baseenemy, world = bumpWorld},
    {name = "Enemy4",x = 400, y=350,image = "enemybase", class=baseenemy, world = bumpWorld}
  };
  triggerlist = {

  }

  bosses = {name = "east",x = 600, y=550,image = "east", class=eastman_boss, world = bumpWorld}

  DynamiteList = {
    {x = 300, y = 300, sprite = "dynamite"},
    {x = 300, y = 335, sprite = "dynamite"}
  }

  --{id = "Test 2", x = 100, y = 0, imgs = {OTTriggerF,OTTriggerT}, state = 0, btype = "ONCE", linkedto={nil}}
  player, billywestmanimg,BulletImg,OTTriggerF,OTTriggerT,TTriggerF,TTriggerT,DynamiteImg,trig,enemies,dynamite,crosshair,zoom,sx,sy,window,bosses = wu:init(spawnlist,DynamiteList,triggerlist,350,300,currentmap,bosses)
end

function gdqsworld:shoot(body,x,y,coordspace)
  bullets, player = wu:shoot(body,x,y,coordspace,player,window,bullets)
  end


function gdqsworld:shakescreen(val)
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
  wu:draw(bosses,player, enemies, playerWalkTimer,dt,triggers,dynamite,map,gdqsworld,BulletImg,crosshair, window,shader)
end

function gdqsworld:canChange()
  if gdqsworld.changemapConditionsMet == 1 then
    return true, gdqsworld.go_to;
  else
    return false, gdqsworld.go_to
  end

end
function gdqsworld:setChange(gotomap)
  gdqsworld.changemapConditionsMet = 1
  gdqsworld.go_to = gotomap;
end

return gdqsworld
;
