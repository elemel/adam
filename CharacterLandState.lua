local CharacterRunAnimation = require "CharacterRunAnimation"
local common = require "common"

local CharacterLandState = {}
CharacterLandState.__index = CharacterLandState

function CharacterLandState.new(args)
  local state = {}
  setmetatable(state, CharacterLandState)

  state.character = args.character

  state.character.lowerAnimation = CharacterRunAnimation.new({character = state.character})

  game.updates.physics[state] = CharacterLandState.update

  return state
end

function CharacterLandState:destroy()
  game.updates.physics[self] = nil

  self.character.lowerAnimation = nil
end

function CharacterLandState:update(dt)
  self.character.dy = 0
  game.sounds.land:clone():play()

  self.character:setLowerState("stand")
end

return CharacterLandState
