*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../Resources/BackendUtils/Courier.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the user is able to add tutorial for the courier
    [Tags]  Add_tutorial_for_courier
    #Login as admin
    ${Admin_token}=  Login as admin backend
    #Adding a new courier
    ${Courier_Id}   ${New_courier_name}=   Add new courier    ${Admin_token}
    #Adding tutorial for courier in english
    Add tutorial for courier in english language    ${Admin_token}    ${Courier_Id}
    #Adding tutorial for courier in spanish
    Add tutorial for courier in Spanish language    ${Admin_token}    ${Courier_Id}
    #Activating the tutorial send flag
    Activate the KP and courier relation as potential    ${Admin_token}    ${kanguroPointId}    ${Courier_id}