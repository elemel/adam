local CharacterHoldAnimation = require "CharacterHoldAnimation"
local common = require "common"

local CharacterGrabState = {}
CharacterGrabState.__index = CharacterGrabState

function CharacterGrabState.new(args)
  local state = {}
  setmetatable(state, CharacterGrabState)

  state.character = args.character

  state.character.upperAnimation = CharacterHoldAnimation.new({character = state.character})

  game.updates.control[state] = CharacterGrabState.update

  return state
end

function CharacterGrabState:destroy()
  game.updates.control[self] = nil

  self.character.upperAnimation = nil
end

function CharacterGrabState:update(dt)
  if not self.character.attackInput then
    self.character:setUpperState("idle")
    return
  end

  local function squaredDistance(villager)
    local x, y = self.character.physics.body:getPosition()
    local targetX, targetY = villager.physics.body:getPosition()

    return common.squaredDistance(x, y, targetX, targetY)
  end

  local villagers = common.filter(common.keys(game.tags.villager),
    function(villager)
      return (villager.lowerState ~= "grabbed" and
        villager.lowerState ~= "spinning" and
        squaredDistance(villager) < self.character.maxGrabDistance ^ 2)
    end)

  if #villagers >= 1 then
    table.sort(villagers,
      function(a, b) return squaredDistance(a) < squaredDistance(b) end)

    self.character.captive = villagers[1]
    self.character.captive.captor = self
    self.character.captive:setLowerState("struggle")
    self.character:setUpperState("hold")

    game.sounds.grab:clone():play()
    return
  end
end

return CharacterGrabState
