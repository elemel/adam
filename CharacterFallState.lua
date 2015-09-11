local CharacterRunAnimation = require "CharacterRunAnimation"
local common = require "common"

local CharacterFallState = {}
CharacterFallState.__index = CharacterFallState

function CharacterFallState.new(args)
  local state = {}
  setmetatable(state, CharacterFallState)

  state.character = args.character

  state.character.lowerAnimation = CharacterRunAnimation.new({character = state.character})

  game.updates.physics[state] = CharacterFallState.update

  return state
end

function CharacterFallState:destroy()
  game.updates.physics[self] = nil

  self.character.lowerAnimation = nil
end

function CharacterFallState:update(dt)
  if self.character.dy > -1 and self.character.ground then
    self.character:setLowerState("land")
    return
  end

  self.character.dy = self.character.dy + self.character.fallAcceleration * dt
  self.character.dy = math.min(self.character.dy, self.character.maxFallVelocity)
end

return CharacterFallState
