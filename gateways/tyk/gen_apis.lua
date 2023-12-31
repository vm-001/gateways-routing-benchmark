local template =
[[
{
  "name": "%s",
  "api_id": "%d",
  "org_id": "test",
  "use_keyless": true,
  "version_data": {
    "not_versioned": true,
    "versions": {
      "Default": {
        "name": "Default",
        "use_extended_paths": true
      }
    }
  },
  "proxy": {
    "listen_path": "%s",
    "target_url": "http://host.docker.internal:8888/",
    "strip_listen_path": false
  },
  "active": true
}
]]

local DATA_DIR = "../../data/"

for _, name in ipairs({ "single-static", "static", "okta", "openai" }) do
  local n = 0
  for line in io.lines(DATA_DIR .. string.format("%s-apis.txt", name)) do
    n = n + 1
    local content = string.format(template, line, n, line)
    local file = io.open(string.format("apps/%s/%d.json", name, n), "w")
    file:write(content)
    file:flush()
    file:close()
  end
end
