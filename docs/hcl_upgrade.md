# HCL2 Upgrade Notes

## References
- https://developer.hashicorp.com/packer/docs/commands/hcl2_upgrade

### Run upgrade command

```
find provider/ -type f -name "*.json" -exec packer hcl2_upgrade '{}' \;
```

### Fix filename extensions

```
find provider/ -type f -name "*.json.pkr.hcl" -exec rename '.json.' '.' '{}' \;
```

## Conversion Issues Noted

Failed to convert user defined variable from ``{{user `name`}}`` to `${var.name}` format.
```
{{user `build_accelerator`}}
```

Failed to convert variable build name to string
```
source "qemu" "{{user_`build_name`}}" {
```

The "execute_command" attribute of the "shell-local" is incorrectly converted to a string (which matches the requirements of the "shell" provisioner).
```
Incorrect attribute value
type; Inappropriate value for attribute "execute_command": list of string
required.
```

## Fix Issues

```
sed -i -r \
  -e 's~\{\{user `([^`]+)`\}\}~${var.\1}~g' \
  -e 's~\{\{user_`([^`]+)`\}\}~build~g' \
  -e 's~(\["source\.[^\.]+\.)\$\{var\.build_name\}("\])~\1build\2~g' \
  -e '/^  post-processor "shell-local" \{$/,/^  \}$/ s~^(    execute_command = )(".*")$~\1[\2]~' \
  -e '/^build \{/,/^  sources/ s~(^  sources =.*)$~  name    = "${var.build_name}"\n\1~' \
  -e 's~\{\{ \.BuildName \}\}~${var.build_name}~g' \
  provider/{libvirt,virtualbox}/*pkr.hcl
```

## Set up variables

```
sed -i -r \
  -e 's~^(  ")([^"]+)("): ("[^"]+"),?$~\2 = \4~' \
  -e '/^\{/d' \
  -e '/^\}/d' \
  *.json
```

### Fix filename extensions

```
find . -maxdepth 1 -type f -name "*.json" -exec rename '.json' '.pkrvars.hcl' '{}' \;
```

## Final clean up

```
find provider/ -type f -name "*.json" -delete
```
