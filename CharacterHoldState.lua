local CharacterHoldAnimation = require "CharacterHoldAnimation"
local common = require "common"

local CharacterHoldState = {}
CharacterHoldState.__index = CharacterHoldState

function CharacterHoldState.new(args)
  local state = {}
  setmetatable(state, CharacterHoldState)

  state.character = args.character

  state.character.upperAnimation = CharacterHoldAnimation.new({character = state.character})

  game.updates.physics[state] = CharacterHoldState.update

  return state
end

function CharacterHoldState:destroy()
  game.updates.physics[self] = nil

  self.character.upperAnimation = nil
end

function CharacterHoldState:update(dt)
  if self.character.attackInput and not self.character.oldAttackInput then
    self.character:setUpperState("throw")
    return
  end
end

return CharacterHoldState
