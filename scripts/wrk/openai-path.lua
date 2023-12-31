local counter = 0

local API = "/threads/" .. tostring(os.time()) .. "/messages/111/files/%d"

print(API)

request = function()
  counter = counter + 1
  local path = string.format(API, counter)
  return wrk.format(nil, path)
end
