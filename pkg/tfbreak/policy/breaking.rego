package main

import future.keywords.contains
import future.keywords.if

import input as patches
import data.config


# TODO: Redude redundancy


deprecate_if_variable_description_contains_deprecation_marker contains msg if {
  c := patches.variable[var_name]
  op := c.description._operation
  contains(op.value, config.deprecation_marker)
  msg := sprintf("Variable '%s' was marked as '%s'.", [var_name, config.deprecation_marker])
}

deprecate_if_output_description_contains_deprecation_marker contains msg if {
  c := patches.output[out_name]
  op := c.description._operation
  contains(op.value, config.deprecation_marker)
  msg := sprintf("Output '%s' was marked as '%s'.", [out_name, config.deprecation_marker])
}

break_if_requirements_changed contains msg if {
  patches.terraform.required_version._operation
  msg := "terraform.required_version has changed."
}

break_if_variable_was_removed contains msg {
  c := patches.variable[name]
  c._operation.op == "remove"
  msg := sprintf("Variable '%s' was removed.", [name])
}

break_if_mandatory_variable_was_added contains msg {
  c := patches.variable[name]
  c._operation.op == "add"

  c._operation.value[var_config]
  not c._operation.value[var_config]["default"]
  msg := sprintf("New mandatory variable '%s' was added.", [name])
}

# Split to three cases (replace, add, remove)
break_if_variable_type_has_changed contains msg {
  c := patches.variable[name]
  type := c.type._operation.value
  msg := sprintf("Type of variable '%s' changed to '%s'.", [name, type])
}

break_if_output_type_has_changed contains msg {
  c := patches.output[name]
  type := c.type._operation.value
  msg := sprintf("Type of output '%s' changed to '%s'.", [name, type])
}

break_if_variable_default_has_changed contains msg {
  c := patches.variable[name]
  oldDef := c["default"]._operation.oldValue
  def := c["default"]._operation.value
  msg := sprintf("Default value of variable '%s' changed from %s to '%s'.", [name, oldDef, def])
}

break_if_output_was_removed contains msg {
  c := patches.output[name]
  c._operation.op == "remove"
  msg := sprintf("Output '%s' was removed.", [name])
}
