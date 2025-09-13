package torque.environment

import future.keywords.if

has_key(x, k) { 
  _ = x[k]
}

# Check if there's an input with specified name and value from policy data
has_restricted_input {
  input.inputs[_].name == data.restricted_input_name
  input.inputs[_].value == data.restricted_input_value
}

result := { "decision": "Denied", "reason": sprintf("Environment with duration cannot be launched when input '%s' has value '%s'", [data.restricted_input_name, data.restricted_input_value]) } if {
  has_key(input, "duration_minutes")
  has_restricted_input
}

result := { "decision": "Approved" } if {
  not has_key(input, "duration_minutes")
}

result := { "decision": "Approved" } if {
  has_key(input, "duration_minutes")
  not has_restricted_input
}