--shader.lua

shader = {}

function lerp(a,b,t)
  return a * (1-t) + b * t
end

function shader:constructGradient(r1,b1,g1,r2,b2,g2)
  gradient = {{["r"]=r1,["g"]=g1,["b"]=b1},{["r"]=r2,["g"]=g2,["b"]=b2}}
  return gradient
end

function unpackGradient(gr)
  return gr[0],gr[1]
end

function shader:gradShader (gradient)
  local r1,g1,b1,r2,g2,b2 = unpackGradient(gradient)
  local gradeffect = [[
    extern number r1;
    extern number g1;
    extern number b1;
    extern number r2;
    extern number g2;
    extern number b2;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
      number average = (pixel.r+pixel.b+pixel.g)/3.0;
      number a = 1/average
      pixel.r = r1 + (r2-pixel.r) * a;
      pixel.g = g1 + (g2-pixel.g) * a;
      pixel.b = b1 + (b2-pixel.b) * a;
      return pixel;
    }
  ]]
  gradShader = love.graphics.newShader(gradeffect)
  return gradShader
end

return shader
