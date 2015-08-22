local function clamp(x, x1, x2)
  return math.min(math.max(x, x1), x2)
end

local function sign(x)
  return x < 0 and -1 or 1
end

local function get2(t, x, y)
  return t[y] and t[y][x]
end

local function set2(t, x, y, value)
  if value == nil then
    if t[y] then
      t[y][x] = nil

      if not next(t[y]) then
        t[y] = nil
      end
    end
  else
    t[y] = t[y] or {}
    t[y][x] = value
  end
end

local function toByte(fraction)
  return clamp(math.floor(fraction * 256), 0, 255)
end

local function toByteColor(r, g, b, a)
  return toByte(r), toByte(g), toByte(b), toByte(a)
end

return {
  clamp = clamp,
  get2 = get2,
  set2 = set2,
  sign = sign,
  toByte = toByte,
  toByteColor = toByteColor,
}