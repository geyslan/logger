package main

import (
	"log"

	"github.com/geyslan/logger/internal/server"
)

func main() {
	srv := server.NewHTTPServer(":9191")
	log.Fatal(srv.ListenAndServe())
}
