local common = require "common"

local CharacterIdleState = {}
CharacterIdleState.__index = CharacterIdleState

function CharacterIdleState.new(args)
  local state = {}
  setmetatable(state, CharacterIdleState)

  state.character = args.character

  game.updates.physics[state] = CharacterIdleState.update

  return state
end

function CharacterIdleState:destroy()
  game.updates.physics[self] = nil
end

function CharacterIdleState:update(dt)
  if self.character.attackInput and not self.character.oldAttackInput then
    self.character:setUpperState("grab")
    return
  end
end

return CharacterIdleState
