package mock

import "testing"

func TestURLWithTLS(t *testing.T) {
	cfg := ServerConfig{Host: "nats.local", ClientPort: 4222, UseTLS: true}

	got, err := cfg.URL()
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	want := "tls://nats.local:4222"
	if got != want {
		t.Fatalf("got %q, want %q", got, want)
	}
}

func TestURLInvalidPort(t *testing.T) {
	cfg := ServerConfig{Host: "nats.local", ClientPort: 70000}

	_, err := cfg.URL()
	if err == nil {
		t.Fatal("expected error for invalid port")
	}
}

func TestStreamSubject(t *testing.T) {
	got, err := StreamSubject("tenant_1")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	want := "sensors.tenant_1.>"
	if got != want {
		t.Fatalf("got %q, want %q", got, want)
	}
}

func TestStreamSubjectInvalidTenant(t *testing.T) {
	_, err := StreamSubject(" ")
	if err == nil {
		t.Fatal("expected error for empty tenant")
	}
}
