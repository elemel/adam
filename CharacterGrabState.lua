local CharacterHoldAnimation = require "CharacterHoldAnimation"
local common = require "common"

local CharacterGrabState = {}
CharacterGrabState.__index = CharacterGrabState

function CharacterGrabState.new(args)
  local state = {}
  setmetatable(state, CharacterGrabState)

  state.character = args.character

  state.character.upperAnimation = CharacterHoldAnimation.new({character = state.character})

  game.updates.physics[state] = CharacterGrabState.update

  return state
end

function CharacterGrabState:destroy()
  game.updates.physics[self] = nil

  self.character.upperAnimation = nil
end

function CharacterGrabState:update(dt)
  game.sounds.grab:clone():play()

  local function squaredDistance(villager)
    return common.squaredDistance(self.character.x, self.character.y, villager.x, villager.y)
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
    game.sceneGraph:setParent(self.character.captive.skeleton.bones.back.id, self.character.skeleton.bones.rightWrist.id)
    self.character:setUpperState("hold")
    return
  end

  self.character:setUpperState("idle")
end

return CharacterGrabState
