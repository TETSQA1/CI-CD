*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the Delivery Driver is able to create a single Parcel (using new recipient)
    [Tags]    Create_single_parcel_using_new_recipient
    ${Admin_token}=     Login as admin backend
    #Login Delivery Driver
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Create new recipient
    ${recipient_id}    ${recipient_name}    ${recipient_Phone_number}=    Create Recipient By Driver    ${driver_token}
    #Creating a new parcel
    Create Parcel By Driver using recipient    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}