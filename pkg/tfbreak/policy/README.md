# Breaking Change Policies

Conftest policies that identify breaking changes and deprecations.
Breaking changes are implemented as `deny` policies, because they have to be addressed before an update.
In contrast deprecations are implemented as `warn` policies.

## Expected input

The expected input is a JSON representation of a [JSON patch](https://www.rfc-editor.org/rfc/rfc6902) where
the "path" argument is represented as nested JSON object without indices with a meta key `_operation` mapping
to the original patch operation.

This means instead of a pure JSON patch as:
```json
{
    "op": "replace",
    "from": "",
    "path": "/variable/test/0/type",
    "oldValue": "${string}",
    "value": "${bool}"
}
```
We expect:
```json
{
    "variable": {
        "test": {
            "type": {
                "_operation": {
                    "op": "replace",
                    "from": "",
                    "path": "/variable/test/0/type",
                    "oldValue": "${string}",
                    "value": "${bool}"
                }
            }
        }
    }
}
```

This allows a more OPA native approach to verify the diff. To check if a variable `type` was changed we can just use the expression `input.variable[_].type`
instead of analysing the `path` attribute.