local CharacterStandAnimation = require "CharacterStandAnimation"
local common = require "common"

local CharacterStandState = {}
CharacterStandState.__index = CharacterStandState

function CharacterStandState.new(args)
  local state = {}
  setmetatable(state, CharacterStandState)

  state.character = args.character

  state.character.lowerAnimation = CharacterStandAnimation.new({character = state.character})

  game.updates.collision[state] = CharacterStandState.update

  return state
end

function CharacterStandState:destroy()
  game.updates.collision[self] = nil

  self.character.lowerAnimation = nil
end

function CharacterStandState:update(dt)
  local inputX = (self.character.rightInput and 1 or 0) - (self.character.leftInput and 1 or 0)

  self.character:updateFloorContact()
  self.character:applyFloorFriction(self.character.walkAcceleration * dt)

  self.character.dy = self.character.dy + self.character.fallAcceleration * dt

  self.character.x = self.character.x + self.character.dx * dt
  self.character.y = self.character.y + self.character.dy * dt

  self.character:applyFloorConstraint()

  if not self.character.contacts.floor.touching then
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
end

return CharacterStandState
