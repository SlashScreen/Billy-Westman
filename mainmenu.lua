--mainmenu.lua
mainmenu = {}
bclass = require "modules/buttonclass"
utils = require "modules/utils"
main = require ("main");

function mainmenu:load()
  buttons = {}
  self.pbutton = bclass:init(100,100,75,50,"play","assets/textbox.png","play")
  newobj = utils:makeObj(bclass) --make the object
  newobj:init(10,10,30,15,"play","assets/textbox.png","play") --init the object
  buttons[#buttons+1] = newobj;
  --love.mouse.setVisible(true);
end

function mainmenu:update()

  function love.mousepressed(x, y, button)
    if button == 1 then
      for n,b in pairs(buttons) do
        if b:clicked(x,y) then
          --do event
          ev = b:getEvent()
          if ev == "play" then
            main:changeLevel("westham")
          end
        end
      end
    end
  end

end

function mainmenu:draw()
  for n,b in pairs(buttons) do
    b:draw()
  end
end
return mainmenu
