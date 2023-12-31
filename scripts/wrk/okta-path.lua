local counter = 0

local API = "/api/v1/brands/" .. tostring(os.time()) .. "/templates/email/111/customizations/%d/preview"

print(API)

request = function()
  counter = counter + 1
  local path = string.format(API, counter)
  return wrk.format(nil, path)
end
