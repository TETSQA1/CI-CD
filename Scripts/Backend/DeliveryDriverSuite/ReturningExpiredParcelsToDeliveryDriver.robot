*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../resources/BackendUtils/counter.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the counter is able to return the single expired parcels to the delivery driver
    [Tags]    Returning_expired_parcels_to_Delivery_Driver
    ${Admin_token}=     Login as admin backend
    #Login Delivery Driver
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating a new parcel
    ${parcel_id}   ${EAN}=   Create Parcel By Driver using recipient with pin and monies    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
     #Counter login
    ${requestId}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #getting the parcels by id
    Get Parcel By Id    ${counter_token}    ${parcel_id}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}
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

Verify that the counter is able to return the multiple expired parcels to the delivery driver
    [Tags]    Returning_multiple_expired_parcels_to_Delivery_Driver
    ${Admin_token}=     Login as admin backend
    #Login Delivery Driver
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating a new multiple parcels
    ${parcel_id_1}  ${parcel_id_2}=  Create multiple parcels by driver using recipient with Pin and monies    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
     #Counter login
    ${requestId}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #getting multuple parcels by id
    Get multiple parcels ids    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}
    #Getting multiple parcels monies details
    ${monies_1}    ${monies_2}=   Getting multiple parcels monies details    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}
    #Validating the parcels
    Validating the multiple parcel and changing the parcels status into drop-off    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}    ${monies_1}    ${monies_2}
    #Changing the parcel status to expired
    Change the multiple parcel status to expired    ${Admin_token}    ${monies_1}    ${monies_2}    ${parcel_id_1}    ${parcel_id_2}
    #Requesting the counter to confirm the returning
    ${group_id}=    Create the return group for the parcel    ${Counter_token}    ${courier_id}
    #changing the parcel status to expired-returning
    Changing the expired multiple parcel status to expired-returning    ${Counter_token}    ${group_id}    ${parcel_id_1}    ${parcel_id_2}
    #Validating the multiple parcels and changing the parcel status to returned to courier
    Validating the group of return parcel and changing the status to returned    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${monies_1}    ${monies_2}