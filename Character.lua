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

  character.angle = args.angle or 0

  character.dx = 0
  character.dy = 0

  character.dAngle = 0

  character.height = 2
  character.width = 1

  character.direction = 1

  character.lowerState = "standing"
  character.upperState = nil

  character.walkAcceleration = args.walkAcceleration or 16
  character.maxWalkVelocity = args.maxWalkVelocity or 4
  character.jumpVelocity = 8
  character.fallAcceleration = 10
  character.maxFallVelocity = 10
  character.maxGrabDistance = 2
  character.throwVelocityX = 4
  character.throwVelocityY = 2

  character.upInput = false
  character.leftInput = false
  character.downInput = false
  character.rightInput = false

  character.jumpInput = false
  character.throwInput = false

  character.oldThrowInput = false

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

  if self.lowerState ~= "spinning" then
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

    if math.abs(self.dx) < self.walkAcceleration * dt then
      self.dx = 0
    else
      self.dx = self.dx - common.sign(self.dx) * self.walkAcceleration * dt
    end
  end

  if self.lowerState == "spinning" then
    self.dy = self.dy + self.fallAcceleration * dt
    self.dy = math.min(self.dy, self.maxFallVelocity)
    self.angle = self.angle + self.dAngle * dt
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

  if self.upperState == nil then
    if self.throwInput and not self.oldThrowInput then
      if self.captive then
        self.upperState = "throwing"
        return
      else
        self.upperState = "grabbing"
        return
      end
    end
  end

  if self.upperState == "grabbing" then
    local function squaredDistance(villager)
      return common.squaredDistance(self.x, self.y, villager.x, villager.y)
    end

    local villagers = common.filter(common.keys(game.tags.villager),
      function(villager)
        return (villager.lowerState ~= "grabbed" and
          villager.lowerState ~= "spinning" and
          squaredDistance(villager) < self.maxGrabDistance ^ 2)
      end)

    if #villagers >= 1 then
      table.sort(villagers,
        function(a, b) return squaredDistance(a) < squaredDistance(b) end)

      self.captive = villagers[1]
      self.captive.lowerState = "grabbed"
      self.captive.captor = self
      self.upperState = "holding"
      return
    end

    self.upperState = nil
    return
  end

  if self.upperState == "holding" then
    if self.throwInput and not self.oldThrowInput then
      self.upperState = "throwing"
      return
    end
  end

  if self.upperState == "throwing" then
    self.captive.dx = self.dx + self.direction * self.throwVelocityX
    self.captive.dy = self.dy - self.throwVelocityY
    self.captive.dAngle = -math.pi * self.direction

    self.captive.lowerState = "spinning"
    self.captive.captor = nil
    self.captive = nil

    self.upperState = nil
    return
  end
end

function Character:updateAnimation(dt)
  if self.lowerAnimationState ~= self.lowerState then
    self.lowerAnimation = Animation.new({
      images = self.skin[self.lowerState].lower,
    })

    self.lowerAnimationState = self.lowerState
  end

  local upperState = self.upperState or self.lowerState

  if self.upperAnimationState ~= upperState then
    self.upperAnimation = Animation.new({
      images = self.skin[upperState].upper,
    })

    self.upperAnimationState = upperState
  end

  self.lowerAnimation:update(dt)
  self.upperAnimation:update(dt)

  if self.fire then
    if self.captor or self.lowerState == "spinning" then
      self.fire.particles:setEmissionRate(64)
      self.fire.x = self.x
      self.fire.y = self.y
    else
      self.fire.particles:setEmissionRate(32)
      self.fire.x = self.x + self.direction * self.width
      self.fire.y = self.y - 0.25 * self.height
    end
  end

  if self.captive then
    self.captive.x = self.x
    self.captive.y = self.y - 0.5 * self.height - 0.5 * self.captive.width

    if self.direction == 1 then
      self.captive.direction = 1
      self.captive.angle = -0.5 * math.pi
    else
      self.captive.direction = -1
      self.captive.angle = 0.5 * math.pi
    end
  end
end

function Character:draw()
  love.graphics.setColor(self.color)

  local grabber

  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(self.angle)

  local lowerImage = self.lowerAnimation.images[self.lowerAnimation.index]
  local lowerWidth, lowerHeight = lowerImage:getDimensions()
  love.graphics.draw(lowerImage, 0, 0, 0, self.direction / 8, 1 / 8, 0.5 * lowerWidth, 0.5 * lowerHeight)

  local upperImage = self.upperAnimation.images[self.upperAnimation.index]
  local upperWidth, upperHeight = upperImage:getDimensions()
  love.graphics.draw(upperImage, 0, 0, 0, self.direction / 8, 1 / 8, 0.5 * upperWidth, 0.5 * upperHeight)

  love.graphics.pop()
end

return Character