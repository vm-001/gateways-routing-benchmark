
up-basic:
	docker compose up -d

up-kong:
	cd gateways/kong && docker compose up -d

up-tyk:
	cd gateways/tyk && docker compose up -d

up-apisix:
	cd gateways/apisix && docker compose up -d

# start all
start: up-basic up-kong up-tyk up-apisix

down-basic:
	docker compose down

down-kong:
	cd gateways/kong && docker compose down

down-apisix:
	cd gateways/apisix && docker compose down

down-tyk:
	cd gateways/tyk && docker compose down

# stop all
stop: down-basic down-kong down-apisix down-tyk

t=1
c=200
d=30s
WRK_OPTIONS := -t$(t) -c$(c) -d$(d) --latency

bench-upstream:
	wrk $(WRK_OPTIONS) http://localhost:8888

bench-single-static:
	curl http://localhost:8000/api
	curl http://localhost:9080/api
	curl http://localhost:8080/api

	wrk $(WRK_OPTIONS) http://localhost:8000/api
	sleep 10
	wrk $(WRK_OPTIONS) http://localhost:9080/api
	sleep 10
	wrk $(WRK_OPTIONS) http://localhost:8080/api

bench-static:
	curl http://localhost:8000/paths/urls/links/redirects
	curl http://localhost:9080/paths/urls/links/redirects
	curl http://localhost:8080/paths/urls/links/redirects

	wrk $(WRK_OPTIONS) http://localhost:8000/paths/urls/links/redirects
	sleep 10
	wrk $(WRK_OPTIONS) http://localhost:9080/paths/urls/links/redirects
	sleep 10
	wrk $(WRK_OPTIONS) http://localhost:8080/paths/urls/links/redirects

bench-openai:
	curl http://localhost:8000/threads/{thread_id}/messages/{message_id}/files/{file_id}
	curl http://localhost:9080/threads/{thread_id}/messages/{message_id}/files/{file_id}
	curl http://localhost:8080/threads/{thread_id}/messages/{message_id}/files/{file_id}

	wrk $(WRK_OPTIONS) --script scripts/wrk/openai-path.lua http://localhost:8000
	sleep 10
	wrk $(WRK_OPTIONS) --script scripts/wrk/openai-path.lua http://localhost:9080
	sleep 10
	wrk $(WRK_OPTIONS) --script scripts/wrk/openai-path.lua http://localhost:8080

bench-okta:
	curl http://localhost:8000/api/v1/brands/{brandId}/templates/email/{templateName}/customizations/{customizationId}/preview
	curl http://localhost:9080/api/v1/brands/{brandId}/templates/email/{templateName}/customizations/{customizationId}/preview
	curl http://localhost:8080/api/v1/brands/{brandId}/templates/email/{templateName}/customizations/{customizationId}/preview

	wrk $(WRK_OPTIONS) --script scripts/wrk/okta-path.lua http://localhost:8000
	sleep 10
	wrk $(WRK_OPTIONS) --script scripts/wrk/okta-path.lua http://localhost:9080
	sleep 10
	wrk $(WRK_OPTIONS) --script scripts/wrk/okta-path.lua http://localhost:8080

bench-github:
	curl http://localhost:8000/repos/{owner}/{repo}/pages/health
	curl http://localhost:9080/repos/{owner}/{repo}/pages/health
	curl http://localhost:8080/repos/{owner}/{repo}/pages/health

	wrk $(WRK_OPTIONS) --script scripts/wrk/github-path.lua http://localhost:8000
	sleep 10
	wrk $(WRK_OPTIONS) --script scripts/wrk/github-path.lua http://localhost:9080
	sleep 10
	wrk $(WRK_OPTIONS) --script scripts/wrk/github-path.lua http://localhost:8080