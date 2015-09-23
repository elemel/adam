local CharacterStruggleAnimation = require "CharacterStruggleAnimation"
local common = require "common"

local CharacterStruggleState = {}
CharacterStruggleState.__index = CharacterStruggleState

function CharacterStruggleState.new(args)
  local state = {}
  setmetatable(state, CharacterStruggleState)

  state.character = args.character

  state.character.physics.topFixture:setSensor(true)
  state.character.physics.bottomFixture:setSensor(true)

  state.character.lowerAnimation = CharacterStruggleAnimation.new({character = state.character})

  return state
end

function CharacterStruggleState:destroy()
  self.character.lowerAnimation = nil
end

return CharacterStruggleState
