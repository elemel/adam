local CharacterRunAnimation = require "CharacterRunAnimation"
local common = require "common"

local CharacterJumpState = {}
CharacterJumpState.__index = CharacterJumpState

function CharacterJumpState.new(args)
  local state = {}
  setmetatable(state, CharacterJumpState)

  state.character = args.character

  state.character.lowerAnimation = CharacterRunAnimation.new({character = state.character})

  game.updates.physics[state] = CharacterJumpState.update

  return state
end

function CharacterJumpState:destroy()
  game.updates.physics[self] = nil

  self.character.lowerAnimation = nil
end

function CharacterJumpState:update(dt)
  local velocityX, velocityY = self.character.physics.body:getLinearVelocity()
  self.character.physics.body:setLinearVelocity(velocityX, -self.character.jumpVelocity)
  game.sounds.jump:clone():play()

  self.character:setLowerState("fall")
end

return CharacterJumpState
