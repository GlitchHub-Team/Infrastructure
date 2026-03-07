package mock

import (
	"errors"
	"fmt"
	"strings"
)

// ServerConfig is a small mock config used only to validate CI checks.
type ServerConfig struct {
	Host        string
	ClientPort  int
	MonitorPort int
	UseTLS      bool
}

func (c ServerConfig) Validate() error {
	if strings.TrimSpace(c.Host) == "" {
		return errors.New("host is required")
	}
	if c.ClientPort < 1 || c.ClientPort > 65535 {
		return fmt.Errorf("client port out of range: %d", c.ClientPort)
	}
	if c.MonitorPort != 0 && (c.MonitorPort < 1 || c.MonitorPort > 65535) {
		return fmt.Errorf("monitor port out of range: %d", c.MonitorPort)
	}
	return nil
}

func (c ServerConfig) URL() (string, error) {
	if err := c.Validate(); err != nil {
		return "", err
	}

	scheme := "nats"
	if c.UseTLS {
		scheme = "tls"
	}

	return fmt.Sprintf("%s://%s:%d", scheme, c.Host, c.ClientPort), nil
}

func StreamSubject(tenant string) (string, error) {
	tenant = strings.TrimSpace(tenant)
	if tenant == "" {
		return "", errors.New("tenant is required")
	}
	if strings.ContainsAny(tenant, " >*") {
		return "", errors.New("tenant contains invalid characters")
	}

	return fmt.Sprintf("sensors.%s.>", tenant), nil
}
