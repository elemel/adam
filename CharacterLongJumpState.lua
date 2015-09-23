local CharacterRunAnimation = require "CharacterRunAnimation"
local common = require "common"

local CharacterLongJumpState = {}
CharacterLongJumpState.__index = CharacterLongJumpState

function CharacterLongJumpState.new(args)
  local state = {}
  setmetatable(state, CharacterLongJumpState)

  state.character = args.character

  state.character.lowerAnimation = CharacterRunAnimation.new({character = state.character})

  game.updates.physics[state] = CharacterLongJumpState.update

  return state
end

function CharacterLongJumpState:destroy()
  game.updates.physics[self] = nil

  self.character.lowerAnimation = nil
end

function CharacterLongJumpState:update(dt)
  game.sounds.jump:clone():play()

  local velocityX, velocityY = self.character.physics.body:getLinearVelocity()

  velocityX = velocityX + self.character.direction * math.cos(self.character.longJumpAngle) * self.character.longJumpVelocity
  velocityY = velocityY - math.sin(self.character.longJumpAngle) * self.character.longJumpVelocity

  self.character.physics.body:setLinearVelocity(velocityX, velocityY)

  self.character:setLowerState("fall")
end

return CharacterLongJumpState
