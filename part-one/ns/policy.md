

## Module 1 - Policy as Code

First steps

1. Connect to K8s cluster
2. Install OPA Gatekeeper

kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/release-3.17/deploy/gatekeeper.yaml


### Verify gatekeeper install worked.

Deploy a simple constraint template
https://open-policy-agent.github.io/gatekeeper/website/docs/howto#constraint-templates
`k apply -f simple-constraint-template.yaml`

``` yaml
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8srequiredlabels
spec:
  crd:
    spec:
      names:
        kind: K8sRequiredLabels
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          properties:
            labels:
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8srequiredlabels

        violation[{"msg": msg, "details": {"missing_labels": missing}}] {
          provided := {label | input.review.object.metadata.labels[label]}
          required := {label | label := input.parameters.labels[_]}
          missing := required - provided
          count(missing) > 0
          msg := sprintf("you must provide labels: %v", [missing])
        }
```

Deploy a simple Constraint:
https://open-policy-agent.github.io/gatekeeper/website/docs/howto#constraints

`k apply -f simple-constraint.yaml`

``` yaml
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sRequiredLabels
metadata:
  name: ns-must-have-gk
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Namespace"]
  parameters:
    labels: ["admission"]
```

Now try to deploy a namespace
`k create ns will-be-denied`

This should be declined, with a useful error message.
`k apply -f ns-with-no-label`
