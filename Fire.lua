local common = require "common"

local Fire = {}
Fire.__index = Fire

function Fire.new(args)
  local fire = {}
  setmetatable(fire, Fire)

  fire.x = args.x or 0
  fire.y = args.y or 0

  fire.particles = love.graphics.newParticleSystem(game.images.pixel, 32)
  fire.particles:setPosition(fire.x, fire.y)
  fire.particles:setEmissionRate(64)
  fire.particles:setParticleLifetime(0.5)
  fire.particles:setAreaSpread("uniform", 0.25, 0.25)
  fire.particles:setSizes(1 / 4)
  fire.particles:setColors(
    {common.toByteColor(1, 0, 0, 0)},
    {common.toByteColor(1, 0.25, 0, 0.5)},
    {common.toByteColor(1, 0.75, 0.25, 1)},
    {common.toByteColor(1, 0.5, 0, 0.75)},
    {common.toByteColor(1, 0.25, 0, 0.5)},
    {common.toByteColor(1, 0, 0, 0.25)},
    {common.toByteColor(1, 0, 0, 0)})

  fire.particles:setRotation(-math.pi, math.pi)
  fire.particles:setLinearDamping(1 / 16, 1 / 8)
  fire.particles:setSpeed(-1, 1)
  fire.particles:setLinearAcceleration(0, -10, 0, -10)

  game.updates.physics[fire] = Fire.update
  game.draws.particles[fire] = Fire.draw

  return fire
end

function Fire:destroy()
  game.draws.particles[fire] = nil
  game.updates.physics[self] = nil
end

function Fire:update(dt)
  self.particles:setPosition(self.x, self.y)
  self.particles:update(dt)
end

function Fire:draw()
  love.graphics.setBlendMode("additive")
  love.graphics.draw(self.particles)
  love.graphics.setBlendMode("alpha")
end

return Fire