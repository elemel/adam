local common = require "common"

local Lightning = {}
Lightning.__index = Lightning

function Lightning.new(args)
  local lightning = {}
  setmetatable(lightning, Lightning)

  lightning.x1 = args.x1 or 0
  lightning.y1 = args.y1 or 0

  lightning.x2 = args.x2 or 0
  lightning.y2 = args.y2 or 0

  lightning.minTtl = 1 / 8
  lightning.maxTtl = 1 / 2

  lightning.density = args.density or 1
  lightning.width = args.width or 1

  lightning.particles = {}
  lightning.vertices = {}

  game.updates.physics[lightning] = Lightning.update
  game.draws.particles[lightning] = Lightning.draw

  return lightning
end

function Lightning:destroy()
  game.draws.particles[self] = nil
  game.updates.physics[self] = nil
end

function Lightning:update(dt)
  self:updateParticles(dt)
  self:updateVertices(dt)
end

function Lightning:updateParticles(dt)
  local tangentX, tangentY, length = common.normalize(
    self.x2 - self.x1, self.y2 - self.y1)
  local normalX, normalY = -tangentY, tangentX

  local size = math.floor(self.density * length)

  while #self.particles > size do
    table.remove(self.particles)
  end

  while #self.particles < size do
    table.insert(self.particles, {x = 0, y = 0, ttl = -1})
  end

  for i, particle in pairs(self.particles) do
    particle.ttl = particle.ttl - dt

    if particle.ttl < 0 then
      local origin = love.math.random()
      local offset = love.math.random()

      local originX = self.x1 + origin * length * tangentX
      local originY = self.y1 + origin * length * tangentY

      local offsetX = (2 * offset - 1) * self.width * normalX
      local offsetY = (2 * offset - 1) * self.width * normalY

      particle.x = originX + offsetX 
      particle.y = originY + offsetY

      particle.ttl = self.minTtl + love.math.random() * (self.maxTtl - self.minTtl)
    end
  end

  table.sort(self.particles, function(a, b)
    return common.dot(a.x, a.y, tangentX, tangentY) < common.dot(b.x, b.y, tangentX, tangentY)
  end)
end

function Lightning:updateVertices(dt)
  self.vertices = {}

  table.insert(self.vertices, self.x1)
  table.insert(self.vertices, self.y1)

  for i, particle in ipairs(self.particles) do
    if particle.ttl > 0 then
      table.insert(self.vertices, particle.x)
      table.insert(self.vertices, particle.y)
    end
  end

  table.insert(self.vertices, self.x2)
  table.insert(self.vertices, self.y2)
end

function Lightning:draw(dt)
  love.graphics.setBlendMode("additive")

  love.graphics.setColor(0, 0, 255, 63)
  love.graphics.setLineWidth(4 / 8)
  love.graphics.line(self.vertices)

  love.graphics.setColor(0, 127, 255, 127)
  love.graphics.setLineWidth(3 / 8)
  love.graphics.line(self.vertices)

  love.graphics.setColor(127, 255, 255, 191)
  love.graphics.setLineWidth(2 / 8)
  love.graphics.line(self.vertices)

  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setLineWidth(1 / 8)
  love.graphics.line(self.vertices)

  love.graphics.setBlendMode("alpha")
end

return Lightning
