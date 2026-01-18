#!/usr/bin/env bash
###############################################################################
# Script Name : generate_volterra_schemas.sh
#
# OBJECTIVE
# -----------------------------------------------------------------------------
# This script automates the extraction of Terraform provider resource schemas
# for the F5 Distributed Cloud (volterraedge/volterra) provider.
#
# It performs the following actions:
#   1. Runs `terraform providers schema -json` once.
#   2. Uses jq to discover ALL resource schema names via:
#        .provider_schemas["registry.terraform.io/volterraedge/volterra"]
#          .resource_schemas | keys[]
#   3. Extracts each individual resource schema.
#   4. Stores each schema as JSON under:
#        schemas/<provider-version>/<resource-name>.json
#   5. Prints the volterraedge/volterra provider version used.
#
###############################################################################
#
# HOW TO USE
# -----------------------------------------------------------------------------
# 1. Ensure the following tools are installed and available in PATH:
#      - terraform
#      - jq
#
# 2. From the repo root, make sure Terraform is initialized:
#      terraform init
#
# 3. Run the script from the scripts directory, passing the provider version:
#
#      ./generate_volterra_schemas.sh 0.11.45
#
# 4. Generated schemas will be found in:
#      schemas/0.11.45/*.json
#
###############################################################################

set -euo pipefail

# -----------------------------------------------------------------------------
# Require volterraedge/volterra Provider Version as Argument
# -----------------------------------------------------------------------------
if [[ $# -lt 1 ]]; then
  echo "ERROR: Missing required argument: <volterraedge-volterra-provider-version>"
  echo "Usage: $0 <volterraedge-volterra-provider-version>"
  exit 1
fi

PROVIDER_VERSION="$1"

# -----------------------------------------------------------------------------
# Path Resolution
# -----------------------------------------------------------------------------
#SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#REPO_ROOT="${SCRIPT_DIR}/.."
#SCHEMAS_ROOT="${REPO_ROOT}/schemas"
#TARGET_DIR="${SCHEMAS_ROOT}/${PROVIDER_VERSION}"

SCRIPT_DIR="/Users/h.valbuena/Documents/Dev/github/f5xc_terraform/f5xc-lb-waap-examples/scripts"
REPO_ROOT="/Users/h.valbuena/Documents/Dev/github/f5xc_terraform/f5xc-lb-waap-examples/examples/re-lb-basic"
SCHEMAS_ROOT="/Users/h.valbuena/Documents/Dev/github/f5xc_terraform/f5xc-lb-waap-examples/schemas"
TARGET_DIR="${SCHEMAS_ROOT}/${PROVIDER_VERSION}"


# Create version folder if it does not exist
mkdir -p "$TARGET_DIR"

echo "Using volterraedge/volterra provider version: ${PROVIDER_VERSION}"
echo "Schema output directory: ${TARGET_DIR}"

# -----------------------------------------------------------------------------
# Validation Checks
# -----------------------------------------------------------------------------
command -v terraform >/dev/null 2>&1 || {
  echo "ERROR: terraform binary not found in PATH"
  exit 1
}

command -v jq >/dev/null 2>&1 || {
  echo "ERROR: jq binary not found in PATH"
  exit 1
}

# -----------------------------------------------------------------------------
# Generate Provider Schema (Single Execution)
# -----------------------------------------------------------------------------
cd "$REPO_ROOT"

if [[ ! -d ".terraform" ]]; then
  echo "ERROR: Terraform is not initialized in repo root (${REPO_ROOT})."
  echo "Run 'terraform init' there first."
  exit 1
fi

PROVIDER_SCHEMA_JSON="${TARGET_DIR}/_providers-schema-${PROVIDER_VERSION}.json"

echo "Running terraform providers schema -json ..."
terraform providers schema -json > "$PROVIDER_SCHEMA_JSON"

# -----------------------------------------------------------------------------
# Discover Resource Schema Names (no mapfile, portable)
# -----------------------------------------------------------------------------
echo "Discovering volterraedge/volterra resource schema names via jq ..."

resource_count=0

# jq prints one resource name per line; we stream them into a while loop
jq -r '
  .provider_schemas["registry.terraform.io/volterraedge/volterra"]
  .resource_schemas
  | keys[]
' "$PROVIDER_SCHEMA_JSON" | while IFS= read -r raw_resource; do
  # Sanitize: remove whitespace/control chars from the resource name
  resource="${raw_resource//[$' \t\r\n']/}"

  if [[ -z "$resource" ]]; then
    echo "WARNING: Skipping empty/invalid resource name (raw: '$raw_resource')"
    continue
  fi

  resource_count=$((resource_count + 1))

  OUTPUT_FILE="${TARGET_DIR}/${resource}.json"
  echo "Extracting schema for resource: ${resource}"

  jq --arg res "$resource" \
    '.provider_schemas["registry.terraform.io/volterraedge/volterra"].resource_schemas[$res]' \
    "$PROVIDER_SCHEMA_JSON" > "$OUTPUT_FILE"
done

echo "Schema generation complete."
echo "volterraedge/volterra provider version: ${PROVIDER_VERSION}"
echo "Output location: ${TARGET_DIR}"
