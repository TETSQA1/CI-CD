*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../resources/BackendUtils/Accounts.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Variables ***
#Manually generate business identifier number in Spain using thirdparty tools (https://generator.avris.it/ES)
${business_identifier_Add}      65036421B
${business_identifier_Update}      F86601044

*** Test Cases ***
Verify that the user is able to create a new contract
    [Tags]  Adding_new_contract
    #Login as admin
    ${Admin_token}=     Login as admin backend
    #Adding new account
    ${Account_id}=   Add a new account details    ${Admin_token}    ${business_identifier_Add}
    #Adding new contract
    ${Contract_id}=  Add a new contract    ${Admin_token}    ${Account_id}

Verify that the user is able to update the contract
    [Tags]  Updating_contract
    #Login as admin
    ${Admin_token}=     Login as admin backend
    #Adding new account
    ${Account_id}=   Add a new account details    ${Admin_token}    ${business_identifier_Update}
    #Adding new contract
    ${Contract_id}=  Add a new contract    ${Admin_token}    ${Account_id}
    #Updating the contract
    Updating the contract    ${Admin_token}    ${Account_id}    ${Contract_id}