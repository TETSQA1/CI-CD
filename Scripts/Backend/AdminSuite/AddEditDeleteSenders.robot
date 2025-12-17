*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot
Resource    ../../Resources/BackendUtils/Senders.robot

*** Test Cases ***
Verify that the user is able to add a sender
    [Tags]  Add_sender
    #Login as admin
    ${Admin_token}=  Login as admin backend
    #Adding a sender
    Adding a new sender    ${Admin_token}

Verify that the user is able to update the sender
    [Tags]  Edit_sender
    #Login as admin
    ${Admin_token}=  Login as admin backend
    #Adding a new sender
    ${Sender_id}    ${Sender_name}=   Adding a new sender    ${Admin_token}
    #Updating the sender
    Updating the sender    ${Admin_token}    ${Sender_id}

Verify that the user is able to delete the sender
    [Tags]  Delete_sender
    #Login as admin
    ${Admin_token}=  Login as admin backend
    #Adding a new sender
    ${Sender_id}    ${Sender_name}=   Adding a new sender    ${Admin_token}
    #Deleting the sender
    Deleting the sender    ${Admin_token}    ${Sender_id}