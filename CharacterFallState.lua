local CharacterRunAnimation = require "CharacterRunAnimation"
local common = require "common"

local CharacterFallState = {}
CharacterFallState.__index = CharacterFallState

function CharacterFallState.new(args)
  local state = {}
  setmetatable(state, CharacterFallState)

  state.character = args.character

  state.character.lowerAnimation = CharacterRunAnimation.new({character = state.character})

  game.updates.control[state] = CharacterFallState.update

  return state
end

function CharacterFallState:destroy()
  game.updates.control[self] = nil

  self.character.lowerAnimation = nil
end

function CharacterFallState:update(dt)
  if self.character.physics:getFloorFixture() then
    self.character:setLowerState("land")
    return
  end

  local gravityX, gravityY = game.names.physics.world:getGravity()
  local velocityX, velocityY = self.character.physics.body:getLinearVelocity()

  velocityX = velocityX + gravityX * dt
  velocityY = velocityY + gravityY * dt

  self.character.physics.body:setLinearVelocity(velocityX, velocityY)
end

return CharacterFallState
