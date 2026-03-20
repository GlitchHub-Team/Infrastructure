# Infrastructure

repository MVP per  il sla parte infrastrutturale del progetto.
Contiene:
-  NATS JetStream
-  TimescaleDB
-  PostgreSQL
-  Grafana
-  Prometheus
-  NATS Manager(nats-box)

Per integrarla in un'altra repository:
- Clonare questa repository
- Includere il docker compose nel docker compose della repository che si vuole integrare e il file .env nel docker compose
- Inserire in nats/certs la server.key che si può trovare su Bitwarden nella cartella Infrastructure
- Inserire in natsManager le stream_setupper.creds che si può trovare su Bitwarden nella cartella Infrastructure
- Creare un file .env con le variabili d'ambiente necessarie per la configurazione dei servizi, si può trovare nella cartella Infrastructure su Bitwarden
