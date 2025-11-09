#!/usr/bin/env python3
import os
import json
import base64
import hashlib
import secrets
import pwd

# Read env variables
solr_user = os.environ.get("SOLR_USER", "solr")
solr_pass = os.environ.get("SOLR_PASS", "SolrRocks")
solr_role = os.environ.get("SOLR_ROLE", "administrator")

salt_bytes = secrets.token_bytes(16)
salt_b64 = base64.b64encode(salt_bytes).decode()

# Compute hash: base64(sha256(sha256(salt+password)))
hash_bytes = hashlib.sha256(salt_bytes + solr_pass.encode()).digest()
double_hash = hashlib.sha256(hash_bytes).digest()
hash_b64 = base64.b64encode(double_hash).decode()

hashed_pass = f"{hash_b64} {salt_b64}"
    
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
solr_home = "/var/solr/data"
os.makedirs(solr_home, exist_ok=True)
security_path = os.path.join(solr_home, "security.json")
with open(security_path, "w") as f:
    json.dump(security_json, f, indent=4)

# Set ownership to solr user
uid = pwd.getpwnam("solr").pw_uid
gid = pwd.getpwnam("solr").pw_gid
os.chown(security_path, uid, gid)

print(f"✅ security.json generated at {solr_home}")
