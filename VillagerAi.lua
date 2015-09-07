local common = require "common"

local VillagerAi = {}
VillagerAi.__index = VillagerAi

function VillagerAi.new(args)
  local ai = {}
  setmetatable(ai, VillagerAi)

  ai.minSpawnDistance = 16
  ai.maxSpawnDistance = 32

  game.updates.controls[ai] = VillagerAi.update

  return terrain
end

function VillagerAi:destroy()
  game.updates.controls[self] = nil
end

function VillagerAi:update(dt)
  for villager, _ in pairs(game.tags.villager) do
    villager.aiDelay = villager.aiDelay - dt

    if villager.aiDelay < 0 then
      if villager.y > 16 then
        local spawnDistance = (self.minSpawnDistance +
          (self.maxSpawnDistance - self.minSpawnDistance) * love.math.random())

        villager.x = game.camera.x + spawnDistance * (2 * love.math.random(0, 1) - 1)
        villager.y = -1

        villager.dx = 0
        villager.dy = 0

        villager.angle = 0
        villager.dAngle = 0

        villager.lowerState = "standing"
        villager.upperState = nil

        villager.thrown = false
      end

      local target = game.names.victor

      local inputX

      if target then
        inputX = common.sign(target.x - villager.x)
      else
        inputX = love.math.random(-1, 1)
      end

      villager.leftInput = (inputX == -1)
      villager.rightInput = (inputX == 1)

      villager.aiDelay = 0.5 + 0.5 * math.random()
    end
  end
end

return VillagerAi
