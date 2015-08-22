local common = require "common"

local Character = {}
Character.__index = Character

function Character.new(args)
  local character = {}
  setmetatable(character, Character)

  args = args or {}

  character.name = args.name
  character.tags = args.tags or {}

  character.x = args.x or 0
  character.y = args.y or 0

  character.dx = 0
  character.dy = 0

  character.height = 2
  character.width = 1

  character.state = "stand"

  character.walkAcceleration = 16
  character.stopAcceleration = 16
  character.maxWalkVelocity = 4
  character.jumpVelocity = 8
  character.fallAcceleration = 10
  character.maxFallVelocity = 10

  character.upInput = false
  character.leftInput = false
  character.downInput = false
  character.rightInput = false

  character.jumpInput = false
  character.throwInput = false

  character.color = args.color or {255, 255, 255, 255}

  game.updates.physics[character] = Character.update
  game.draws.scene[character] = Character.draw

  for i, tag in pairs(character.tags) do
    game.tags[tag][character] = true
  end

  if character.name then
    game.names[character.name] = character
  end

  return character
end

function Character:destroy()
  if character.name then
    game.names[character.name] = nil
  end

  for i, tag in pairs(self.tags) do
    game.tags[tag][self] = nil
  end

  game.draws.scene[character] = nil
  game.updates.physics[character] = nil

  self.body:destroy()
end

function Character:update(dt)
  local inputX = (self.rightInput and 1 or 0) - (self.leftInput and 1 or 0)

  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt

  local ground = false

  local terrain = game.names.terrain

  for block, _ in pairs(terrain.blocks) do
    if self.x - 0.5 * self.width < block.x + 0.5 * block.width and
        self.x + 0.5 * self.width > block.x - 0.5 * block.width and
        self.y + 0.5 * self.height + 0.001 > block.y - 0.5 * block.height then
      self.dy = 0
      self.y = block.y - 0.5 * block.height - 0.5 * self.height
      ground = true
    end
  end

  if self.state == "fall" then
    if ground then
      self.state = "stand"
      return
    end

    self.dy = self.dy + self.fallAcceleration * dt
    self.dy = math.min(self.dy, self.maxFallVelocity)
  end

  if self.state == "jump" then
    self.dy = -self.jumpVelocity
    self.state = "fall"
    return
  end

  if self.state == "stand" then
    if not ground then
      self.state = "fall"
      return
    end

    if self.jumpInput then
      self.state = "jump"
      return
    end

    if inputX ~= 0 then
      self.state = "walk"
      return
    end

    if math.abs(self.dx) < self.stopAcceleration * dt then
      self.dx = 0
    else
      self.dx = self.dx - common.sign(self.dx) * self.stopAcceleration * dt
    end
  end

  if self.state == "walk" then
    if not ground then
      self.state = "fall"
      return
    end

    if self.jumpInput then
      self.state = "jump"
      return
    end

    if inputX == 0 then
      self.state = "stand"
      return
    end

    self.dx = self.dx + inputX * self.walkAcceleration * dt
    self.dx = common.clamp(self.dx, -self.maxWalkVelocity, self.maxWalkVelocity)
  end
end

function Character:draw()
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", self.x - 0.5 * self.width, self.y - 0.5 * self.height, self.width, self.height)
end

return Character