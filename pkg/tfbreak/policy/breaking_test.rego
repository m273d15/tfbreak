package main

import future.keywords

# TODO: Add positive tests if nothing is violated.
# TODO: Fix after rename and externalisation of deprecation marker

test_deprecate_if_descripition_contains_deprecation_marker if {
	# Fix test input (path does not match the variable name in json)
	deprecated_var := {"variable": {"bla": {"description": {"_operation": {"op": "replace", "from": "", "path": "/variable/test/0/type", "oldValue": "test", "value": "[Deprecated] test"}}}}}
	msgs := deprecate_if_variable_description_contains_deprecation_marker with input as deprecated_var
		with data.config as {"deprecation_marker": "[Deprecated]"}
	count(msgs) == 1
}

test_break_if_variable_was_removed if {
	removed_var := {"variable": {"bla": {"_operation": {"op": "remove", "from": "", "path": "/variable/test/0/type", "oldValue": [{"default": null, "description": "test", "type": "${string}"}], "value": null}}}}
	msgs := break_if_variable_was_removed with input as removed_var
		with data.config as {"deprecation_marker": "[Deprecated]"}
	count(msgs) == 1
}

test_break_if_variable_type_has_changed if {
	changed_type := {"variable": {"test": {"type": {"_operation": {"op": "replace", "from": "", "path": "/variable/test/0/type", "oldValue": "${string}", "value": "${bool}"}}}}}
	msgs := break_if_variable_type_has_changed with input as changed_type
		with data.config as {"deprecation_marker": "[Deprecated]"}
	count(msgs) == 1
}

test_break_if_variable_type_has_changed_due_to_formatting if {
	old_type := `${list(object({
    key1   = string
    key2= string
  }))}`
	new_type := `${list(object({
    key1 = string
    key2 = string
  }))}`
	changed_type := {"variable": {"test": {"type": {"_operation": {"op": "replace", "from": "", "path": "/variable/test/0/type", "oldValue": old_type, "value": new_type}}}}}
	msgs := break_if_variable_type_has_changed with input as changed_type
		with data.config as {"deprecation_marker": "[Deprecated]"}
	count(msgs) == 0
}

test_break_if_mandatory_variable_was_added if {
	changed_type := {"variable": {"default": {"_operation": {"op": "add", "from": "", "path": "/variable/default", "oldValue": null, "value": [{"description": "test", "type": "${string}"}]}}}}
	msgs := break_if_mandatory_variable_was_added with input as changed_type
		with data.config as {"deprecation_marker": "[Deprecated]"}
	count(msgs) == 1
}

test_break_if_mandatory_variable_was_added_with_optional_variable if {
	changed_type := {"variable": {"default": {"_operation": {"op": "add", "from": "", "path": "/variable/default", "oldValue": null, "value": [{"default": "something", "description": "test", "type": "${string}"}]}}}}
	msgs := break_if_mandatory_variable_was_added with input as changed_type
		with data.config as {"deprecation_marker": "[Deprecated]"}
	count(msgs) == 0
}
