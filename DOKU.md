
# Kurzdoku: Docker-Container mit Terraform aufsetzen + Azure Backend

## Überblick

In diesem Projekt deployen wir drei Docker-Container mit Terraform:

- **Nginx** als Webserver
- **Node.js App** als Beispiel-Anwendung
- **Redis** als Datenbank-Service

Zusätzlich speichern wir den Terraform-Zustand (State) sicher in Azure Storage. So bleibt unser Terraform-Status zentral und wir vermeiden Konflikte.

---

## Vorbereitung

1. **Terraform & Docker** müssen auf deinem Rechner installiert sein.
2. Ein **Azure Storage Account** mit einem Blob-Container ist angelegt (z.B. `tfstate`).
3. Die Datei `backend.tf` ist so konfiguriert, dass Terraform den State in Azure speichert.

---

## Azure Backend (backend.tf)

```hcl
terraform {
  backend "azurerm" {
    resource_group_name   = "meinResourceGroup"
    storage_account_name  = "meinStorageAccount"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
```

> **Was bedeutet das?**  
> Terraform speichert seine Statusdatei nicht lokal, sondern in Azure Blob Storage. So können mehrere Leute gemeinsam an der Infrastruktur arbeiten.

---

## Was passiert?

- Terraform erstellt Docker-Container für Nginx, Node.js App und Redis.
- Jeder Container hat passende Port-Weiterleitungen, z.B. Nginx auf `8080`.
- Der Terraform State wird in Azure gespeichert, damit er zentral verwaltet wird.

---

## Wichtige Ports

| Container     | Externer Port | Interner Port |
|---------------|---------------|---------------|
| Nginx         | 8080          | 80            |
| Node.js App   | 8081          | 80            |
| Redis         | (kein Mapping) | 6379          |

---

## Testen der Container

- Im Browser:

  - `http://localhost:8080` → Nginx-Webserver
  - `http://localhost:8081` → Node.js App

- Per Curl:

  ```bash
  curl http://localhost:8080
  curl http://localhost:8081
  ```

---

## Terraform-Befehle

- **Init**: Einmalig, um das Azure Backend zu konfigurieren

  ```bash
  terraform init
  ```

- **Apply**: Container starten / aktualisieren

  ```bash
  terraform apply
  ```

- **Destroy**: Container stoppen / löschen

  ```bash
  terraform destroy
  ```

---

## Wichtige Hinweise

- Azure Storage muss existieren und richtig in `backend.tf` eingetragen sein.
- Ports dürfen nicht durch andere Programme blockiert sein.
- Der zentrale Terraform State verhindert Probleme bei der Zusammenarbeit.

---

Viel Erfolg! Bei Fragen einfach melden. 🙂
