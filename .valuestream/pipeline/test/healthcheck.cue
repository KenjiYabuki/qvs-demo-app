package healthcheck

import (
	"github.com/KenjiYabuki/qvs-demo-app/pipeline/task:healthcheck"
)

DesignPattern: {
	name: "test:healthcheck"

	pipelines: {
		"test": {
			tasks: {
				"health-check": healthcheck.#Builder
			}
		}
	}
}
