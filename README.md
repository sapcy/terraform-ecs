# terraform-ecs
테라폼 통해 ECS 클러스터(with EC2) 배포

## 배포
```bash
terraform apply -var-file="values.tfvars"
```

## 삭제
```bash
terraform destroy -var-file="values.tfvars"
```