package healthcheck

import (
	"qmonus.net/adapter/official/pipeline/schema"
)

#BuildInput: {
	...
}

#Builder: schema.#TaskBuilder
#Builder: {
	name: "health-check"

	params: {
		url: desc: "The health check endpoint URL"
	}
	steps: [{
		name:  "check-health"
		image: "curlimages/curl:8.5.0"
		script: """
			set -e
			echo "Checking health for $(params.url)"
			response=$(curl -o /dev/null -s -w "%{http_code}\n" $(params.url))
			if [ "$response" != "200" ]; then
				echo "Health check failed with status code: $response"
				exit 1
			fi
			echo "Health check passed"
			"""
	}]
}
