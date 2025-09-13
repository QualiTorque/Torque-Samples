package torque.environment

import future.keywords.if

result := { 
    "decision": "Denied",
    "reason": sprintf("Input data: %s", [json.marshal(input)]) 
}