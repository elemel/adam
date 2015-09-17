local common = require "common"

local CharacterWallContact = {}
CharacterWallContact.__index = CharacterWallContact

function CharacterWallContact.new(args)
  local contact = {}
  setmetatable(contact, CharacterWallContact)

  contact.character = args.character

  contact.x1 = args.x1 or 0
  contact.y1 = args.y1 or 0

  contact.x2 = args.x2 or 0
  contact.y2 = args.y2 or 0

  contact.snap = args.snap or 1 / 16
  contact.touching = false

  return contact
end

function CharacterWallContact:updateContact()
  local physics = game.names.physics
  self.touching = false

  local x1 = self.character.x + self.x1
  local y1 = self.character.y + self.y1

  local x2 = self.character.x + self.x2
  local y2 = self.character.y + self.y2

  local directionX, directionY = common.normalize(x2 - x1, y2 - y1)

  local snapX = self.snap * directionX
  local snapY = self.snap * directionY

  physics.world:rayCast(x1, y1, x2 + snapX, y2 + snapY,
    function(fixture, x, y, xn, yn, fraction)
      local body = fixture:getBody()

      self.touching = true

      self.contactX = x
      self.contactY = y

      self.contactNormalX = xn
      self.contactNormalY = yn

      self.contactLinearVelocityX, self.contactLinearVelocityY = body:getLinearVelocityFromWorldPoint(x, y)

      return fraction
    end)
end

function CharacterWallContact:applyFriction(friction)
  if self.touching then
    local tangentX = -self.contactNormalY
    local tangentY = self.contactNormalX

    local velocityX = self.character.dx - self.contactLinearVelocityX
    local velocityY = self.character.dy - self.contactLinearVelocityY

    local velocity = common.dot(velocityX, velocityY, tangentX, tangentY)
    local deltaVelocity = -common.sign(velocity) * math.min(math.abs(velocity), friction)

    self.character.dx = self.character.dx + deltaVelocity * tangentX
    self.character.dy = self.character.dy + deltaVelocity * tangentY
  end
end

function CharacterWallContact:applyConstraint()
  if self.touching then
    local x1 = self.character.x + self.x1
    local y1 = self.character.y + self.y1

    local x2 = self.character.x + self.x2
    local y2 = self.character.y + self.y2

    local directionX, directionY = common.normalize(x2 - x1, y2 - y1)

    local offsetX = self.contactX - x2
    local offsetY = self.contactY - y2

    local distance = common.dot(offsetX, offsetY, directionX, directionY)
    local deltaPosition = math.min(distance, 0)

    self.character.x = self.character.x + deltaPosition * directionX
    self.character.y = self.character.y + deltaPosition * directionY

    local velocityX = self.character.dx - self.contactLinearVelocityX
    local velocityY = self.character.dy - self.contactLinearVelocityY

    local velocity = common.dot(velocityX, velocityY, self.contactNormalX, self.contactNormalY)
    local deltaVelocity = -math.min(velocity, 0)

    self.character.dx = self.character.dx + deltaVelocity * self.contactNormalX
    self.character.dy = self.character.dy + deltaVelocity * self.contactNormalY
  end
end

return CharacterWallContact
