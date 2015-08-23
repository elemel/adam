local Background = {}
Background.__index = Background

function Background.new(args)
  local background = {}
  setmetatable(background, Background)

  game.draws.background[background] = Background.draw

  return background
end

function Background:draw()
  love.graphics.setColor(255, 255, 255, 255)
  self:drawBackground()
  self:drawForeground()
end

function Background:drawBackground()
  local image = game.images.background
  local width, height = image:getDimensions()
  love.graphics.draw(image, 0.5 * game.camera.x, 0.5 * game.camera.y - 4, 0, 1 / 8, 1 / 8, 0.5 * width, 0.5 * height)
end

function Background:drawForeground()
  local image = game.images.foreground
  local width, height = image:getDimensions()
  love.graphics.draw(image, 0, 0, 0, 1 / 8, 1 / 8, 0.5 * width, 0.5 * height)
end

return Background