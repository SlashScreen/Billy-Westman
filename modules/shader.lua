--shader.lua

shader = {}
inspect = require('modules/inspect')

function shader:constructGradient(color1,color2)
  gradient = {color2,color1} --make pack
  return gradient
end

function shader:toOneBase(val) --convert  255 base to 1 base I hope
  return val/255
end

function unpackGradient(gr)
  return gr[1],gr[2] --turn pack into 2 objects
end

function shader:gradShader (gradient)
  local gradeffect = [[
  extern vec3 fromCol; //color1
  extern vec3 toCol; //color2

  vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
    vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
    number average = dot(pixel.rgb, vec3(1.0/3.0));//convert pixel to black and white
    if (pixel.r == pixel.g && pixel.g == pixel.b){
      pixel.rgb = mix(fromCol, toCol, average); //use average as alpha for lerp "mix" function between colors 1 and 2
      return pixel;
    }
    else{
      return pixel;
    }

  }
  ]] --shader script

  gradShader = love.graphics.newShader(gradeffect) --shader object
  fromCol, toCol = unpackGradient(gradient) --get colors from gradient object
  --print(inspect(fromCol))
  gradShader:send("fromCol", {fromCol["r"],fromCol["g"],fromCol["b"]}) --send to shader
  gradShader:send("toCol", {toCol["r"],toCol["g"],toCol["b"]})
  return gradShader
end

return shader
