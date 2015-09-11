local CharacterStruggleAnimation = require "CharacterStruggleAnimation"
local common = require "common"

local CharacterStruggleState = {}
CharacterStruggleState.__index = CharacterStruggleState

function CharacterStruggleState.new(args)
  local state = {}
  setmetatable(state, CharacterStruggleState)

  state.character = args.character

  state.character.lowerAnimation = CharacterStruggleAnimation.new({character = state.character})

  game.updates.physics[state] = CharacterStruggleState.update

  return state
end

function CharacterStruggleState:destroy()
  game.updates.physics[self] = nil

  self.character.lowerAnimation = nil
end

function CharacterStruggleState:update(dt)
  self.character.x = 0
  self.character.y = 0
  self.character.dx = 0
  self.character.dy = 0
end

return CharacterStruggleState
