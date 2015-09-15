local CharacterStruggleAnimation = require "CharacterStruggleAnimation"
local common = require "common"

local CharacterStruggleState = {}
CharacterStruggleState.__index = CharacterStruggleState

function CharacterStruggleState.new(args)
  local state = {}
  setmetatable(state, CharacterStruggleState)

  state.character = args.character

  state.character.lowerAnimation = CharacterStruggleAnimation.new({character = state.character})

  state.character.x = 0
  state.character.y = 0
  state.character.dx = 0
  state.character.dy = 0

  game.updates.physics[state] = CharacterStruggleState.update

  return state
end

function CharacterStruggleState:destroy()
  game.updates.physics[self] = nil

  self.character.lowerAnimation = nil
end

function CharacterStruggleState:update(dt)
end

return CharacterStruggleState
