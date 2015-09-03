local Bone = require "Bone"
local BoneForest = require "BoneForest"

local CharacterSkeleton = {}
CharacterSkeleton.__index = CharacterSkeleton

function CharacterSkeleton.new(args)
  local skeleton = {}
  setmetatable(skeleton, CharacterSkeleton)

  args = args or {}

  skeleton.height = args.height or 1.8
  local scale = skeleton.height / 1.8

  local forest = args.forest or BoneForest.new()
  local bones = {}

  bones.root = Bone.newRoot(forest, args.x or 0, args.y or 0)

  bones.neck = Bone.newChild(bones.root, 0, scale * -0.3)
  bones.head = Bone.newChild(bones.neck, 0, scale * -0.15)

  bones.leftShoulder = Bone.newChild(bones.root, scale * -0.15, scale * -0.3, 0.125 * math.pi)
  bones.leftElbow = Bone.newChild(bones.leftShoulder, 0, scale * 0.45, -0.125 * math.pi)
  bones.leftWrist = Bone.newChild(bones.leftElbow, 0, scale * 0.45)

  bones.rightShoulder = Bone.newChild(bones.root, scale * 0.15, scale * -0.3, -0.125 * math.pi)
  bones.rightElbow = Bone.newChild(bones.rightShoulder, 0, scale * 0.45, -0.125 * math.pi)
  bones.rightWrist = Bone.newChild(bones.rightElbow, 0, scale * 0.45)

  bones.leftHip = Bone.newChild(bones.root, scale * -0.15, scale * 0.3)
  bones.leftKnee = Bone.newChild(bones.leftHip, 0, scale * 0.45, 0.125 * math.pi)
  bones.leftAnkle = Bone.newChild(bones.leftKnee, 0, scale * 0.45)

  bones.rightHip = Bone.newChild(bones.root, scale * 0.15, scale * 0.3, -0.125 * math.pi)
  bones.rightKnee = Bone.newChild(bones.rightHip, 0, scale * 0.45, 0.125 * math.pi)
  bones.rightAnkle = Bone.newChild(bones.rightKnee, 0, scale * 0.45)

  skeleton.bones = bones
  skeleton.forest = forest

  return skeleton
end

return CharacterSkeleton
