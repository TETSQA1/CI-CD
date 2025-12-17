*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the Delivery Driver is able to create a single Parcel
    [Tags]    Create_single_parcel
    ${Admin_token}=     Login as admin backend
    #Login as Delivery Driver
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating a new parcel
    Create Parcel By Driver using recipient    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}

Verify that the delivery driver is able to create a single parcel with pin
    [Tags]    Create_single_parcel_with_pin
    ${Admin_token}=     Login as admin backend
    #Login as Delivery Driver
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating a new parcel
    Create Parcel By Driver using recipient with pin  ${driver_token}  ${recipient_id}  ${recipient_name}  ${recipient_phone_number}

Verify that the delivery driver is able to create a single parcel with monies
    [Tags]    Create_single_parcel_with_monies
    ${Admin_token}=     Login as admin backend
    #Login as Delivery Driver
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating a new parcel with monies
    Create Parcel By Driver using recipient with monies    ${driver_token}  ${recipient_id}  ${recipient_name}  ${recipient_phone_number}

Verify that the delivery driver is able to create a single parcel with pin and monies
    [Tags]    Create_single_parcel_with_pin_and_monies
    ${Admin_token}=     Login as admin backend
    #Login as Delivery Driver
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating a new parcel with pin and monies
    Create Parcel By Driver using recipient with pin and monies    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}