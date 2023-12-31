local Router = require "radix-router"
local utils = require("kong.router.utils")
local lrucache = require("resty.lrucache")

local get_method = ngx.req.get_method
local var = ngx.var
local get_service_info = utils.get_service_info
local get_upstream_uri_v0  = utils.get_upstream_uri_v0
local sanitize_uri_postfix = utils.sanitize_uri_postfix
local DEFAULT_MATCH_LRUCACHE_SIZE = utils.DEFAULT_MATCH_LRUCACHE_SIZE

local _M = {}
local mt = { __index = _M }

local req_ctx = {}

function _M:select(req_method, req_uri, req_host)
  req_ctx.method = req_method
  local params = {}
  local handler, matched_path = self.router:match(req_uri, req_ctx, params)
  if not handler then
    return nil
  end
  local matched_route = handler.route

  local service_protocol, _, service_host, service_port, service_hostname_type, service_path = get_service_info(handler.service)

  local request_prefix = matched_route.strip_path and matched_path or nil
  local request_postfix = request_prefix and req_uri:sub(#matched_path + 1) or req_uri:sub(2, -1)
  request_postfix = sanitize_uri_postfix(request_postfix) or ""
  local upstream_base = service_path or "/"


  local upstream_uri = get_upstream_uri_v0(matched_route, request_postfix, req_uri, upstream_base)

  return {
    route = matched_route,
    service = handler.service,

    matches = {
      uri_captures = params,
      method = req_method,
    },
    upstream_url_t = {
      type = service_hostname_type,
      host = service_host,
      port = service_port,
    },
    upstream_scheme = service_protocol,
    upstream_uri    = upstream_uri,
    upstream_host   = matched_route.preserve_host and req_host or nil,
  }
end

function _M:exec(ctx)
  local req_method = get_method()
  local req_uri = ctx and ctx.request_uri or var.request_uri
  local req_host = var.http_host

  --local cache_key = (req_method  or "") .. "|" ..
  --  (req_uri     or "") .. "|" ..
  --  (req_host    or "") .. "|"
  --
  --local match_t = self.cache:get(cache_key)
  --if not match_t then
  --  if self.cache_neg:get(cache_key) then
  --    return nil
  --  end
  --
  --  match_t = self:select(req_method, req_uri, req_host)
  --  if not match_t then
  --    self.cache_neg:set(cache_key, true)
  --    return nil
  --  end
  --
  --  self.cache:set(cache_key, match_t)
  --end
  --
  --return match_t

  return self:select(req_method, req_uri, req_host)
end

function _M.new(routes, cache, cache_neg)
  if type(routes) ~= "table" then
    return error("expected arg #1 routes to be a table")
  end

  local radix_routes = {}

  for i = 1, #routes do
    local route = routes[i]
    local r = routes[i].route

    radix_routes[i] = {
      paths = r.paths,
      methods = r.methods,
      handler = route,
    }
  end

  local router, err = Router.new(radix_routes)
  if not router then
    return error("failed to create radix router: ", err)
  end

  local self = {
    router = router,
    cache = cache or lrucache.new(DEFAULT_MATCH_LRUCACHE_SIZE),
    cache_neg = cache_neg or lrucache.new(DEFAULT_MATCH_LRUCACHE_SIZE),
  }

  return setmetatable(self, mt)
end

return _M
