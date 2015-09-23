local KeyboardInput = {}
KeyboardInput.__index = KeyboardInput

local function getInput(input)
  for i, key in pairs(game.keys[input]) do
    if love.keyboard.isDown(key) then
      return true
    end
  end

  return false
end

function KeyboardInput.new(args)
  local input = {}
  setmetatable(input, KeyboardInput)

  game.updates.input[input] = KeyboardInput.update

  return input
end

function KeyboardInput:destroy()
  game.updates.input[self] = nil

  self.body:destroy()
end

function KeyboardInput:update(dt)
  local character = game.names.adam

  if character then
    character.oldJumpInput = character.jumpInput
    character.oldAttackInput = character.attackInput

    character.leftInput = getInput("left")
    character.rightInput = getInput("right")

    character.upInput = getInput("up")
    character.downInput = getInput("down")

    character.jumpInput = getInput("jump")
    character.attackInput = getInput("attack")
  end
end

return KeyboardInput
