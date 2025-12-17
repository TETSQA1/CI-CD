*** Settings ***
Library     RequestsLibrary
Resource    ../../Resources/BackendUtils/KanguroPoint.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the user is able to create a new kanguro point
    [Tags]  Add_Kanguro_point
    #Admin login
    ${Admin_token}=     Login as admin backend
    #Adding a new kanguro point
    Adding a new kanguro point    ${Admin_token}

Verify that the user is able to update the created kanguro point
    [Tags]  Update_Kanguro_point
    #Admin login
    ${Admin_token}=     Login as admin backend
    #Adding a new kanguro point
    ${New_KP_ID}    ${New_counter_ID}=   Adding a new kanguro point    ${Admin_token}
    #Updating the kanguro point
    Updating the new kanguro point    ${New_KP_ID}    ${Admin_token}

Verify that the user is able to delete the created kanguro point
    [Tags]  Delete_Kanguro_point
    #Admin login
    ${Admin_token}=     Login as admin backend
    #Adding a new kanguro point
    ${New_KP_ID}    ${New_counter_ID}=   Adding a new kanguro point    ${Admin_token}
    #Changing the status of the kanguro point
    Changing the status of the Kanguro point    ${New_KP_ID}    ${Admin_token}
    #Deleting the counter
    Deleting the counter    ${New_counter_ID}    ${Admin_token}
    #Deleting the kanguro point
    Deleting the kanguro point    ${New_KP_ID}    ${Admin_token}