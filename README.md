# ApexTrade — High-Throughput Microservices Exchange Engine

> A distributed, low-latency trading platform engineered for real-time order matching and atomic financial settlement.

---

## Overview

**ApexTrade** is a production-grade exchange engine built on a decoupled microservices architecture. Designed for high-throughput digital asset trading, it prioritises sub-millisecond order matching, eventual consistency across services, and zero-leakage financial settlement.

### Core Capabilities

| Capability | Detail |
|---|---|
| Ultra-Fast Matching | O(log N) order matching via optimised Java `TreeMap` structures |
| Event-Driven Resilience | Apache Kafka decouples trade execution from order management |
| Atomic Settlement | Cross-service transaction integrity with zero-leakage financial updates |
| System Observability | Distributed tracing, health metrics, and real-time monitoring |

---

## System Architecture

```
┌─────────────────┐     REST      ┌──────────────────┐
│   API Client    │ ─────────────▶│  Order Service   │
└─────────────────┘               └────────┬─────────┘
                                           │ Kafka Event
                                           ▼
                                  ┌──────────────────┐
                                  │ Matching Engine  │
                                  │  (In-Memory)     │
                                  └────────┬─────────┘
                                           │ Trade Event
                                           ▼
                                  ┌──────────────────┐
                                  │  Wallet Service  │
                                  │  (Settlement)    │
                                  └──────────────────┘
```

The platform is built on a fully decoupled event-driven backbone:

1. **Order Service** — Orchestrates the REST API, manages order lifecycles, and maintains the primary order ledger
2. **Matching Engine** — Low-latency in-memory service dedicated to Bid/Ask matching logic
3. **Wallet Service** — Specialised accounting service for balance locking and trade settlement
4. **Kafka Event Bus** — High-speed backbone for streaming Order and Trade events between service clusters

![6c0b5352-90d5-43c6-8928-b10d76173014_microservices_architecture_diagram](https://github.com/user-attachments/assets/d80d3345-1e4b-4865-8a38-bb3ef94c90b9)

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 17 (LTS) |
| Framework | Spring Boot 3.x · Spring Cloud · Spring Data JPA |
| Messaging | Apache Kafka 3.x |
| Database | PostgreSQL (Schema-based multi-tenancy) |
| Monitoring | Spring Boot Actuator · Zipkin · Micrometer |
| Infrastructure | Docker · Maven |

---

## 📊 Database Design

ApexTrade uses a normalised relational model for absolute data consistency:

- **Schema Isolation** — Logical separation of `order_schema` and `wallet_schema` prevents cross-service data leakage
- **Normalised Trade Records** — The `trades` table stores execution metadata only; price reconstruction is handled via high-performance SQL Views joining on `orders`
- **Constraint Safety** — Hard `CHECK` constraints at the database level prevent negative balances, providing a final guard against race conditions

<img width="2816" height="1536" alt="Gemini_Generated_Image_zcvycczcvycczcvy" src="https://github.com/user-attachments/assets/252e082a-77ad-4ac6-a22e-ce8013f6fb08" />

---

## Getting Started

### Prerequisites

- Java 17+
- Docker Desktop
- Maven 3.9+

### Quick Start

**1. Initialise Infrastructure**
```bash
docker-compose up -d
```

**2. Build the Project**
```bash
mvn clean install
```

**3. Launch Services**

Run the following bootstrap classes:
- `OrderServiceApplication`
- `MatchingEngineApplication`

---

## API Specifications

### Create Limit Order

```
POST /api/v1/orders
```

```json
{
    "userName": "wahidsaeed1",
    "symbol": "BTC-USD",
    "side": "BUY",
    "price": 40000.0,
    "quantity": 0.5
}
```

### Health & Monitoring

| Endpoint | Description |
|---|---|
| `GET /actuator/health` | Service health check |
| `http://localhost:9411` | Zipkin distributed tracing UI |

---

## 📹 Technical Demonstration

Full walkthrough of the system architecture and live execution:

**[▶ Watch Demo](https://your-video-link-here)**

---

## 📁 Project Structure

```
apextrade/
├── order-service/
│   ├── src/main/java/
│   └── src/main/resources/
├── matching-engine/
│   ├── src/main/java/
│   └── src/main/resources/
├── wallet-service/
│   ├── src/main/java/
│   └── src/main/resources/
├── docker-compose.yml
└── pom.xml
```

---

## 📄 License

This project is licensed under the MIT License.
