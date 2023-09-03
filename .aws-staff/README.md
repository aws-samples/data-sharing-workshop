## Helper scripts for AWS Staff facilitating the workshop

### Validating/checking participants steps

* `check-01-init.sh` - checks the data files are in s3 and soem of the environment variables are set
* `check-02-lf-setup.sh` - checks the participant has setup Lake Formation correctly
* `check-03-glue.sh` - checks the files have been catalogued in Glue/Lake Formation

### The switching roles and querying section

* `check-04-lf-perms.sh` - counts the number of Lake formation permissions, to help check the are in place so that the switching of roles to campaign manager and developer is likely to work ok

### The cross account sharing activities

* `check-05-ram-shares.sh` - checks there are 4 active RAM shares as expected
* `check-06-xacct.sh` - checks the Lake Formation cross account permissions are setup to allow cross account sharing

### Sharing the summary tables with a central account

* `check-07-central.sh` - checks the Lake Formation cross account permissions are setup to allow sharing with the central account

----
-----

## Building scripts 

These are intended for facilitators to quickly build tghe workshop, or to help participants who get stuck to catch up:

* `01-c9setup.sh` - setup the Cloud9 IDE 
* `02-tfinit.sh` - setup the inital resources
* `03-lf.sh` - automatically configure Lake Formation correctly
* `04-perms.sh` - setup the permissions for querying data by admin, campain manager & developer
* `05-xacct.sh` - setup Lake Froormation for cross-account sharing

-----

* `06-resource-links.sh` - don't use still testing