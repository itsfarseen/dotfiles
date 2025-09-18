#!/usr/bin/python3
# Workaround for the crappy nix conf format that won't even allow me to split a config across multiple lines

keys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=",
    "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo=",
    "liqwid.cachix.org-1:NTIoFirJofiCSU9Khv0jSoxvYguYXesa7slQ0+f8r3M=",
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=",
    "mlabs.cachix.org-1:gStKdEqNKcrlSQw5iMW6wFCj3+b+1ASpBVY2SYuNV2M=",
    "public-plutonomicon.cachix.org-1:3AKJMhCLn32gri1drGuaZmFrmnue+KkKrhhubQk/CWc=",
    "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo=",
    "plutonomicon.cachix.org-1:evUxtNULjCjOipxwAnYhNFeF/lyYU1FeNGaVAnm+QQw=",
]

substituters = []
for key in keys:
    sub = "https://" + key.split(":")[0]
    if sub.endswith("-1"):
        sub = sub[:-2]
    if sub in substituters:
        continue
    substituters.append(sub)

print()
trusted_public_keys = "trusted-public-keys = " + " ".join(keys)
print(trusted_public_keys)
trusted_substituters = "trusted-substituters = " + " ".join(substituters)
print(substituters)
print()

with open("/etc/nix/nix.conf", "r") as f:
    lines = []
    for line in f:
        if line.startswith("trusted-substituters") or line.startswith("trusted-public-keys"):
            continue
        lines.append(line)
    lines.append(trusted_public_keys + "\n")
    lines.append(trusted_substituters + "\n")

with open("/tmp/nix.conf", "w") as f:
    f.writelines(lines)

print("Run the following to apply the new config:")
print("\tsudo mv /tmp/nix.conf /etc/nix/nix.conf")
