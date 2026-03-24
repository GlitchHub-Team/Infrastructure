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
- Creare i file gateway1.creds e gateway2.creds nella cartella Infrastructure/testCreds con le chiavi private e i JWT per i gateway1 e gateway2, si possono trovare su Bitwarden nella cartella Infrastructure

# Test creds
Sono presenti nella cartella di testCreds:
- gateway1.pub: public key del gateway1
- gateway1.creds: private key e JWT per il gateway1, da popolare con il contenuto su Bitwarden nella cartella *Infrastructure*, gateway1.creds
- gateway2.pub: public key del gateway2
- gateway2.creds: private key e JWT per il gateway2, da popolare con il contenuto su Bitwarden nella cartella *Infrastructure*, gateway2.creds