local common = require "common"

local MouseControls = {}
MouseControls.__index = MouseControls

function MouseControls.new(args)
  local controls = {}
  setmetatable(controls, MouseControls)

  controls.x = 0
  controls.y = 0

  game.updates.controls[controls] = MouseControls.update
  game.draws.debug[controls] = MouseControls.debugDraw

  return controls
end

function MouseControls:destroy()
  game.draws.debug[self] = nil
  game.updates.controls[self] = nil
end

function MouseControls:update(dt)
  local x, y = love.mouse.getPosition()
  local width, height = love.window.getDimensions()

  x = x - 0.5 * width
  y = y - 0.5 * height

  x = x / (game.camera.scale * height)
  y = y / (game.camera.scale * height)

  x = x + game.camera.x
  y = y + game.camera.y

  self.x = x
  self.y = y

  local character = game.names.adam

  if character then
    character.targetX = self.x
    character.targetY = self.y
  end
end

function MouseControls:debugDraw()
  love.graphics.setColor(0x00, 0xff, 0x00, 0xff)
  love.graphics.circle("fill", self.x, self.y, 1 / 8)
end

return MouseControls
