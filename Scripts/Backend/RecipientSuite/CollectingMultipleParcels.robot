*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../resources/BackendUtils/counter.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the recipient is able to collect the multiple parcels from the counter
    [Tags]    Collect_multiple_parcels
    ${Admin_token}=     Login as admin backend
    #Driver login
    ${requestId_driver}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId_driver}
    #Creating multiple parcels
    ${parcel_id_1}  ${parcel_id_2}=   Create multiple parcels by driver using recipient    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    #Counter login
    ${requestId_counter}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=    Login As Counter Second Step    ${requestId_counter}
    #getting multiple parcels ids
    Get multiple parcels ids    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}
    #Getting multiple parcels monies details
    ${monies_1}    ${monies_2}=  Getting multiple parcels monies details    ${counter_token}    ${parcel_id_1}   ${parcel_id_2}
    #updating the parcel status into drop-off
    Validating the multiple parcel and changing the parcels status into drop-off    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}    ${monies_1}    ${monies_2}
    #Recipient login
    ${requestId_recipient}=     Login as Recipient first step    ${Recipient_phone_number}
    ${recipient_token}=     Login As Recipient second step    ${requestId_recipient}
    #getting the group id
    ${group_id}=   Get the group id    ${recipient_token}    ${Counter_id}
    #updating the parcel status
    Change the status of the multiple parcels into collecting    ${Counter_token}    ${group_id}    ${parcel_id_1}    ${parcel_id_2} 
    #getting multiple parcel id using group
    Get the multiple parcel id using group id    ${counter_token}    ${group_id}
    #getting parcel monies details
    ${monies_1}    ${monies_2}=  Getting multiple parcels monies details    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}
    #validating the parcel and change parcel status to collected
    Validating multiple parcels and changing the parcels status into collected    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${monies_1}    ${monies_2}

Verify that the recipient is able to collect the multiple parcels with pin from the counter
    [Tags]    Collect_multiple_parcels_with_pin
    ${Admin_token}=     Login as admin backend
    #Driver login
    ${requestId_driver}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId_driver}
    #Creating multiple parcels
    ${parcel_id_1}  ${parcel_id_2}=   Create multiple parcels by driver using recipient with pin  ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    #Counter login
    ${requestId_counter}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=    Login As Counter Second Step    ${requestId_counter}
    #getting multiple parcels ids
    Get multiple parcels ids    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}
    #Getting multiple parcels monies details
    ${monies_1}    ${monies_2}=  Getting multiple parcels monies details    ${counter_token}    ${parcel_id_1}   ${parcel_id_2}
    #updating the parcel status into drop-off
    Validating the multiple parcel and changing the parcels status into drop-off    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}    ${monies_1}    ${monies_2}
    #Recipient login
    ${requestId_recipient}=     Login as Recipient first step    ${Recipient_phone_number}
    ${recipient_token}=     Login As Recipient second step    ${requestId_recipient}
    #getting the group id
    ${group_id}=   Get the group id    ${recipient_token}    ${Counter_id}
    #updating the parcel status
    Change the status of the multiple parcels into collecting    ${Counter_token}    ${group_id}    ${parcel_id_1}    ${parcel_id_2}
    #getting multiple parcel id using group
    Get the multiple parcel id using group id    ${counter_token}    ${group_id}
    #getting parcel monies details
    ${monies_1}    ${monies_2}=  Getting multiple parcels monies details    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}
    #validating the parcel and change parcel status to collected
    Validating multiple parcels and changing the parcels status into collected    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${monies_1}    ${monies_2}

Verify that the recipient is able to collect the multiple parcels with monies from the counter
    [Tags]    Collect_multiple_parcels_with_monies
    ${Admin_token}=     Login as admin backend
    #Driver login
    ${requestId_driver}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId_driver}
    #Creating multiple parcels
    ${parcel_id_1}  ${parcel_id_2}=   Create multiple parcels by driver using recipient with monies    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    #Counter login
    ${requestId_counter}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=    Login As Counter Second Step    ${requestId_counter}
    #getting multiple parcels ids
    Get multiple parcels ids    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}
    #Getting multiple parcels monies details
    ${monies_1}    ${monies_2}=  Getting multiple parcels monies details    ${counter_token}    ${parcel_id_1}   ${parcel_id_2}
    #updating the parcel status into drop-off
    Validating the multiple parcel and changing the parcels status into drop-off    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}    ${monies_1}    ${monies_2}
    #Recipient login
    ${requestId_recipient}=     Login as Recipient first step    ${Recipient_phone_number}
    ${recipient_token}=     Login As Recipient second step    ${requestId_recipient}
    #getting the group id
    ${group_id}=   Get the group id    ${recipient_token}    ${Counter_id}
    #updating the parcel status
    Change the status of the multiple parcels into collecting    ${Counter_token}    ${group_id}    ${parcel_id_1}    ${parcel_id_2}
    #getting multiple parcel id using group
    Get the multiple parcel id using group id    ${counter_token}    ${group_id}
    #getting parcel monies details
    ${monies_1}    ${monies_2}=  Getting multiple parcels monies details    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}
    #validating the parcel and change parcel status to collected
    Validating multiple parcels and changing the parcels status into collected    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${monies_1}    ${monies_2}

Verify that the recipient is able to collect the multiple parcels with pin and monies from the counter
    [Tags]    Collect_multiple_parcels_with_pin_and_monies
    ${Admin_token}=     Login as admin backend
    #Driver login
    ${requestId_driver}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId_driver}
    #Creating multiple parcels
    ${parcel_id_1}  ${parcel_id_2}=   Create multiple parcels by driver using recipient with Pin and monies    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    #Counter login
    ${requestId_counter}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=    Login As Counter Second Step    ${requestId_counter}
    #getting multiple parcels ids
    Get multiple parcels ids    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}
    #Getting multiple parcels monies details
    ${monies_1}    ${monies_2}=  Getting multiple parcels monies details    ${counter_token}    ${parcel_id_1}   ${parcel_id_2}
    #updating the parcel status into drop-off
    Validating the multiple parcel and changing the parcels status into drop-off    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}    ${monies_1}    ${monies_2}
    #Recipient login
    ${requestId_recipient}=     Login as Recipient first step    ${Recipient_phone_number}
    ${recipient_token}=     Login As Recipient second step    ${requestId_recipient}
    #getting the group id
    ${group_id}=   Get the group id    ${recipient_token}    ${Counter_id}
    #updating the parcel status
    Change the status of the multiple parcels into collecting    ${Counter_token}    ${group_id}    ${parcel_id_1}    ${parcel_id_2}
    #getting multiple parcel id using group
    Get the multiple parcel id using group id    ${counter_token}    ${group_id}
    #getting parcel monies details
    ${monies_1}    ${monies_2}=  Getting multiple parcels monies details    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}
    #validating the parcel and change parcel status to collected
    Validating multiple parcels and changing the parcels status into collected    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${monies_1}    ${monies_2}