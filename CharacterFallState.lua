local CharacterRunAnimation = require "CharacterRunAnimation"
local common = require "common"

local CharacterFallState = {}
CharacterFallState.__index = CharacterFallState

function CharacterFallState.new(args)
  local state = {}
  setmetatable(state, CharacterFallState)

  state.character = args.character

  state.character.lowerAnimation = CharacterRunAnimation.new({character = state.character})

  game.updates.collision[state] = CharacterFallState.update

  return state
end

function CharacterFallState:destroy()
  game.updates.collision[self] = nil

  self.character.lowerAnimation = nil
end

function CharacterFallState:update(dt)
  self.character.dy = self.character.dy + self.character.fallAcceleration * dt
  self.character.dy = math.min(self.character.dy, self.character.maxFallVelocity)

  self.character.x = self.character.x + self.character.dx * dt
  self.character.y = self.character.y + self.character.dy * dt

  self.character:updateFloorContact()
  self.character:applyFloorConstraint()

  if self.character.contacts.floor.touching then
    self.character:setLowerState("land")
    return
  end
end

return CharacterFallState
