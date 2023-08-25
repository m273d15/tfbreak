# TFBreak

A tool to detect syntactical breaking changes in Terraform modules.


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
