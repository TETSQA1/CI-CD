*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../resources/BackendUtils/counter.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the counter is able to return the single expired parcels to the delivery driver using EAN2
    [Tags]    Returning_expired_parcels_to_Delivery_Driver_using_EAN2
    ${Admin_token}=     Login as admin backend
    #Login Delivery Driver
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating a new parcel
    ${parcel_id}   ${EAN}  ${EAN2}=   Create Parcel By Driver using recipient    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    #Counter login
    ${requestId}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #getting the parcels by id
    Get parcel id by EAN2    ${counter_token}    ${EAN2}
    #Updating the parcel status to drop-off
    Validating the parcel and changing the parcel status into drop-off   ${counter_token}    ${parcel_id}
    #Getting parcel monies details
    ${monies}=   Getting parcels monies details    ${counter_token}    ${parcel_id}
    #Changing the parcel status to expired
    Change the parcel status to expired    ${Admin_token}    ${monies}    ${parcel_id}
    #Requesting the counter to confirm the returning
    ${group_id}=    Create the return group for the parcel    ${Counter_token}    ${courier_id}
    #Changing the parcel status to expired-returning
    Changing the expired parcel status to expired-returning    ${Counter_token}    ${group_id}    ${parcel_id}
    #Validating the parcel and changing the parcel status to returned to courier
    Validating the return parcel and changing the status to returned    ${counter_token}    ${parcel_id}    ${monies}