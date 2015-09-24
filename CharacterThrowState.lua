local CharacterHoldAnimation = require "CharacterHoldAnimation"
local common = require "common"

local CharacterThrowState = {}
CharacterThrowState.__index = CharacterThrowState

function CharacterThrowState.new(args)
  local state = {}
  setmetatable(state, CharacterThrowState)

  state.character = args.character

  state.character.upperAnimation = CharacterHoldAnimation.new({character = state.character})

  game.updates.control[state] = CharacterThrowState.update

  return state
end

function CharacterThrowState:destroy()
  game.updates.control[self] = nil

  self.character.upperAnimation = nil
end

function CharacterThrowState:update(dt)
  local inputY = (self.character.downInput and 1 or 0) - (self.character.upInput and 1 or 0)

  game.sounds.throw:clone():play()

  local throwVelocity = self.character.throwVelocity * math.sqrt(0.5 * (2 - inputY))
  local throwAngle = -0.25 * math.pi

  local velocityX, velocityY = self.character.physics.body:getLinearVelocity()
  velocityX = velocityX + self.character.direction * throwVelocity * math.cos(throwAngle)
  velocityY = velocityY + throwVelocity * math.sin(throwAngle)

  self.character.captive.physics.body:setLinearVelocity(velocityX, velocityY)
  self.character.captive.physics.body:setAngularVelocity(-math.pi * self.character.direction * (1 + love.math.random()))

  self.character.captive.thrown = true
  self.character.captive.captor = nil

  self.character.captive:setLowerState("fall")

  self.character.captive = nil

  self.character:setUpperState("idle")
end

return CharacterThrowState
