package main

import (
	"fmt"
	"log"

	"nats-jetstream-server/mock"
)

func main() {
	cfg := mock.ServerConfig{
		Host:        "localhost",
		ClientPort:  4222,
		MonitorPort: 8222,
		UseTLS:      false,
	}

	url, err := cfg.URL()
	if err != nil {
		log.Fatal(err)
	}

	subject, err := mock.StreamSubject("tenant_1")
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("mock nats config ready: client=%s monitor=%d subject=%s\n", url, cfg.MonitorPort, subject)
}
