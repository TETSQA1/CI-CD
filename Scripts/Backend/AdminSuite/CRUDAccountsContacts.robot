*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../Resources/BackendUtils/Accounts.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the user is able to add the contact for the account
    [Tags]  Add_contacts_accounts
    #Admin login
    ${Admin_token}=  Login as admin backend
    #Adding new account
    ${Contact_id}=  Add contacts for accounts    ${Admin_token}

Verify that the user is able to update the account contact
    [Tags]  Update_contacts_accounts
    #Admin login
    ${Admin_token}=  Login as admin backend
    #Adding new account
    ${Contact_id}=  Add contacts for accounts    ${Admin_token}
    #Updating the contacts
    Update contacts for accounts    ${Admin_token}    ${Contact_id}

Verify that the user is able to delete the account contact
    [Tags]  Delete_account_contact
    #Admin login
    ${Admin_token}=  Login as admin backend
    #Adding new account
    ${Contact_id}=  Add contacts for accounts    ${Admin_token}
    #Deleting the contact
    Delete account contact    ${Admin_token}    ${Contact_id}