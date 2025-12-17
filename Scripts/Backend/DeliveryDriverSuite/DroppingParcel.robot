*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the delivery driver is able to change the created parcel status into dropping
    [Tags]    Dropping_parcel
    ${Admin_token}=     Login as admin backend
    #Login Delivery Driver
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating a new parcel
    ${parcel_id}   ${EAN}  ${EAN2}=     Create Parcel By Driver using recipient    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    #Dropping the created parcel
    Dropping the created parcel    ${driver_token}    ${parcel_id}