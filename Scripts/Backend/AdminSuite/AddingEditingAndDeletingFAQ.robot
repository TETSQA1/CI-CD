*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the user is able to add a new FAQ
     [Tags]    Adding_FAQ
     #Login as admin
     ${Admin_token}=     Login as admin backend
     #Adding a new FAQ
     ${FAQ_id}   ${FAQ_answer}=     Adding a new FAQ    ${Admin_token}

Verify that the user is able to edit the FAQ
     [Tags]    Editing_FAQ
     #Login as admin
     ${Admin_token}=     Login as admin backend
     #Adding a new FAQ
     ${FAQ_id}   ${FAQ_answer}=     Adding a new FAQ    ${Admin_token}
     #Editing the FAQ
     Edit the FAQ    ${Admin_token}    ${FAQ_id}

Verify that the user is able to delete the FAQ
     [Tags]    Delete_FAQ
     #Login as admin
     ${Admin_token}=     Login as admin backend
     #Adding a new FAQ
     ${FAQ_id}   ${FAQ_answer}=     Adding a new FAQ    ${Admin_token}
     #Deleting the FAQ
     Delete the FAQ    ${Admin_token}    ${FAQ_id}