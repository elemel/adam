local CharacterPhysics = {}
CharacterPhysics.__index = CharacterPhysics

function CharacterPhysics.new(args)
  local world = game.names.physics.world

  local physics = {}
  setmetatable(physics, CharacterPhysics)

  local x = args.x or 0
  local y = args.y or 0

  local height = args.height or 1.8
  local width = args.width or 0.6

  physics.body = love.physics.newBody(world, x, y, "dynamic")
  physics.body:setFixedRotation(true)
  physics.body:setGravityScale(0)

  local topShape = love.physics.newCircleShape(0, 0.5 * width - 0.5 * height, 0.5 * width)
  physics.topFixture = love.physics.newFixture(physics.body, topShape)
  physics.topFixture:setFriction(0)

  local bottomShape = love.physics.newCircleShape(0, 0.5 * height - 0.5 * width, 0.5 * width)
  physics.bottomFixture = love.physics.newFixture(physics.body, bottomShape)
  physics.bottomFixture:setFriction(0)

  local sensorRadius = width / 8

  local topSensorShape = love.physics.newCircleShape(0, 0.5 * width - 0.5 * height, 0.5 * width + sensorRadius)
  physics.topSensorFixture = love.physics.newFixture(physics.body, topSensorShape)
  physics.topSensorFixture:setSensor(true)

  local bottomSensorShape = love.physics.newCircleShape(0, 0.5 * height - 0.5 * width, 0.5 * width + sensorRadius)
  physics.bottomSensorFixture = love.physics.newFixture(physics.body, bottomSensorShape)
  physics.bottomSensorFixture:setSensor(true)

  return physics
end

function CharacterPhysics:destroy()
  self.body:destroy()
end

function CharacterPhysics:getFloorFixture()
  for i, contact in pairs(self.body:getContactList()) do
    if contact:isTouching() then
      local fixtureA, fixtureB = contact:getFixtures()

      if fixtureA == self.bottomSensorFixture then
        if not fixtureB:isSensor() then
          return fixtureB
        end
      end

      if fixtureB == self.bottomSensorFixture then
        if not fixtureA:isSensor() then
          return fixtureA
        end
      end
    end
  end
end

return CharacterPhysics
