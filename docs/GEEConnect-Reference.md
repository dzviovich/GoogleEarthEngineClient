# GEEConnect

Authenticate with Google Earth Engine using a service account key file.

## Usage

```wolfram
GEEConnect[keyFile]
GEEConnect[keyFile, "Project" -> projectId]
```

## Details and Options

| Option | Default | Description |
|--------|---------|-------------|
| `"Project"` | `Automatic` | GCP project ID. Auto-detected from key file if `Automatic`. |

- `keyFile` must be a path to a valid service account JSON key file.
- The key file must contain `client_email`, `private_key`, and `project_id` fields.
- On success, stores the connection in `$GEEConnection` and returns a status Association with keys `"Project"`, `"Status"`, and `"Expiry"` (a `DateObject` in local time).
- The access token is automatically refreshed when it expires (1-hour lifetime).
- All other `GEE*` functions require `GEEConnect` to be called first.

## Examples

### Basic

```wolfram
GEEConnect["/path/to/service-account-key.json"]
(* <|"Project" -> "my-project", "Status" -> "Connected", "Expiry" -> ...| *)
```

### Explicit Project

```wolfram
GEEConnect["key.json", "Project" -> "my-other-project"]
```

## Possible Issues

- The service account must have the "Earth Engine Resource Viewer" IAM role.
- The Earth Engine API must be enabled in the GCP project.
- JWT signing requires Wolfram Language 13.0+ (`GenerateDigitalSignature`).

## See Also

`GEEGetAssetInfo`, `GEEImage`, `$GEEConnection`
