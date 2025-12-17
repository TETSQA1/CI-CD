*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot
Resource    ../../Resources/BackendUtils/Counter.robot

*** Test Cases ***
Verify that the user is able to get the parcel invitation URL
    [Tags]    Parcel_invitation_URL
    ${Admin_token}=     Login as admin backend
    #Login Delivery Driver
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating a new parcel
    ${parcel_id}   ${EAN}  ${EAN2}=     Create Parcel By Driver using recipient    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    #Counter login
    ${requestId}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #Validating the parcel and changing parcel status to delivered courier
    Validating the parcel and changing the parcel status into drop-off    ${counter_token}    ${parcel_id}
    #Getting the parcel invitation URL
    Getting the parcel invitation URL    ${driver_token}    ${parcel_id}