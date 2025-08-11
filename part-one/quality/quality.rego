package test

# http.send request passing our input data could go here

default deny := false

deny if code_coverage_lt_required

code_coverage_lt_required if {
 data.code_quality_attributes[input.request.object.metadata.sha].coverage < 80
}
