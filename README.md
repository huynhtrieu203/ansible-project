In order to run the code, follow the steps below:

Import the keypair "ansible_key.pem" in folder "Env".
Run terraform in Env folder using "terraform init" then "terraform apply" command.
Once the apply process is finished, replace the ansible_host varibles with your own ec2 dns.
Run the command "ansible-playbook playbook.yml -i inventory.txt".
Use the load balancer dns to access the website.
