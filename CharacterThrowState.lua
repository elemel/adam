local CharacterHoldAnimation = require "CharacterHoldAnimation"
local common = require "common"

local CharacterThrowState = {}
CharacterThrowState.__index = CharacterThrowState

function CharacterThrowState.new(args)
  local state = {}
  setmetatable(state, CharacterThrowState)

  state.character = args.character

  state.character.upperAnimation = CharacterHoldAnimation.new({character = state.character})

  game.updates.physics[state] = CharacterThrowState.update

  return state
end

function CharacterThrowState:destroy()
  game.updates.physics[self] = nil

  self.character.upperAnimation = nil
end

function CharacterThrowState:update(dt)
  local inputY = (self.character.downInput and 1 or 0) - (self.character.upInput and 1 or 0)

  local angle = inputY * 0.25 * math.pi - 0.25 * math.pi

  game.sounds.throw:clone():play()

  local velocityX, velocityY = self.character.physics.body:getLinearVelocity()
  velocityX = velocityX + self.character.throwVelocity * math.cos(angle)
  velocityY = velocityY + self.character.throwVelocity * math.sin(angle)

  self.character.captive.physics.body:setLinearVelocity(velocityX, velocityY)
  self.character.captive.physics.body:setAngularVelocity(-math.pi * self.character.direction * (1 + love.math.random()))

  game.sceneGraph:setParent(self.character.captive.skeleton.bones.back.id, nil)
  self.character.captive.physics.body:setPosition(self.character.physics.body:getPosition())
  self.character.captive.thrown = true
  self.character.captive.captor = nil

  self.character.captive:setLowerState("fall")

  self.character.captive = nil

  self.character:setUpperState("idle")
end

return CharacterThrowState
