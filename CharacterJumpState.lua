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
  game.sounds.jump:clone():play()

  local inputY = (self.character.downInput and 1 or 0) - (self.character.upInput and 1 or 0)

  local velocityX, velocityY = self.character.physics.body:getLinearVelocity()

  velocityY = -self.character.jumpVelocity * math.sqrt(0.5 * (2 - inputY))
  -- velocityX, velocityY = common.normalize(velocityX, velocityY)

  -- velocityX = self.character.jumpVelocity * velocityX
  -- velocityY = self.character.jumpVelocity * velocityY

  self.character.physics.body:setLinearVelocity(velocityX, velocityY)

  self.character:setLowerState("fall")
end

return CharacterJumpState
