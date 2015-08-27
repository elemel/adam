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

  lightning.maxLength = args.maxLength or 1
  lightning.maxSlope = args.maxSlope or 0.75

  lightning.minTtl = 1 / 8
  lightning.maxTtl = 1 / 4

  lightning.vertices = {lightning.x1, lightning.y1, lightning.x2, lightning.y2}
  lightning.ttls = {}

  lightning.minResetDelay = 1
  lightning.maxResetDelay = 2

  lightning.resetDelay = common.mix(lightning.minResetDelay, lightning.maxResetDelay, love.math.random())

  game.updates.physics[lightning] = Lightning.update
  game.draws.particles[lightning] = Lightning.draw

  return lightning
end

function Lightning:destroy()
  game.draws.particles[self] = nil
  game.updates.physics[self] = nil
end

function Lightning:reset()
  self.vertices = {self.x1, self.y1, self.x2, self.y2}
  self.ttls = {}
end

function Lightning:update(dt)
  local adam = game.names.adam

  if adam then
    self.x1 = adam.x

    self.x2 = adam.x - 0.25 * adam.direction
    self.y2 = adam.y - 0.75
  end

  self.resetDelay = self.resetDelay - dt

  if self.resetDelay < 0 then
    self:reset()
    self.resetDelay = common.mix(self.minResetDelay, self.maxResetDelay, love.math.random())
  else
    self.vertices[1] = self.x1
    self.vertices[2] = self.y1

    self.vertices[#self.vertices - 1] = self.x2
    self.vertices[#self.vertices] = self.y2
  end

  local length = math.sqrt((self.x2 - self.x1) ^ 2 + (self.y2 - self.y1) ^ 2)

  local tangentX = (self.x2 - self.x1) / length
  local tangentY = (self.y2 - self.y1) / length

  local normalX, normalY = -tangentY, tangentX

  local i = 1

  while i <= #self.ttls do
    local x = self.vertices[2 * i + 1]
    local y = self.vertices[2 * i + 2]

    local tangentOffset = common.dot(x - self.x1, y - self.y1, tangentX, tangentY)
    local normalOffset = common.dot(x - self.x1, y - self.y1, normalX, normalY)

    if math.abs(normalOffset) > 0.25 * length then
      self:reset()
      break
    end

    self.ttls[i] = self.ttls[i] - dt

    if self.ttls[i] < 0 or tangentOffset < 0 or tangentOffset > length then
      table.remove(self.vertices, 2 * i + 1)
      table.remove(self.vertices, 2 * i + 1)

      table.remove(self.ttls, i)
    else
      i = i + 1
    end
  end

  local j = 1

  while j <= #self.ttls + 1 do
    local x1 = self.vertices[2 * j - 1]
    local y1 = self.vertices[2 * j]

    local x2 = self.vertices[2 * j + 1]
    local y2 = self.vertices[2 * j + 2]

    if (x2 - x1) ^ 2 + (y2 - y1) ^ 2 > self.maxLength ^ 2 then
      local length = math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)

      local tangentX = (x2 - x1) / length
      local tangentY = (y2 - y1) / length

      local normalX, normalY = -tangentY, tangentX

      local originFraction = 0.25 + 0.5 * love.math.random()

      local originX = common.mix(x1, x2, originFraction)
      local originY = common.mix(y1, y2, originFraction)

      local maxOffset = self.maxSlope * math.min(originFraction, 1 - originFraction) * length
      local offsetScale = 2 * love.math.random() - 1
      local offset = offsetScale * maxOffset

      local offsetX = offset * normalX
      local offsetY = offset * normalY

      local x = originX + offsetX
      local y = originY + offsetY

      local ttl = common.mix(self.minTtl, self.maxTtl, love.math.random())

      table.insert(self.vertices, 2 * j + 1, x)
      table.insert(self.vertices, 2 * j + 2, y)

      table.insert(self.ttls, j, ttl)
    else
      j = j + 1
    end
  end
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
