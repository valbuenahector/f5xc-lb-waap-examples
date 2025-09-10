# F5XC Terraform Examples

This repository provides verified, runnable Terraform examples for F5XC Load Balancing (LB), WAAP (Web Application & API Protection), and Bot Defense across RE (Regional Edge) and CE (Customer Edge) deployments, plus CE deploy automation & maintenance.

## Examples

*   [RE Load Balancer Basic](./docs/re-lb-basic.md)
*   [RE WAAP and Bot Defense](./docs/re-lb-waap-bot.md)
*   [RE WAAP, Bot Defense and CDN](./docs/re-lb-waap-bot-cdn.md)
*   [CE Load Balancer Basic](./examples/ce-lb-basic/README.md)
*   [CE WAAP and Bot Defense](./examples/ce-lb-waap-bot/README.md)
*   [CE WAAP, Bot Defense and CDN](./examples/ce-lb-waap-bot-cdn/README.md)
*   [CE Deploy AWS Site with Single Multi-Cloud v2](./examples/ce-deploy-aws-smsv2/README.md)

## Getting Started

Before running any of the examples, you will need to create a `terraform.tfvars` file in each example's directory. This file will contain the necessary credentials and configuration for your F5XC tenant.

Create a file named `terraform.tfvars` with the following content:

```hcl
f5xc_api_p12_file     = "/<PATH>/certificate.p12"
f5xc_api_url          = "https://<F5XC-TENANT>.console.ves.volterra.io/api"
f5xc_tenant           = "<F5XC-TENANT>"
f5xc_namespace        = "<NAMESPACE>"
```

Replace the placeholder values with your actual F5XC tenant information.

## Disclaimer

This code is for testing and demonstration purposes only and should not be used in a production environment without proper review and adjustments. The code is provided "AS IS" without warranty of any kind.

---

## Bot Protection Clarification

Here’s a clear breakdown of how **Bot Protection** works in **F5 Distributed Cloud (F5XC)**, depending on whether it is configured via a **WAF policy** or via the **HTTP Load Balancer (LB) configuration**:

---

### 1. **Signature-Based Bot Protection in WAF Policy**

**Definition:**
This is part of the **F5XC WAAP (Web Application & API Protection)** service. It uses **signature-based detection** within the WAF policy.

**How it works:**

* Relies on a **static signature database** of known bad bots (malicious crawlers, scrapers, vulnerability scanners, etc.).
* Matching is done based on request metadata such as:

  * User-Agent strings
  * Known patterns of malicious traffic
  * Header anomalies
* Primarily used for **blocking “known bad” automated traffic**.

**Pros:**

* Low overhead (simple signature matching).
* Effective against commodity bots and scanners.
* Easy to configure within WAF policy.

**Limitations:**

* **No behavioral analysis** – cannot detect sophisticated bots mimicking real users.
* Requires **regular signature updates** to stay current.
* Can be bypassed by bots that randomize headers or mimic legitimate clients.

---

### 2. **Bot Protection in HTTP Load Balancer Configuration**

**Definition:**
This is the **advanced Bot Defense capability** built into the HTTP LB object. It provides **behavioral, JavaScript, and ML-driven detection**.

**How it works:**

* Injects **JavaScript challenges** or **mobile SDK challenges** into web/app flows.
* Uses **device/browser fingerprinting** and **behavioral analysis**:

  * Tracks mouse movements, keystroke dynamics, swipe/touch gestures.
  * Detects headless browsers, automation frameworks (e.g., Selenium, Puppeteer).
  * Identifies credential stuffing, account takeover, and scraping bots.
* Can enforce actions such as **block, redirect, or CAPTCHA**.

**Pros:**

* Detects **sophisticated human-like bots**.
* Provides **visibility and reporting** (good bot vs. bad bot classification).
* Can **differentiate between good bots** (Googlebot, Bingbot, partner APIs) and malicious automation.

**Limitations:**

* Higher complexity in deployment (JavaScript injection, SDK integration).
* Slight increase in client-side latency due to challenges.


---

### **Key Differences**

| Feature               | WAF Policy (Signature-Based Bot Protection)  | HTTP LB (Bot Defense)                                                        |
| --------------------- | -------------------------------------------- | ---------------------------------------------------------------------------- |
| **Detection Method**  | Static signatures of known bad bots          | Behavioral + JS/mobile SDK challenges + ML                                   |
| **Scope**             | Blocks “known bad” bots (scanners, crawlers) | Detects sophisticated automation (credential stuffing, scraping, fraud bots) |
| **Good Bot Handling** | Limited, mostly blocks                       | Can allowlist search engines, partner APIs                                   |
| **Flexibility**       | Simple, lightweight                          | Advanced, customizable enforcement                                           |
| **Use Case**          | Baseline protection against obvious bad bots | Comprehensive bot management for sensitive apps (login, checkout, APIs)      |

---

### **Best Practice**

* Use **WAF Signature-Based Bot Protection** as a **baseline layer** (blocks obvious noise).
* Enable **Bot Defense on HTTP LB** for **apps with high-value transactions** (logins, banking, e-commerce) where credential stuffing, scraping, or fraud is a concern.
