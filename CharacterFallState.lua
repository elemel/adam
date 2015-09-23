local CharacterRunAnimation = require "CharacterRunAnimation"
local common = require "common"

local CharacterFallState = {}
CharacterFallState.__index = CharacterFallState

function CharacterFallState.new(args)
  local state = {}
  setmetatable(state, CharacterFallState)

  state.character = args.character

  state.character.lowerAnimation = CharacterRunAnimation.new({character = state.character})

  state.delay = 0.25

  game.updates.control[state] = CharacterFallState.update

  return state
end

function CharacterFallState:destroy()
  game.updates.control[self] = nil

  self.character.lowerAnimation = nil
end

function CharacterFallState:update(dt)
  self.delay = self.delay - dt

  local inputX = (self.character.rightInput and 1 or 0) - (self.character.leftInput and 1 or 0)

  if inputX ~= 0 then
    self.character.direction = inputX
  end

  if self.delay < 0 and self.character.physics:getFloorFixture() then
    self.character:setLowerState("land")
    return
  end

  local gravityX, gravityY = game.names.physics.world:getGravity()
  local velocityX, velocityY = self.character.physics.body:getLinearVelocity()

  velocityX = velocityX + gravityX * dt
  velocityY = velocityY + gravityY * dt

  if inputX * velocityX < 0 then
    velocityX = velocityX + inputX * self.character.driftAcceleration * dt
  elseif math.abs(velocityX) < self.character.maxDriftVelocity then
    velocityX = velocityX + inputX * math.min(self.character.driftAcceleration * dt, self.character.maxDriftVelocity - math.abs(velocityX))
  end

  self.character.physics.body:setLinearVelocity(velocityX, velocityY)
end

return CharacterFallState
