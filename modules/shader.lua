--shader.lua

shader = {}

function shader:constructGradient(r1,b1,g1,r2,b2,g2)
  gradient = {}
  gradient[color1][r] = r1
  gradient[color1][g] = g1
  gradient[color1][b] = b1
  gradient[color2][r] = r2
  gradient[color2][g] = g2
  gradient[color2][b] = b2
  return gradient
end

function shader:gradShader (gradient)
  local gradeffect = [[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
      number average = (pixel.r+pixel.b+pixel.g)/3.0;
      pixel.r = average;
      pixel.g = average;
      pixel.b = average;
      return pixel;
    }
  ]]
  gradShader = love.graphics.newShader(gradeffect)
  return gradShader
end

return shader
