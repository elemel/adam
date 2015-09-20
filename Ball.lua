local Ball = {}
Ball.__index = Ball

function Ball.new(args)
  local ball = {}
  setmetatable(ball, Ball)

  local physics = game.names.physics

  args = args or {}
  local x = args.x or 0
  local y = args.y or 0
  local radius = args.radius or 1
  local angle = args.angle or 0

  ball.body = love.physics.newBody(physics.world, x, y, "kinematic")
  ball.body:setAngle(angle)
  ball.body:setAngularVelocity(0.25 * math.pi)
  ball.body:setLinearVelocity(ball.body:getAngularVelocity() * radius, 0)

  local shape = love.physics.newCircleShape(radius)
  love.physics.newFixture(ball.body, shape)

  ball.time = 0

  game.updates.control[ball] = Ball.update
  return ball
end

function Ball:destroy()
  game.updates.control[self] = nil
  self.body:destroy()
end

function Ball:update(dt)
end

return Ball
