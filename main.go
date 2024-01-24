package main

import (
	"log"
	"net/http"
	"os"

	"github.com/go-chi/chi"
	"github.com/go-chi/chi/middleware"
)

const (
	envPort     = "PORT"
	defaultPort = "80"
)

func serveHTTP() error {
	r := chi.NewRouter()
	r.Use(middleware.Logger)

	r.Get("/", hello)
	r.Get("/health", health)

	port := os.Getenv(envPort)
	if port == "" {
		port = defaultPort
	}
	log.Printf("Listening on port %s", port)
	return http.ListenAndServe(":"+port, r)
}

func hello(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("hello Qmonus Value Stream"))
}

func health(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("healthy"))
}

func main() {
	if err := serveHTTP(); err != nil {
		log.Fatal(err)
	}
}
