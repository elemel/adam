local Platform = {}
Platform.__index = Platform

function Platform.new(args)
  local platform = {}
  setmetatable(platform, Platform)

  local physics = game.names.physics

  args = args or {}
  local x = args.x or 0
  local y = args.y or 0
  local width = args.width or 1
  local height = args.height or 1
  local angle = args.angle or 0

  platform.body = love.physics.newBody(physics.world, x, y, "kinematic")
  platform.body:setAngle(angle)

  local shape = love.physics.newRectangleShape(width, height)
  love.physics.newFixture(platform.body, shape)

  platform.time = 0

  game.updates.controls[platform] = Platform.update
  return platform
end

function Platform:destroy()
  game.updates.controls[self] = nil
  self.body:destroy()
end

function Platform:update(dt)
  self.time = self.time + dt
  self.body:setLinearVelocity(-2 * math.sin(self.time), 0)
end

return Platform
