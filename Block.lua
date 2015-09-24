local Block = {}
Block.__index = Block

function Block.new(args)
  local block = {}
  setmetatable(block, Block)

  local physics = game.names.physics

  args = args or {}

  local x = args.x or 0
  local y = args.y or 0

  local bodyType = args.bodyType or "static"

  local angle = args.angle or 0

  local linearVelocityX = args.linearVelocityX or 0
  local linearVelocityY = args.linearVelocityY or 0

  local angularVelocity = args.angularVelocity or 0

  local width = args.width or 0.6
  local height = args.height or 0.6

  local density = args.density or 1

  block.body = love.physics.newBody(physics.world, x, y, bodyType)
  block.body:setAngle(angle)
  block.body:setLinearVelocity(linearVelocityX, linearVelocityY)
  block.body:setAngularVelocity(angularVelocity)

  local shape = love.physics.newRectangleShape(width, height)
  love.physics.newFixture(block.body, shape, density)

  game.draws.scene[block] = Block.draw
  return block
end

function Block:destroy()
  game.draws.scene[self] = nil
  self.body:destroy()
end

function Block:draw()
  local x, y = self.body:getPosition()
  local angle = self.body:getAngle()
  local pixelScale = 0.3 / 4
  local width, height = game.images.block:getDimensions()

  love.graphics.setColor(0xff, 0xff, 0xff, 0xff)
  love.graphics.draw(game.images.block, x, y, angle, pixelScale, pixelScale, 0.5 * width, 0.5 * height)
end

return Block
