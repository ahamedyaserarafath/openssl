# Openssl key and csr generation



### Configure the openssl.conf file with your requirement, Sample openssl.conf file

    Country=GB
    State=London
    Location=London
    Organization_Name=GlobalSecurity
    Organizational_Unit_Name=ITDepartment
    Common_Name=example.com
    Email_address=root@example.com

-------

### How to run the openssl script file

Both openssl.sh and openssl.conf file should be in the same directory
 
    ./openssl.sh
    
The CSR and Key file will be stored inside the folder, the folder name will same as your domain name