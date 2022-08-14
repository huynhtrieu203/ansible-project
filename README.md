In order to run the code, follow the steps below:
1.  Import the keypair "ansible_key.pem" in folder "Env".
2.  Run terraform in Env folder using "terraform init" then "terraform apply" command.
3.  Once the apply process is finished, replace the ansible_host varibles with your own ec2 dns.
4.  Run the command "ansible-playbook playbook.yml -i inventory.txt".
5.  Use the load balancer dns to access the website.  
