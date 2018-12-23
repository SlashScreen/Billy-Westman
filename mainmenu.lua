--mainmenu.lua
mainmenu = {}
bclass = require "modules/buttonclass"
main = require ("main");

function mainmenu:load()
  self.pbutton = bclass:init(10,10,30,15,"play","assets/textbox.png","play")
end

function mainmenu:update()

  function love.mousepressed(x, y, button)
    if button == 1 then
      for b in pairs(buttons) do
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
  for b in pairs(buttons) do
    b:draw()
  end
end
