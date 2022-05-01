# tf-solr-cluster
Solr cluster with 3 servers and 3 zookeepers


1. The first thing to do is run ```terraform apply``` to create the S3 backend to store the Terraform state. Run this only once.

<img width="963" alt="image" src="https://user-images.githubusercontent.com/3796667/166132880-cf9ad5be-4e65-47e6-b3b8-0b17a8d7dab3.png">


2. Run ```terraform apply``` to create the VPC. The Terraform state is stored in S3 in the bucket created in step 1.

<img width="963" alt="image" src="https://user-images.githubusercontent.com/3796667/166132954-6faa8249-fe99-4b94-ac1b-e25b6afacaec.png">

3. Run ```terraform apply``` to create the Solr cloud with 3 servers and 3 Zookeepers. Make adjustments as needed. 

<img width="988" alt="image" src="https://user-images.githubusercontent.com/3796667/166133000-967800e5-7f44-4fd2-ab9e-d18bd81f8c8d.png">
