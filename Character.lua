local Animation = require "Animation"
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

  character.direction = 1

  character.upperState = "standing"
  character.lowerState = "standing"

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

  character.skin = args.skin or game.skins.adam
  character.color = args.color or {255, 255, 255, 255}

  character.lowerAnimationState = "standing"

  character.lowerAnimation = Animation.new({
    images = character.skin.standing.lower,
  })

  character.upperAnimationState = "standing"

  character.upperAnimation = Animation.new({
    images = character.skin.standing.upper,
  })

  game.updates.physics[character] = Character.update
  game.updates.animation[character] = Character.updateAnimation
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
  game.updates.animation[character] = nil
  game.updates.physics[character] = nil

  self.body:destroy()
end

function Character:update(dt)
  local inputX = (self.rightInput and 1 or 0) - (self.leftInput and 1 or 0)

  if inputX ~= 0 then
    self.direction = inputX
  end

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

  if self.lowerState == "falling" then
    if ground then
      self.lowerState = "standing"
      return
    end

    self.dy = self.dy + self.fallAcceleration * dt
    self.dy = math.min(self.dy, self.maxFallVelocity)
  end

  if self.lowerState == "jumping" then
    self.dy = -self.jumpVelocity
    self.lowerState = "falling"
    self.upperState = "falling"
    return
  end

  if self.lowerState == "standing" then
    if not ground then
      self.lowerState = "falling"
      return
    end

    if self.jumpInput then
      self.lowerState = "jumping"
      return
    end

    if inputX ~= 0 then
      self.lowerState = "walking"
      return
    end

    if math.abs(self.dx) < self.stopAcceleration * dt then
      self.dx = 0
    else
      self.dx = self.dx - common.sign(self.dx) * self.stopAcceleration * dt
    end
  end

  if self.lowerState == "walking" then
    if not ground then
      self.lowerState = "falling"
      return
    end

    if self.jumpInput then
      self.lowerState = "jumping"
      return
    end

    if inputX == 0 then
      self.lowerState = "standing"
      return
    end

    self.dx = self.dx + inputX * self.walkAcceleration * dt
    self.dx = common.clamp(self.dx, -self.maxWalkVelocity, self.maxWalkVelocity)
  end
end

function Character:updateAnimation(dt)
  if self.lowerAnimationState ~= self.lowerState then
    self.lowerAnimation = Animation.new({
      images = self.skin[self.lowerState].lower,
    })

    self.lowerAnimationState = self.lowerState
  end

  if self.upperAnimationState ~= self.upperState then
    self.upperAnimation = Animation.new({
      images = self.skin[self.upperState].upper,
    })

    self.upperAnimationState = self.upperState
  end

  self.lowerAnimation:update(dt)
  self.upperAnimation:update(dt)

  if self.fire then
    self.fire.x = self.x
    self.fire.y = self.y - 0.5 * self.height - 0.5 * self.width
  end
end

function Character:draw()
  love.graphics.setColor(self.color)

  local lowerImage = self.lowerAnimation.images[self.lowerAnimation.index]
  local lowerWidth, lowerHeight = lowerImage:getDimensions()
  love.graphics.draw(lowerImage, self.x, self.y, 0, self.direction / 8, 1 / 8, 0.5 * lowerWidth, 0.5 * lowerHeight)

  local upperImage = self.upperAnimation.images[self.upperAnimation.index]
  local upperWidth, upperHeight = upperImage:getDimensions()
  love.graphics.draw(upperImage, self.x, self.y, 0, self.direction / 8, 1 / 8, 0.5 * upperWidth, 0.5 * upperHeight)
end

return Character