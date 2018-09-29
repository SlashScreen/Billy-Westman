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
  return gr[1]["r"],gr[1]["g"],gr[1]["b"],gr[2]["r"],gr[2]["g"],gr[2]["b"]
end

function shader:gradShader (gradient)
  --print(unpackGradient(gradient))
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
      number a = 1/average;
      pixel.r = mix(r1,r2,a);
      pixel.g = mix(g1,g2,a);
      pixel.b = mix(b1,b2,a);
      return pixel;
    }
  ]]
  gradShader = love.graphics.newShader(gradeffect)
  return gradShader
end

return shader
