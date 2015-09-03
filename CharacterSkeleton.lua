local CharacterSkeleton = {}
CharacterSkeleton.__index = CharacterSkeleton

function CharacterSkeleton.new(args)
  local skeleton = {}
  setmetatable(skeleton, CharacterSkeleton)

  args = args or {}

  skeleton.height = args.height or 1.8
  local scale = skeleton.height / 1.8

  local bones = {}

  bones.back = game.sceneGraph.root:newChild(args.x or 0, args.y or 0)

  bones.neck = bones.back:newChild(0, scale * -0.3)
  bones.head = bones.neck:newChild(0, scale * -0.15)

  bones.leftShoulder = bones.back:newChild(scale * -0.15, scale * -0.3, 0.125 * math.pi)
  bones.leftElbow = bones.leftShoulder:newChild(0, scale * 0.45, -0.125 * math.pi)
  bones.leftWrist = bones.leftElbow:newChild(0, scale * 0.45)

  bones.rightShoulder = bones.back:newChild(scale * 0.15, scale * -0.3, -0.125 * math.pi)
  bones.rightElbow = bones.rightShoulder:newChild(0, scale * 0.45, -0.125 * math.pi)
  bones.rightWrist = bones.rightElbow:newChild(0, scale * 0.45)

  bones.leftHip = bones.back:newChild(scale * -0.15, scale * 0.3)
  bones.leftKnee = bones.leftHip:newChild(0, scale * 0.45, 0.125 * math.pi)
  bones.leftAnkle = bones.leftKnee:newChild(0, scale * 0.45)

  bones.rightHip = bones.back:newChild(scale * 0.15, scale * 0.3, -0.125 * math.pi)
  bones.rightKnee = bones.rightHip:newChild(0, scale * 0.45, 0.125 * math.pi)
  bones.rightAnkle = bones.rightKnee:newChild(0, scale * 0.45)

  skeleton.bones = bones

  return skeleton
end

return CharacterSkeleton
