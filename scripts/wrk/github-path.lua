local counter = 0

local API = "/repos/" .. tostring(os.time()) .. "/%d/pages/health"

print(API)

request = function()
  counter = counter + 1
  local path = string.format(API, counter)
  return wrk.format(nil, path)
end
