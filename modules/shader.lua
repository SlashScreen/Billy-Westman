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
  return gr[1],gr[2]
end

function shader:gradShader (gradient)
  --print(unpackGradient(gradient))

  local gradeffect = [[
  extern vec3 fromCol;
  extern vec3 toCol;

  vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
    vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
    number average = dot(pixel.rgb, vec3(1.0/3.0));
    number a = average;
    pixel.rgb = mix(fromCol, toCol, a);
    return pixel;
  }
  ]]
  gradShader = love.graphics.newShader(gradeffect)
  fromCol, toCol = unpackGradient(gradient)
  --print(fromCol["r"], toCol["r"])
  gradShader:send("fromCol", {fromCol["r"],fromCol["g"],fromCol["b"]})
  gradShader:send("toCol", {toCol["r"],toCol["g"],toCol["b"]})
  return gradShader
end

return shader
