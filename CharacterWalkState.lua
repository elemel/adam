local CharacterRunAnimation = require "CharacterRunAnimation"
local common = require "common"

local CharacterWalkState = {}
CharacterWalkState.__index = CharacterWalkState

function CharacterWalkState.new(args)
  local state = {}
  setmetatable(state, CharacterWalkState)

  state.character = args.character

  state.character.lowerAnimation = CharacterRunAnimation.new({character = state.character})

  game.updates.physics[state] = CharacterWalkState.update

  return state
end

function CharacterWalkState:destroy()
  game.updates.physics[self] = nil

  self.character.lowerAnimation = nil
end

function CharacterWalkState:update(dt)
  local inputX = (self.character.rightInput and 1 or 0) - (self.character.leftInput and 1 or 0)

  self.character:updateFloorContact()

  if not self.character.floor then
    self.character:setLowerState("fall")
    return
  end

  local floorTangentX = -self.character.floorNormalY
  local floorTangentY = self.character.floorNormalX

  self.character.dx = self.character.dx + inputX * self.character.walkAcceleration * dt * floorTangentX
  self.character.dy = self.character.dy + inputX * self.character.walkAcceleration * dt * floorTangentY

  local dx = self.character.dx - self.character.floorDx
  local dy = self.character.dy - self.character.floorDy

  local tv = common.dot(dx, dy, floorTangentX, floorTangentY)

  if math.abs(tv) > self.character.maxWalkVelocity then
    self.character.dx = self.character.dx - common.sign(tv) * (math.abs(tv) - self.character.maxWalkVelocity) * floorTangentX
    self.character.dy = self.character.dy - common.sign(tv) * (math.abs(tv) - self.character.maxWalkVelocity) * floorTangentY
  end

  self.character.x = self.character.x + self.character.dx * dt
  self.character.y = self.character.y + self.character.dy * dt

  self.character:applyFloorConstraint()

  if self.character.jumpInput then
    self.character:setLowerState("jump")
    return
  end

  if inputX == 0 then
    self.character:setLowerState("stand")
    return
  end
end

return CharacterWalkState
