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
  game.sounds.land:clone():play()

  local inputX = (self.character.rightInput and 1 or 0) - (self.character.leftInput and 1 or 0)
  local inputY = (self.character.downInput and 1 or 0) - (self.character.upInput and 1 or 0)

  if inputY == 1 then
    self.character:setLowerState("slide")
    return
  end

  if inputX ~= 0 then
    self.character:setLowerState("walk")
    return
  end

  self.character:setLowerState("stand")
end

return CharacterLandState
