local CharacterSkin = {}
CharacterSkin.__index = CharacterSkin

function CharacterSkin.new(args)
  local skin = {}
  setmetatable(skin, CharacterSkin)

  skin.skeleton = args.skeleton

  skin.nodes = {}

  local scale = skin.skeleton.height / 1.8
  local pixelScale = 0.3 / 4

  skin.nodes.body = skin.skeleton.bones.back:newChild(0, scale * -0.15, 0, pixelScale, pixelScale, 16, 16)

  skin.nodes.head = skin.skeleton.bones.neck:newChild(0, scale * -0.15, 0, pixelScale, pixelScale, 8, 8)

  skin.nodes.leftUpperArm = skin.skeleton.bones.leftShoulder:newChild(0, scale * 0.15, 0, pixelScale, pixelScale, 8, 8)
  skin.nodes.leftLowerArm = skin.skeleton.bones.leftElbow:newChild(0, scale * 0.15, 0, pixelScale, pixelScale, 8, 8)

  skin.nodes.rightUpperArm = skin.skeleton.bones.rightShoulder:newChild(0, scale * 0.15, 0, pixelScale, pixelScale, 8, 8)
  skin.nodes.rightLowerArm = skin.skeleton.bones.rightElbow:newChild(0, scale * 0.15, 0, pixelScale, pixelScale, 8, 8)

  skin.nodes.leftUpperLeg = skin.skeleton.bones.leftHip:newChild(0, scale * 0.225, 0, pixelScale, pixelScale, 8, 8)
  skin.nodes.leftLowerLeg = skin.skeleton.bones.leftKnee:newChild(0, scale * 0.225, 0, pixelScale, pixelScale, 8, 8)

  skin.nodes.rightUpperLeg = skin.skeleton.bones.rightHip:newChild(0, scale * 0.225, 0, pixelScale, pixelScale, 8, 8)
  skin.nodes.rightLowerLeg = skin.skeleton.bones.rightKnee:newChild(0, scale * 0.225, 0, pixelScale, pixelScale, 8, 8)

  return skin
end

function CharacterSkin:draw()
  love.graphics.setShader(game.shader)

  local rightUpperArmTransform = game.sceneGraph.worldTransforms[self.nodes.rightUpperArm.id]
  game.shader:send("vertexTransformation", rightUpperArmTransform:toTransposedMatrix4())
  love.graphics.draw(game.images.adamRightUpperArm)

  local rightLowerArmTransform = game.sceneGraph.worldTransforms[self.nodes.rightLowerArm.id]
  game.shader:send("vertexTransformation", rightLowerArmTransform:toTransposedMatrix4())
  love.graphics.draw(game.images.adamRightLowerArm)

  local rightUpperLegTransform = game.sceneGraph.worldTransforms[self.nodes.rightUpperLeg.id]
  game.shader:send("vertexTransformation", rightUpperLegTransform:toTransposedMatrix4())
  love.graphics.draw(game.images.adamRightUpperLeg)

  local rightLowerLegTransform = game.sceneGraph.worldTransforms[self.nodes.rightLowerLeg.id]
  game.shader:send("vertexTransformation", rightLowerLegTransform:toTransposedMatrix4())
  love.graphics.draw(game.images.adamRightLowerLeg)

  local bodyTransform = game.sceneGraph.worldTransforms[self.nodes.body.id]
  game.shader:send("vertexTransformation", bodyTransform:toTransposedMatrix4())
  love.graphics.draw(game.images.adamBody)

  local headTransform = game.sceneGraph.worldTransforms[self.nodes.head.id]
  game.shader:send("vertexTransformation", headTransform:toTransposedMatrix4())
  love.graphics.draw(game.images.adamHead)

  local leftUpperLegTransform = game.sceneGraph.worldTransforms[self.nodes.leftUpperLeg.id]
  game.shader:send("vertexTransformation", leftUpperLegTransform:toTransposedMatrix4())
  love.graphics.draw(game.images.adamLeftUpperLeg)

  local leftLowerLegTransform = game.sceneGraph.worldTransforms[self.nodes.leftLowerLeg.id]
  game.shader:send("vertexTransformation", leftLowerLegTransform:toTransposedMatrix4())
  love.graphics.draw(game.images.adamLeftLowerLeg)

  local leftUpperArmTransform = game.sceneGraph.worldTransforms[self.nodes.leftUpperArm.id]
  game.shader:send("vertexTransformation", leftUpperArmTransform:toTransposedMatrix4())
  love.graphics.draw(game.images.adamLeftUpperArm)

  local leftLowerArmTransform = game.sceneGraph.worldTransforms[self.nodes.leftLowerArm.id]
  game.shader:send("vertexTransformation", leftLowerArmTransform:toTransposedMatrix4())
  love.graphics.draw(game.images.adamLeftLowerArm)

  love.graphics.setShader(nil)
end

return CharacterSkin
