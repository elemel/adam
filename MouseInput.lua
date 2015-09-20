local common = require "common"

local MouseInput = {}
MouseInput.__index = MouseInput

function MouseInput.new(args)
  local input = {}
  setmetatable(input, MouseInput)

  input.x = 0
  input.y = 0

  game.updates.input[input] = MouseInput.update
  game.draws.debug[input] = MouseInput.debugDraw

  return input
end

function MouseInput:destroy()
  game.draws.debug[self] = nil
  game.updates.input[self] = nil
end

function MouseInput:update(dt)
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

    character.oldAttackInput = character.attackInput
    character.attackInput = love.mouse.isDown("l")
  end
end

function MouseInput:debugDraw()
  love.graphics.setColor(0x00, 0xff, 0x00, 0xff)
  love.graphics.circle("fill", self.x, self.y, 1 / 8)
end

return MouseInput
