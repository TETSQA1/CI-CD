*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../resources/BackendUtils/counter.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the counter is able to deliver single expired parcel to the customer
    [Tags]    Deliver_single_expired_parcel_customer
    ${Admin_token}=     Login as admin backend
    #Login DD
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
    #Login recipient
    ${requestId_recipient}=     Login as Recipient first step    ${Recipient_phone_number}
    ${recipient_token}=     Login As Recipient second step    ${requestId_recipient}
    #getting the group id
    ${group_id}=    Get the group id    ${recipient_token}    ${Counter_id}
    #changing the parcel status to collecting
    Change the status of the parcel into collecting    ${Counter_token}    ${group_id}    ${parcel_id}
    #Getting the parcel id from the group API
    Getting the parcel id using group    ${counter_token}    ${group_id}
    #changing the parcel status into collected
    Validating the parcel and changing the parcel status into collected    ${counter_token}    ${parcel_id}    ${monies}

Verify that the counter is able to deliver multiple expired parcels to the customer
    [Tags]    Deliver_multiple_expired_parcel_customer
    ${Admin_token}=     Login as admin backend
    #Login DD
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating multiple parcels
    ${parcel_id_1}    ${parcel_id_2}=   Create multiple parcels by driver using recipient with Pin and monies    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    #Counter login
    ${requestId}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #Getting multiple parcel Ids
    Get multiple parcels ids    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}
    #Getting multiple parcel monies details
    ${monies_1}   ${monies_2}=  Getting multiple parcels monies details    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}
    #changing the parcel status
    Validating the multiple parcel and changing the parcels status into drop-off    ${counter_token}  ${parcel_id_1}  ${parcel_id_2}  ${Delivery_driver_Phone_number}  ${recipient_phone_number}  ${monies_1}  ${monies_2}
    #Changing the parcel status to expired
    Change the multiple parcel status to expired    ${Admin_token}    ${monies_1}    ${monies_2}    ${parcel_id_1}    ${parcel_id_2}
    #Login recipient
    ${requestId_recipient}=     Login as Recipient first step    ${Recipient_phone_number}
    ${recipient_token}=     Login As Recipient second step    ${requestId_recipient}
    #getting the group id
    ${group_id}=    Get the group id    ${recipient_token}    ${Counter_id}
    #Changing the status of the multiple parcels into collecting
    Change the status of the multiple parcels into collecting    ${Counter_token}    ${group_id}    ${parcel_id_1}    ${parcel_id_2}
    #Getting the multiple parcel Id using group Id
    Get the multiple parcel id using group id    ${Counter_token}    ${group_id}
    #Validating the parcel and changing the parcel status to collected
    Validating multiple parcels and changing the parcels status into collected    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${monies_1}    ${monies_2}