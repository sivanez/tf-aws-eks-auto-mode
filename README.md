1. Setup access key and secret via aws configure
2. Setup the necessary policies to the user
   - ec2*
   - eks*
   - AWSKeyManagementServicePowerUser
   - AmazonEKSClusterPolicy
   - CloudWatchLogsFullAccess
   - IAMFullAccess
3. Navigate tf folder and run
   - terraform init
   - teraform apply
4. Explore the EKS Auto Mode in Managed Console
5. Run 'terraform destroy' to destroy the resources to avoid charges.
