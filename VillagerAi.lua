local common = require "common"

local VillagerAi = {}
VillagerAi.__index = VillagerAi

function VillagerAi.new(args)
  local ai = {}
  setmetatable(ai, VillagerAi)

  ai.minSpawnDistance = 16
  ai.maxSpawnDistance = 32

  game.updates.input[ai] = VillagerAi.update

  return terrain
end

function VillagerAi:destroy()
  game.updates.input[self] = nil
end

function VillagerAi:update(dt)
  for villager, _ in pairs(game.tags.villager) do
    villager.aiDelay = villager.aiDelay - dt

    if villager.aiDelay < 0 then
      local x, y = villager.physics.body:getPosition()
      if y > 16 then
        villager:destroy()
        return
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
