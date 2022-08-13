Ref: https://github.com/devbhusal/terraform-ansible-wordpress/blob/main/playbook_test.yml

In order to run the code, follow the steps below:
1.  Import the keypair in this folder to aws.
2.  Run terraform outside folder modules using "terraform init" then "terraform apply".
3.  Once the apply process is finished, replace the ansible_host varibles with your own ec2 dns.
    <img width="422" alt="image" src="https://user-images.githubusercontent.com/95838672/184501112-5dda29e7-40e2-4a19-8394-6dceaf60a2fb.png">
4.  Then run the command "ansible-playbook playbook.yml -i inventory.txt".
5.  Use the load balancer dns to access the website.  
