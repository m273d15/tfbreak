# TFBreak

This tool helps you to detect breaking changes in Terraform modules and keep track of deprecated variables/outputs.

## Breaking Change Detection

You run `tfbreak` and it tells you if you changed your modules signature.
Supported rules so far are:
- Required Terraform version has changed
- Variables
  - A variable was removed
  - A mandatory variable was added
  - A variable type was changed
  - A variable's default value changed (limited since it does not evaluate expression)
- Outputs
  - An output was removed
  - An output type was changed

See [`pkg/tfbreak/policy/breaking.rego`](pkg/tfbreak/policy/breaking.rego) for the implementation details.

## Deprecation Warning

You run `tfbreak` and it warns you about all variables/outputs with a deprecation marker (see the `--deprecation-marker` option).

## Usage

Run for example:
```
tfbreak \
  -o git::https://github.com/me/my-tf-module?ref=main \
  -n git::https://github.com/me/my-tf-module?ref=my-pr-branch`
```
to see if your branch introduces new syntactical breaking before merging it.

### Help
```
Usage:
  tfbreak [OPTIONS]

Application Options:
  -o, --old-src=            Old hcl2 code path.
  -n, --new-src=            New hcl2 code path.
      --workdir=            Workdir used to copy the source to (default: '$PWD/.temp_hcl2diff')
      --deprecation-marker= Text in a variable/output description that highlights a deprecation. (default: [Deprecated])

Help Options:
  -h, --help                Show this help message
```
