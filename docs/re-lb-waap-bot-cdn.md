# RE WAAP, Bot Defense and CDN Example

This example shows how to create an HTTP Load Balancer on a Regional Edge (RE) site with a Web Application Firewall (WAF), Bot Defense, and a Content Delivery Network (CDN).

## Prerequisites

Before running this example, you must create a `terraform.tfvars` file in the `examples/re-lb-waap-bot-cdn` directory with your F5XC tenant credentials. You can use the `terraform.tfvars.example` file in the same directory as a template.

## Files

*   `1-origin.tf`: This file defines the origin pool, which is a group of servers that will handle the traffic for the load balancer.
*   `2-waap-policy.tf`: This file defines the WAAP policy that will be applied to the load balancer.
*   `3-cdn-rules.tf`: This file defines the CDN cache rules.
*   `4-cdn-lb.tf`: This file defines the CDN load balancer.
*   `5-https-lb.tf`: This file defines the HTTP load balancer itself, including the domain, HTTPS configuration, WAAP policy, bot defense, CDN route, and default route to the origin pool.
*   `provider.tf`: This file defines the Volterra provider.
*   `variables.tf`: This file defines the variables used in the Terraform configuration.
*   `terraform.tfvars`: This file should be created by the user to provide values for the variables defined in `variables.tf`.

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

**Reference:** [F5XC WAAP WAF protection docs](https://docs.cloud.f5.com/docs-v2/security/waap/waap-overview).

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

**Reference:** [F5XC Bot Defense docs](https://docs.cloud.f5.com/docs-v2/security/bot-defense/overview).

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
