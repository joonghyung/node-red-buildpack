# Cloud Foundry Node-RED Buildpack

### Current architecuture of Node-RED on IBM Bluemix
 Single Node-RED instance has roles of both development environment(Editor) and flow execution environment(Runtime). Therefore developer and users access to single Node-RED instance. This architecute will be useful for PoC because developer easily modify the flow when user found flow bug or improvement. But it is unusural architecute on Cloud Foundry application.
![nodered-on-bluemix.png](nodered-on-bluemix.png)

### General deployment of application on Cloud Foundry
 In general, developers creates their code on thier local PC. After the coding, they deploy it into Cloud Foundry using cf push command.
![php-buildpack.png](php-buildpack.png)

### Deployment of Node-RED flow file using Node-RED buildpack

![node-red-buildpack.png](node-red-buildpack.png)

### How to deploy
#### (1) cf login -a <Cloud_Foundry_endpoint>
#### (2) cf push <application_name> -p <node-red_directory> -b https://github.com/zuhito/node-red-buildpack.git

### * Windows environment and Bluemix case
#### (1) Start Node-RED on local Windows PC
> node-red
#### (2) Create flow and hit deploy(Save flow into the following path automatically)
C:\Users\<user name>\.node-red\flows_<host name>.json
#### (3) Login to Bluemix
> cf login -a api.ng.bluemix.net
### (4) Deploy flow using Node-RED buildpack
cd C:\Users\<user name>\
cf push <application_name> -p <node-red directory> -b https://github.com/zuhito/node-red-buildpack.git

