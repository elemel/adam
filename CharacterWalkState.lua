local CharacterRunAnimation = require "CharacterRunAnimation"
local common = require "common"

local CharacterWalkState = {}
CharacterWalkState.__index = CharacterWalkState

function CharacterWalkState.new(args)
  local state = {}
  setmetatable(state, CharacterWalkState)

  state.character = args.character

  state.character.lowerAnimation = CharacterRunAnimation.new({character = state.character})

  game.updates.physics[state] = CharacterWalkState.update

  return state
end

function CharacterWalkState:destroy()
  game.updates.physics[self] = nil

  self.character.lowerAnimation = nil
end

function CharacterWalkState:update(dt)
  local inputX = (self.character.rightInput and 1 or 0) - (self.character.leftInput and 1 or 0)

  if not self.character.ground then
    self.character:setLowerState("fall")
    return
  end

  if self.character.jumpInput then
    self.character:setLowerState("jump")
    return
  end

  if inputX == 0 then
    self.character:setLowerState("stand")
    return
  end

  self.character.dx = self.character.dx + inputX * self.character.walkAcceleration * dt
  self.character.dx = common.clamp(self.character.dx, -self.character.maxWalkVelocity, self.character.maxWalkVelocity)
end

return CharacterWalkState
