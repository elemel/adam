local KeyboardControls = {}
KeyboardControls.__index = KeyboardControls

local function getInput(input)
  for i, key in pairs(game.keys[input]) do
    if love.keyboard.isDown(key) then
      return true
    end
  end

  return false
end

function KeyboardControls.new(args)
  local controls = {}
  setmetatable(controls, KeyboardControls)

  game.updates.controls[controls] = KeyboardControls.update

  return controls
end

function KeyboardControls:destroy()
  game.updates.controls[self] = nil

  self.body:destroy()
end

function KeyboardControls:update(dt)
  local character = game.names.adam

  if character then
    character.leftInput = getInput("left")
    character.rightInput = getInput("right")

    character.jumpInput = getInput("jump")
  end
end

return KeyboardControls
