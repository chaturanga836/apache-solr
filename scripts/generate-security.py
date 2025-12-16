#!/usr/bin/env python3
import os
import json
import base64
import hashlib
import secrets
import pwd
import sys

solr_user = os.environ.get("SOLR_USER", "solr")
solr_pass = os.environ.get("SOLR_PASS", "SolrRocks")
solr_role = os.environ.get("SOLR_ROLE", "administrator")

security_path = "/var/solr/data/security.json"

# DO NOT overwrite existing security.json
if os.path.exists(security_path):
    print("✔ security.json already exists, skipping generation")
    sys.exit(0)

salt = secrets.token_bytes(16)
salt_b64 = base64.b64encode(salt).decode()

hash1 = hashlib.sha256(salt + solr_pass.encode()).digest()
hash2 = hashlib.sha256(hash1).digest()
hash_b64 = base64.b64encode(hash2).decode()

security_json = {
    "authentication": {
        "blockUnknown": True,
        "class": "solr.BasicAuthPlugin",
        "credentials": {
            solr_user: f"{hash_b64} {salt_b64}"
        },
        "realm": "Ranger Solr users",
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

os.makedirs("/var/solr/data", exist_ok=True)
with open(security_path, "w") as f:
    json.dump(security_json, f, indent=2)

uid = pwd.getpwnam("solr").pw_uid
gid = pwd.getpwnam("solr").pw_gid
os.chown(security_path, uid, gid)

print("✅ security.json created safely")
