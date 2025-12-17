*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the Delivery Driver Can get the KP by ID
    [Tags]    Getting_the_DD_KP_by_ID
    ${Admin_token}=     Login as admin backend
    #Login Delivery Driver
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Getting the delivery driver KP by ID
    Get delivery driver KP by ID    ${driver_token}    ${kanguroPointId}
    #Getting the delivery driver KP by ID after kp courier relation
    Get delivery driver KP by ID    ${driver_token}    ${kanguroPointId}