#Only run when building
cd lambda
npm run package
cd ..

cd scripts/dev

# Destroy infra
terraform destroy -auto-approve

# Start running deployment
terraform init
terraform plan
terraform apply -auto-approve
