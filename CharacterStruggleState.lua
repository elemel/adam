local CharacterStruggleAnimation = require "CharacterStruggleAnimation"
local common = require "common"

local CharacterStruggleState = {}
CharacterStruggleState.__index = CharacterStruggleState

function CharacterStruggleState.new(args)
  local state = {}
  setmetatable(state, CharacterStruggleState)

  state.character = args.character

  state.character.animation = CharacterStruggleAnimation.new({character = state.character})

  game.updates.physics[state] = CharacterStruggleState.update

  return state
end

function CharacterStruggleState:destroy()
  game.updates.physics[self] = nil

  self.character.animation = nil
end

function CharacterStruggleState:update(dt)
end

return CharacterStruggleState
