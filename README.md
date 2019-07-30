1. Make sure Java and ant are properly configured on your local machine
1. Install SFDC CLI
1. Create New Developer Org a. Go to https://developer.salesforce.com/signup.
1. Login into the Dev Org and enable Dev Hub

1. Authenticate with your hub org (if not already done)
    ```
    sfdx force:auth:web:login -d -a *your_hub_org*
    ```

1. Clone the purealoe repository:
    ```
    git clone https://github.com/mgrono/hckt19/
    ```

1. Create a scratch org and provide it with an alias (ex: purealoe):
    ```
    sfdx force:org:create -s -f config/project-scratch-def.json -a *purealoe*
    ```

1. Push the app to your scratch org:
    ```
    sfdx force:source:push
    ```

1. Reset Security Token
1. Update build.properties (add token to the password)

1. Encrypt password
    ```
    ant generateKeyAndEncryptPasswordAndEncryptPassword
    ```

1. Import sample data
    ```
    ant loadReservationsDataloadReservationsData
    ```	
