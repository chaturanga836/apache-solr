#!/usr/bin/env python3
import os
import json
import base64

# Read env variables
solr_user = os.environ.get("SOLR_USER", "solr")
solr_pass = os.environ.get("SOLR_PASS", "SolrRocks")
solr_role = os.environ.get("SOLR_ROLE", "administrator")

# Encode password as Solr BasicAuth hash (base64 placeholder)
def encode_solr_pass(password):
    # Solr expects a hashed string; for simplicity, we use base64 here
    # For production, you may precompute Solr hashes using solr auth tool
    return base64.b64encode(password.encode()).decode()

hashed_pass = encode_solr_pass(solr_pass)

security_json = {
    "authentication": {
        "blockUnknown": True,
        "class": "solr.BasicAuthPlugin",
        "credentials": {solr_user: hashed_pass},
        "realm": "Lab Solr users",
        "forwardCredentials": False
    },
    "authorization": {
        "class": "solr.RuleBasedAuthorizationPlugin",
        "permissions": [
            {"name": "all", "role": solr_role}
        ],
        "user-role": {
            solr_user: solr_role
        }
    }
}

# Write security.json
solr_home = "/var/solr/security.json"
with open(solr_home, "w") as f:
    json.dump(security_json, f, indent=4)

print(f"✅ security.json generated at {solr_home}")
