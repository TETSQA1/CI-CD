*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../resources/BackendUtils/counter.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the recipient can return the parcels successfully
    [Tags]    Return_parcels
    ${Admin_token}=     Login as admin backend
    #login driver
    ${requestId_driver}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId_driver}
    #recipient login
    ${requestId_recipient}=     Login as Recipient first step    ${Recipient_phone_number}
    ${recipient_token}=     Login As Recipient second step    ${requestId_recipient}
    #creating a return parcel
    ${parcel_id}   ${EAN}=   Create a return parcel    ${driver_token}    ${recipient_id}    ${recipient_phone_number}    ${recipient_name}    ${kanguroPointId}    ${recipient_email}    ${originalAddress}
    #login counter
    ${requestId_counter}=    Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=    Login As Counter Second Step    ${requestId_counter}
    #getting the parcel id by EAN
    ${EAN}=       Get parcel id by EAN    ${counter_token}    ${EAN}
    #getting parcel monies details
    ${monies}=  Getting parcels monies details    ${counter_token}    ${parcel_id}
    #validating the parcel
    Validating the parcel and changing the parcel status into drop-off recipient    ${counter_token}    ${parcel_id}    ${monies}
    #getting the group id by confirming with the counter
    ${group_id}=    Create the return group for the parcel    ${counter_token}    ${Courier_id}
    #getting the parcel id using group id
    Getting the parcel id using the group id    ${counter_token}    ${group_id}
    #validating the parcel and change parcel status to returned
    Validating the return parcel and changing the status to returned    ${counter_token}    ${parcel_id}    ${monies}