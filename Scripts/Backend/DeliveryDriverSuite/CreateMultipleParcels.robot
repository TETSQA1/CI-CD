*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the delivery Driver is able to Create multiple Parcels (using new recipient)
    [Tags]    Create_multiple_Parcels
    ${Admin_token}=     Login as admin backend
    #Login Delivery Driver
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating multiple parcels
    Create multiple parcels by driver using recipient    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}

Verify that the delivery Driver is able to Create multiple Parcels (using new recipient) with pin
    [Tags]    Create_multiple_Parcels_with_pin
    ${Admin_token}=     Login as admin backend
    #Login Delivery Driver
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating multiple parcels with pin
    Create multiple parcels by driver using recipient with pin    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}

Verify that the delivery Driver is able to Create multiple Parcels (using new recipient) with monies
    [Tags]    Create_multiple_Parcels_with_monies
    ${Admin_token}=     Login as admin backend
    #Login Delivery Driver
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating multiple parcels with monies
    Create multiple parcels by driver using recipient with monies    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}

Verify that the delivery Driver is able to Create multiple Parcels (using new recipient) with pin and monies
    [Tags]    Create_multiple_Parcels_with_pin_and_monies
    ${Admin_token}=     Login as admin backend
    #Login Delivery Driver
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating multiple parcels with monies
    Create multiple parcels by driver using recipient with Pin and monies    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}