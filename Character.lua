local CharacterFallState = require "CharacterFallState"
local CharacterGrabState = require "CharacterGrabState"
local CharacterHoldState = require "CharacterHoldState"
local CharacterIdleState = require "CharacterIdleState"
local CharacterJumpState = require "CharacterJumpState"
local CharacterLandState = require "CharacterLandState"
local CharacterPhysics = require "CharacterPhysics"
local CharacterStandState = require "CharacterStandState"
local CharacterSkeleton = require "CharacterSkeleton"
local CharacterSkin = require "CharacterSkin"
local CharacterStruggleState = require "CharacterStruggleState"
local CharacterThrowState = require "CharacterThrowState"
local CharacterWalkState = require "CharacterWalkState"
local common = require "common"

local Character = {}
Character.__index = Character

function Character.new(args)
  local physics = game.names.physics
  local character = {}
  setmetatable(character, Character)

  args = args or {}

  local x = args.x or 0
  local y = args.y or 0

  character.name = args.name
  character.tags = args.tags or {}

  character.width = args.width or 1
  character.height = args.height or 2

  character.direction = 1

  character.walkAcceleration = args.walkAcceleration or 12
  character.maxWalkVelocity = args.maxWalkVelocity or 4
  character.jumpVelocity = 8
  character.maxFallVelocity = 10
  character.maxGrabDistance = 2

  character.throwVelocity = 8

  character.upInput = false
  character.leftInput = false
  character.downInput = false
  character.rightInput = false

  character.jumpInput = false
  character.attackInput = false

  character.oldAttackInput = false

  character.targetX = 0
  character.targetY = 0

  character.color = args.color or {255, 255, 255, 255}

  character.aiDelay = 0
  character.thrown = false

  character.skeleton = CharacterSkeleton.new({height = character.height})
  character.skin = CharacterSkin.new({skeleton = character.skeleton})

  character.physics = CharacterPhysics.new({
    x = x,
    y = y,

    width = character.width,
    height = character.height,
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

  character:setUpperState("idle")
  character:setLowerState("fall")

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

function Character:setUpperState(state)
  if self.upperState then
    self.upperState:destroy()
    self.upperState = nil
  end

  if state == "grab" then
    self.upperState = CharacterGrabState.new({character = self})
  elseif state == "hold" then
    self.upperState = CharacterHoldState.new({character = self})
  elseif state == "idle" then
    self.upperState = CharacterIdleState.new({character = self})
  elseif state == "throw" then
    self.upperState = CharacterThrowState.new({character = self})
  end
end

function Character:setLowerState(state)
  if self.lowerState then
    self.lowerState:destroy()
    self.lowerState = nil
  end

  if state == "fall" then
    self.lowerState = CharacterFallState.new({character = self})
  elseif state == "jump" then
    self.lowerState = CharacterJumpState.new({character = self})
  elseif state == "land" then
    self.lowerState = CharacterLandState.new({character = self})
  elseif state == "stand" then
    self.lowerState = CharacterStandState.new({character = self})
  elseif state == "struggle" then
    self.lowerState = CharacterStruggleState.new({character = self})
  elseif state == "walk" then
    self.lowerState = CharacterWalkState.new({character = self})
  end
end

function Character:update(dt)
  local inputX = (self.rightInput and 1 or 0) - (self.leftInput and 1 or 0)

  if self.captive then
    self.direction = common.sign(self.targetX - self.x)
  else
    if inputX ~= 0 then
      self.direction = inputX
    end
  end

  if self.lowerState == "spinning" then
    if self.thrown then
      local function squaredDistance(villager)
        return common.squaredDistance(self.x, self.y, villager.x, villager.y)
      end

      local villagers = common.filter(common.keys(game.tags.villager),
        function(villager)
          return (villager.lowerState ~= "grabbed" and
            villager.lowerState ~= "spinning" and
            squaredDistance(villager) < self.width ^ 2)
        end)

      if #villagers >= 1 then
        local villager = villagers[love.math.random(1, #villagers)]
        villager.dx = villager.dx + 0.25 * self.dx
        villager.dAngle = -math.pi * (2 * love.math.random(0, 1) - 1) * (1 + love.math.random())

        self.thrown = false
        self.dx = self.dx - 0.25 * self.dx

        game.sounds.collide:clone():play()
      end
    end

    self.dy = math.min(self.dy, self.maxFallVelocity)
    self.angle = self.angle + self.dAngle * dt
  end
end

function Character:updateAnimation(dt)
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

  local x, y = self.physics.body:getPosition()
  local angle = self.physics.body:getAngle()

  self.skeleton.bones.back:set(
    x,
    y - 0.15 * self.height / 1.8,
    angle,
    self.direction)

  if self.lowerAnimation then
    self.lowerAnimation:update(dt)
  end

  if self.upperAnimation then
    self.upperAnimation:update(dt)
  end
end

function Character:draw()
  love.graphics.setColor(self.color)
  self.skin:draw()

  -- love.graphics.rectangle("line", self.x - 0.5 * self.width, self.y - 0.5 * self.height, self.width, self.height)
end

return Character
