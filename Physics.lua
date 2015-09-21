local Physics = {}
Physics.__index = Physics

function Physics.new(args)
  local physics = {}
  setmetatable(physics, Physics)

  physics.world = love.physics.newWorld(0, 10)

  game.names.physics = physics
  game.updates.physics[physics] = Physics.update
  game.draws.debug[physics] = Physics.debugDraw
  return physics
end

function Physics:update(dt)
  self.world:update(dt)
end

function Physics:debugDraw()
  love.graphics.setColor(0x00, 0xff, 0x00, 0xff)

  for i, body in pairs(self.world:getBodyList()) do
    for i, fixture in pairs(body:getFixtureList()) do
      local shape = fixture:getShape()
      local shapeType = shape:getType()
      if shapeType == "polygon" then
        love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
      elseif shapeType == "circle" then
        local x, y = shape:getPoint()
        local radius = shape:getRadius()

        local x1, y1 = body:getWorldPoint(x, y)
        local x2, y2 = body:getWorldPoint(x + radius, y)

        love.graphics.circle("line", x1, y1, radius, 16)
        love.graphics.line(x1, y1, x2, y2)
      end
    end
  end
end

return Physics
