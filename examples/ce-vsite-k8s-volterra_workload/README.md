# F5XC Volterra Workload Manager

This directory contains a Python script and unit tests for managing F5XC Volterra Workloads via the API.

## Prerequisites

1.  **Virtual Environment**: Ensure the project's virtual environment is activated.
    ```bash
    source f5xc-lb-waap-examples/bin/activate
    ```
2.  **Environment Variables**: Set the following environment variables for authentication:
    *   `TF_VAR_f5xc_api_p12_file`: Path to your F5XC API P12 certificate file.
    *   `VES_P12_PASSWORD`: Password for the P12 certificate.

## Usage

The script `workload_manager.py` provides a `VolterraWorkloadManager` class that can be used to create and get workloads.

### Running the Script

You can run the script directly to create a sample workload based on the parameters provided in the task.

```bash
cd examples/ce-vsite-k8s-volterra_workload/script
python workload_manager.py
```

### Script Parameters

The `if __name__ == "__main__":` block in `workload_manager.py` contains the following default parameters:
- `f5xc_api_url`: `https://f5-amer-ent.console.ves.volterra.io/api`
- `f5xc_tenant`: `f5-amer-ent`
- `f5xc_namespace`: `h-valbuena`
- `workload_name`: `f5-ai-app-az-tf`
- `image_name`: `appworldregistry-c8gwcthfcvfnevfq.azurecr.io/ai-generated-app:latest`
- `site_name`: `hv-aws-us-east-1-ce`
- `container_registry_name`: `h-valbuena-acr`
- `port`: `5000`

### Example Code Snippet

```python
from workload_manager import VolterraWorkloadManager

api_url = "https://your-tenant.console.ves.volterra.io/api"
tenant = "your-tenant"
namespace = "your-namespace"

manager = VolterraWorkloadManager(api_url, tenant, namespace)

# Create a workload
result = manager.create_workload(
    name="my-workload",
    image="my-image:latest",
    site_name="my-ce-site",
    port=8080,
    container_registry_name="my-acr"
)

# Get a workload
workload_details = manager.get_workload("my-workload")
```

## Running Tests

Unit tests are provided using `pytest` and `requests-mock`.

```bash
cd examples/ce-vsite-k8s-volterra_workload/script
pytest test_workload_manager.py
```
