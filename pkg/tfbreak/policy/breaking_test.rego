package main

# TODO: Add positive tests if nothing is violated.
# TODO: Fix after rename and externalisation of deprecation marker

test_warn_if_descripition_contains_deprecation_marker {
	# Fix test input (path does not match the variable name in json)
	deprecated_var := {"variable": {"bla": {"description": {"_operation": {"op": "replace", "from": "", "path": "/variable/test/0/type", "oldValue": "test", "value": "[Deprecated] test"}}}}}
	msgs := warn_if_variable_description_contains_deprecation_marker with input as deprecated_var
	count(msgs) == 1
}

test_deny_if_variable_was_removed {
	removed_var := {"variable": {"bla": {"_operation": {"op": "remove", "from": "", "path": "/variable/test/0/type", "oldValue": [{"default": null, "description": "test", "type": "${string}"}], "value": null}}}}
	msgs := deny_if_variable_was_removed with input as removed_var
	count(msgs) == 1
}

test_deny_if_variable_type_has_changed {
	changed_type := {"variable": {"test": {"type": {"_operation": {"op": "replace", "from": "", "path": "/variable/test/0/type", "oldValue": "${string}", "value": "${bool}"}}}}}
	msgs := deny_if_variable_type_has_changed with input as changed_type
	count(msgs) == 1
}

test_deny_if_mandatory_variable_was_added {
	changed_type := {"variable": {"default": {"_operation": {"op": "add", "from": "", "path": "/variable/default", "oldValue": null, "value": [{"description": "test", "type": "${string}"}]}}}}
	msgs := deny_if_mandatory_variable_was_added with input as changed_type
	count(msgs) == 1
}

test_deny_if_mandatory_variable_was_added_with_optional_variable {
	changed_type := {"variable": {"default": {"_operation": {"op": "add", "from": "", "path": "/variable/default", "oldValue": null, "value": [{"default": "something", "description": "test", "type": "${string}"}]}}}}
	msgs := deny_if_mandatory_variable_was_added with input as changed_type
	count(msgs) == 0
}
