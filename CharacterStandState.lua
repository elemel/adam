local CharacterStandAnimation = require "CharacterStandAnimation"
local common = require "common"

local CharacterStandState = {}
CharacterStandState.__index = CharacterStandState

function CharacterStandState.new(args)
  local state = {}
  setmetatable(state, CharacterStandState)

  state.character = args.character

  state.character.lowerAnimation = CharacterStandAnimation.new({character = state.character})

  game.updates.physics[state] = CharacterStandState.update

  return state
end

function CharacterStandState:destroy()
  game.updates.physics[self] = nil

  self.character.lowerAnimation = nil
end

function CharacterStandState:update(dt)
  local inputX = (self.character.rightInput and 1 or 0) - (self.character.leftInput and 1 or 0)

  if not self.character.ground then
    self.character:setLowerState("fall")
    return
  end

  if self.character.jumpInput then
    self.character:setLowerState("jump")
    return
  end

  if inputX ~= 0 then
    self.character:setLowerState("walk")
    return
  end

  if math.abs(self.character.dx) < self.character.walkAcceleration * dt then
    self.character.dx = 0
  else
    self.character.dx = self.character.dx - common.sign(self.character.dx) * self.character.walkAcceleration * dt
  end
end

return CharacterStandState
