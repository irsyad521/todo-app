# Todo App – Mobile (Flutter)

A Flutter-based mobile application for practicing secure mobile architecture, API interaction, and mobile penetration testing scenarios.

Designed to simulate a real-world application structure with authentication, role-based access control, and client-side security mechanisms.

---

## Architecture

```text
UI → Controller → Service → API Client
```

* Controller → state & UI logic
* Service → business logic abstraction
* API Client → HTTP communication layer
* Core → shared utilities & configuration

---

## Features

* JWT Authentication
* Todo CRUD
* User Management (admin only)
* Pagination support
* System Mode viewer (admin only)
* Structured API response handling
* Device security check
* SSL Pinning (testing purpose)

---

## Setup

Install dependencies:

```bash
fvm flutter pub get
```

Run application:

```bash
fvm flutter run
```

---

## Automatic Provisioning

This project includes a Python provisioning script to simplify environment preparation and APK deployment.

### Usage

```bash
python provision.py <domain>
```

Example:

```bash
python provision.py todo-app-backend-mobile-pentest-production.up.railway.app
```

---

### Provisioning Tasks

* Generate SSL fingerprint from target domain
* Update environment configuration automatically
* Build APK using FVM
* Detect connected device ABI
* Install APK through ADB

---

## Build APK

### Debug Build

```bash
fvm flutter build apk --debug --split-per-abi
```

### Release Build

```bash
fvm flutter build apk --release --split-per-abi
```

Output directory:

```text
build/app/outputs/flutter-apk/
```

---

## Requirements

* FVM
* ADB
* OpenSSL
* awk / Unix utilities

---

## Learning Goals

* Understand Flutter mobile architecture
* Practice REST API integration
* Simulate real-world mobile application behavior
* Learn SSL pinning implementation & bypassing
* Practice Flutter reverse engineering workflows

---

## Disclaimer

This project is intentionally designed for security research and educational purposes.

The application contains simplified and intentionally weak implementations to support mobile security testing, reverse engineering practice, and SSL pinning bypass demonstrations.

Do not use this project architecture or security model directly in production environments.
