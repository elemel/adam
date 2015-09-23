local CharacterHoldAnimation = require "CharacterHoldAnimation"
local common = require "common"

local CharacterHoldState = {}
CharacterHoldState.__index = CharacterHoldState

function CharacterHoldState.new(args)
  local state = {}
  setmetatable(state, CharacterHoldState)

  state.character = args.character

  state.character.upperAnimation = CharacterHoldAnimation.new({character = state.character})

  game.updates.control[state] = CharacterHoldState.update
  game.updates.collision[state] = CharacterHoldState.updateCollision

  return state
end

function CharacterHoldState:destroy()
  game.updates.collision[self] = nil
  game.updates.control[self] = nil

  self.character.upperAnimation = nil
end

function CharacterHoldState:update(dt)
  if self.character.attackInput and not self.character.oldAttackInput then
    self.character:setUpperState("throw")
    return
  end
end

function CharacterHoldState:updateCollision(dt)
  local inputY = (self.character.downInput and 1 or 0) - (self.character.upInput and 1 or 0)

  local x, y = self.character.physics.body:getPosition()

  local scale = self.character.skeleton.height / 1.8
  local angle = self.character.direction * (0.25 * math.pi * inputY - 1.25 * math.pi)
  local armAngle = (0.25 * math.pi * inputY - 0.25 * math.pi)
  local armLength = scale * 0.9

  x = x + self.character.direction * armLength * math.cos(armAngle)
  y = y - scale * 0.3 + armLength * math.sin(armAngle)

  if inputY == 1 then
    y = y + scale * 0.45
  end

  self.character.captive.physics.body:setPosition(x, y)
  self.character.captive.physics.body:setAngle(angle)
  self.character.captive.direction = -self.character.direction
end

return CharacterHoldState
