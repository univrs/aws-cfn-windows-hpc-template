# Docs

#####
Publishing files to 's3://windows-cfn-pmm/prod'

Publishing AWS Lambda function sources
  adding: find-image.js (deflated 61%)
upload: ./find-image.js.tmp to s3://windows-cfn-pmm/prod/lambda/find-image.zip
  adding: find-snapshot.js (deflated 58%)
upload: ./find-snapshot.js.tmp to s3://windows-cfn-pmm/prod/lambda/find-snapshot.zip

Publishing PowerShell Scripts
upload: ./add-admin-user.ps1 to s3://windows-cfn-pmm/prod/cfn-init/add-admin-user.ps1
upload: ./change-administrator-password.ps1 to s3://windows-cfn-pmm/prod/cfn-init/change-administrator-password.ps1
upload: ./compute-metrics.ps1 to s3://windows-cfn-pmm/prod/cfn-init/compute-metrics.ps1
upload: ./configure-dc-network.ps1 to s3://windows-cfn-pmm/prod/cfn-init/configure-dc-network.ps1
upload: ./configure-hpc-network.ps1 to s3://windows-cfn-pmm/prod/cfn-init/configure-hpc-network.ps1
upload: ./configure-member-network.ps1 to s3://windows-cfn-pmm/prod/cfn-init/configure-member-network.ps1
upload: ./create-hpc-user.ps1 to s3://windows-cfn-pmm/prod/cfn-init/create-hpc-user.ps1
upload: ./dc-promo.ps1 to s3://windows-cfn-pmm/prod/cfn-init/dc-promo.ps1
upload: ./initialize-d-drive.ps1 to s3://windows-cfn-pmm/prod/cfn-init/initialize-d-drive.ps1
upload: ./install-hpc-pack-compute.ps1 to s3://windows-cfn-pmm/prod/cfn-init/install-hpc-pack-compute.ps1
upload: ./install-hpc-pack-head.ps1 to s3://windows-cfn-pmm/prod/cfn-init/install-hpc-pack-head.ps1
upload: ./install-process-compute.ps1 to s3://windows-cfn-pmm/prod/cfn-init/install-process-compute.ps1
upload: ./install-process-head.ps1 to s3://windows-cfn-pmm/prod/cfn-init/install-process-head.ps1
upload: ./join-domain.ps1 to s3://windows-cfn-pmm/prod/cfn-init/join-domain.ps1
upload: ./post-install-hpc-pack-compute.ps1 to s3://windows-cfn-pmm/prod/cfn-init/post-install-hpc-pack-compute.ps1
upload: ./post-install-hpc-pack-head.ps1 to s3://windows-cfn-pmm/prod/cfn-init/post-install-hpc-pack-head.ps1
upload: ./rename-computer.ps1 to s3://windows-cfn-pmm/prod/cfn-init/rename-computer.ps1
upload: ./wait-dc-services-ready.ps1 to s3://windows-cfn-pmm/prod/cfn-init/wait-dc-services-ready.ps1

Publishing Configuration Files
upload: ./cfn-auto-reloader.conf to s3://windows-cfn-pmm/prod/cfn-init/cfn-auto-reloader.conf
upload: ./cfn-hup.conf to s3://windows-cfn-pmm/prod/cfn-init/cfn-hup.conf
upload: ./domain-info.conf to s3://windows-cfn-pmm/prod/cfn-init/domain-info.conf
upload: ./hpc-user-info.conf to s3://windows-cfn-pmm/prod/cfn-init/hpc-user-info.conf
upload: ./local-admin-password.conf to s3://windows-cfn-pmm/prod/cfn-init/local-admin-password.conf
upload: ./sql-config.conf to s3://windows-cfn-pmm/prod/cfn-init/sql-config.conf

Publishing AWS CloudFormation templates
upload: ./main.json.tmp to s3://windows-cfn-pmm/prod/main.json

Publishing AWS CloudFormation sub stacks
upload: ./1-core.json.tmp to s3://windows-cfn-pmm/prod/cfn/1-core.json
upload: ./2-cluster.json.tmp to s3://windows-cfn-pmm/prod/cfn/2-cluster.json
upload: ./tool-find-image.json.tmp to s3://windows-cfn-pmm/prod/cfn/tool-find-image.json
upload: ./tool-find-snapshot.json.tmp to s3://windows-cfn-pmm/prod/cfn/tool-find-snapshot.json
Start the cluster by using the 'https://windows-cfn-pmm.s3.amazonaws.com/prod/main.json' AWS CloudFormation Stack
