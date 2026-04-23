# F5 XC Regional Edge (RE) and Customer Edge (CE) Load Balancer with WAAP, Bot Defense, and CDN

This example demonstrates how to deploy a simple application on a Customer Edge (CE) site and protect it with F5 XC WAAP (Web Application and API Protection) and CDN caching enabled directly on the HTTP Load Balancer at the Regional Edge (RE).

As of the April 12, 2026 F5XC platform release, CDN caching can be enabled directly on the HTTP Load Balancer using the `caching_policy` attribute, eliminating the need for a separate CDN Load Balancer, CDN origin pool, and routing workaround that was previously required.

## Prerequisites

- F5 XC Tenant
- F5 XC API Certificate
- An existing CE site deployed and registered
- Terraform Cloud or Terraform CLI

## Provider Requirements

| Name | Version |
|------|---------|
| volterra | 0.11.49 |

## Files

*   `1-origin.tf`: This file defines the origin pool pointing to the CE site private IP.
*   `2-waap-policy.tf`: This file defines the WAAP policy that will be applied to the load balancer.
*   `3-cdn-rules.tf`: This file defines the CDN cache rules (referenced by the HTTP LB `caching_policy`).
*   `5-https-lb.tf`: This file defines the HTTP load balancer itself, including the domain, HTTPS configuration, WAAP policy, and CDN caching policy.
*   `provider.tf`: This file defines the Volterra provider.
*   `variables.tf`: This file defines the variables used in the Terraform configuration.
*   `terraform.tfvars`: This file should be created by the user to provide values for the variables defined in `variables.tf`.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `f5xc_api_url` | F5 XC API URL | `string` | n/a | yes |
| `f5xc_tenant` | F5 XC Tenant Name | `string` | n/a | yes |
| `f5xc_namespace` | F5 XC Namespace | `string` | `"default"` | no |
| `f5xc_api_p12_file` | Path to F5 XC API Certificate File | `string` | n/a | yes |
| `app_domain` | Application Domain | `string` | n/a | yes |
| `site_name` | F5 XC CE Site Name | `string` | n/a | yes |

## How to run

1. Clone the repository.
2. `cd examples/re-ce-lb-waap-bot-cdn`
3. Create a `terraform.tfvars` file and populate it with the required variables.
4. `terraform init`
5. `terraform plan`
6. `terraform apply`

## Verification

1. Access the application using the load balancer domain.
2. Verify that the application is accessible.
3. Verify that the WAAP policy is enforced.
4. Verify that the CDN is caching the static content (check CDN cache rules in F5XC console).

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

---

## CDN Caching Flow (April 2026+ Simplified Architecture)

With the April 2026 platform update, CDN caching is now configured directly on the HTTP Load Balancer via the `caching_policy` attribute. This eliminates the previous architecture that required a separate CDN Load Balancer, CDN origin pool, and L7 routing workaround.

### Previous Architecture (Deprecated)

The old approach required:
1. A separate `volterra_cdn_loadbalancer` resource
2. A dedicated CDN origin pool pointing to the CDN LB domain
3. L7 routes on the HTTP LB to forward static content to the CDN origin
4. Traffic flowing through an extra hop: HTTP LB → CDN origin pool → CDN LB → origin

### Current Architecture (Simplified)

The new approach uses a single `caching_policy` block on the HTTP Load Balancer:

```
caching_policy {
    default_cache_action {
        cache_ttl_default = "3600s"    # Respect origin headers, fallback to 1h
    }
    custom_cache_rule {
        cdn_cache_rules { ... }        # Reference to volterra_cdn_cache_rule objects
    }
}
```

### How It Works

1. **Client → HTTP Load Balancer (WAAP)**
   - The client sends a request to the HTTP LB endpoint on the F5XC Regional Edge (RE).
   - SSL decryption occurs, and WAAP security policies (WAF, DDoS) are applied.

2. **CDN Cache Evaluation**
   - The HTTP LB evaluates the request against the configured `caching_policy`.
   - Custom cache rules determine cacheability based on path patterns (e.g., CSS/JS files cached for 1 day, images for 7 days).
   - Bypass rules prevent caching of dynamic paths (e.g., `/acs/`, `/api/`).

3. **Cache Decision**
   - **Cache Hit:** The cached content is served directly from the CDN edge, without reaching the CE origin.
   - **Cache Miss:** The request is forwarded to the CE origin pool (private IP on the CE site), and the response is cached per the cache rules.

4. **HTTP LB → Client**
   - The response is returned to the client, whether from cache or origin.

### Flow Summary

| Request Type | Flow |
|-------------|------|
| **Cacheable content (cache hit)** | `Client → HTTP LB (CDN cache) → Client` |
| **Cacheable content (cache miss)** | `Client → HTTP LB → CE Origin → HTTP LB (cache + respond) → Client` |
| **Non-cacheable / bypass** | `Client → HTTP LB → CE Origin → Client` |

### Limitations

- CDN caching is only supported on HTTPS-serving HTTP Load Balancers (not HTTP-only)
- Mutual TLS (mTLS) configurations are incompatible with CDN caching
- Source IP stickiness cannot be used simultaneously with CDN caching
- HTTP/2.0-only deployments are not supported

### Key Takeaways

- **No separate CDN LB required** -- caching is handled directly by the HTTP LB.
- **CDN cache rules** (`volterra_cdn_cache_rule`) are still used for fine-grained control and referenced via `caching_policy.custom_cache_rule`.
- **Simplified routing** -- no need for L7 routes to forward static content to a CDN origin pool.
- All traffic benefits from the **full security stack** (WAAP, DDoS) regardless of caching.
- The CE origin is accessed via private IP through the site, keeping backend traffic off the public internet.
