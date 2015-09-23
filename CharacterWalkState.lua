local CharacterRunAnimation = require "CharacterRunAnimation"
local common = require "common"

local CharacterWalkState = {}
CharacterWalkState.__index = CharacterWalkState

function CharacterWalkState.new(args)
  local state = {}
  setmetatable(state, CharacterWalkState)

  state.character = args.character

  state.character.lowerAnimation = CharacterRunAnimation.new({character = state.character})

  game.updates.control[state] = CharacterWalkState.update

  return state
end

function CharacterWalkState:destroy()
  game.updates.control[self] = nil

  self.character.lowerAnimation = nil
end

function CharacterWalkState:update(dt)
  local inputX = (self.character.rightInput and 1 or 0) - (self.character.leftInput and 1 or 0)
  local inputY = (self.character.downInput and 1 or 0) - (self.character.upInput and 1 or 0)

  if inputX ~= 0 then
    self.character.direction = inputX
  end

  local floorFixture = self.character.physics:getFloorFixture()

  if not floorFixture then
    self.character:setLowerState("fall")
    return
  end

  local distance, x1, y1, x2, y2 = love.physics.getDistance(self.character.physics.bottomFixture, floorFixture)

  local x0, y0 = self.character.physics.body:getWorldPoint(self.character.physics.bottomFixture:getShape():getPoint())
  local normalX, normalY = common.normalize(x0 - x2, y0 - y2)
  local tangentX, tangentY = -normalY, normalX

  local velocityX1, velocityY1 = self.character.physics.body:getLinearVelocityFromWorldPoint(x1, y1)
  local velocityX2, velocityY2 = floorFixture:getBody():getLinearVelocityFromWorldPoint(x2, y2)

  velocityX1 = velocityX1 + inputX * self.character.walkAcceleration * dt * tangentX
  velocityY1 = velocityY1 + inputX * self.character.walkAcceleration * dt * tangentY

  local gravityX, gravityY = game.names.physics.world:getGravity()

  velocityX1 = velocityX1 + gravityX * dt
  velocityY1 = velocityY1 + gravityY * dt

  local velocity = common.dot(velocityX1 - velocityX2, velocityY1 - velocityY2, tangentX, tangentY)
  local friction = common.sign(velocity) * math.max(math.abs(velocity) - self.character.maxWalkVelocity, 0)

  velocityX1 = velocityX1 - friction * tangentX
  velocityY1 = velocityY1 - friction * tangentY

  self.character.physics.body:setLinearVelocity(velocityX1, velocityY1)

  if self.character.jumpInput and not self.character.oldJumpInput then
    self.character:setLowerState("jump")
    return
  end

  if inputY == 1 then
    self.character:setLowerState("slide")
    return
  end

  if inputX == 0 then
    self.character:setLowerState("stand")
    return
  end
end

return CharacterWalkState
