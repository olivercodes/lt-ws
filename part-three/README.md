1. install falco

helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

helm install --replace falco --namespace falco --create-namespace --set tty=true falcosecurity/falco

kubectl get pods -n falco

2. Add constraint template
3. Add constraint
4. Deploy deployment.yaml
5. Deploy deployment-working.yaml
