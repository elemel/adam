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
  local scale = self.character.skeleton.height / 1.8
  local angle = math.atan2(self.character.targetY - self.character.y + scale * 0.6,
    self.character.direction * (self.character.targetX - self.character.x))

  game.sounds.throw:clone():play()

  self.character.captive.dx = self.character.dx + self.character.direction * self.character.throwVelocity * math.cos(angle)
  self.character.captive.dy = self.character.dy + self.character.throwVelocity * math.sin(angle)
  self.character.captive.dAngle = -math.pi * self.character.direction * (1 + love.math.random())

  game.sceneGraph:setParent(self.character.captive.skeleton.bones.back.id, nil)
  self.character.captive.x = self.character.x
  self.character.captive.y = self.character.y
  self.character.captive.thrown = true
  self.character.captive.captor = nil

  self.character.captive:setLowerState("fall")

  self.character.captive = nil

  self.character:setUpperState("idle")
end

return CharacterThrowState
