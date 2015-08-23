local Background = {}
Background.__index = Background

function Background.new(args)
  local background = {}
  setmetatable(background, Background)

  game.draws.background[background] = Background.draw

  return background
end

function Background:draw()
  love.graphics.setColor(127, 127, 127, 255)
  love.graphics.draw(game.images.mountains, 0.5 * game.camera.x, -6, 0, 1 / 8, 1 / 8)
end

return Background