*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../resources/BackendUtils/counter.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the customer is able to collect the single parcel from the counter
    [Tags]   Collect_single_parcel
    ${Admin_token}=     Login as admin backend
    #Driver login
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating parcel by new recipient
    ${parcel_id}   ${EAN}  ${EAN2}=   Create Parcel By Driver using recipient    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    #Counter login
    ${requestId}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #getting the parcels by id
    Get Parcel By Id    ${counter_token}    ${parcel_id}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}
    #Updating the parcel status to drop-off
    Validating the parcel and changing the parcel status into drop-off    ${counter_token}    ${parcel_id}
    #Login recipient
    ${requestId_recipient}=     Login as Recipient first step    ${Recipient_phone_number}
    ${recipient_token}=     Login As Recipient second step    ${requestId_recipient}
    #getting the group id
    ${group_id}=    Get the group id    ${recipient_token}    ${Counter_id}
    #changing the parcel status to collecting
    Change the status of the parcel into collecting    ${Counter_token}    ${group_id}    ${parcel_id}
    #Getting the parcel id from the group API
    Getting the parcel id using group    ${counter_token}    ${group_id}
    #Getting parcel monies detail
    ${monies}=      Getting parcels monies details    ${counter_token}    ${parcel_id}
    #changing the parcel status into collected
    Validating the parcel and changing the parcel status into collected    ${counter_token}    ${parcel_id}    ${monies}

Verify that the customer is able to collect the single parcel with the pin from the counter
    [Tags]   Collect_single_parcel_with_pin
    ${Admin_token}=     Login as admin backend
    #Driver login
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating parcel by new recipient
    ${parcel_id}   ${EAN}=   Create Parcel By Driver using recipient with pin    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    #Counter login
    ${requestId}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #getting the parcels by id
    Get Parcel By Id    ${counter_token}    ${parcel_id}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}
    #Updating the parcel status to drop-off
    Validating the parcel and changing the parcel status into drop-off    ${counter_token}    ${parcel_id}
    #Login recipient
    ${requestId_recipient}=     Login as Recipient first step    ${Recipient_phone_number}
    ${recipient_token}=     Login As Recipient second step    ${requestId_recipient}
    #getting the group id
    ${group_id}=    Get the group id    ${recipient_token}    ${Counter_id}
    #changing the parcel status to collecting
    Change the status of the parcel into collecting    ${Counter_token}    ${group_id}    ${parcel_id}
    #Getting the parcel id from the group API
    Getting the parcel id using group    ${counter_token}    ${group_id}
    #Getting parcel monies detail
    ${monies}=      Getting parcels monies details    ${counter_token}    ${parcel_id}
    #changing the parcel status into collected
    Validating the parcel and changing the parcel status into collected    ${counter_token}    ${parcel_id}    ${monies}

Verify that the customer is able to collect the single parcel with the monies from the counter
    [Tags]   Collect_single_parcel_with_monies
    ${Admin_token}=     Login as admin backend
    #Driver login
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating parcel by new recipient
    ${parcel_id}   ${EAN}=   Create Parcel By Driver using recipient with monies    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    #Counter login
    ${requestId}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #getting the parcels by id
    Get Parcel By Id    ${counter_token}    ${parcel_id}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}
    #Updating the parcel status to drop-off
    Validating the parcel and changing the parcel status into drop-off    ${counter_token}    ${parcel_id}
    #Login recipient
    ${requestId_recipient}=     Login as Recipient first step    ${Recipient_phone_number}
    ${recipient_token}=     Login As Recipient second step    ${requestId_recipient}
    #getting the group id
    ${group_id}=    Get the group id    ${recipient_token}    ${Counter_id}
    #changing the parcel status to collecting
    Change the status of the parcel into collecting    ${Counter_token}    ${group_id}    ${parcel_id}
    #Getting the parcel id from the group API
    Getting the parcel id using group    ${counter_token}    ${group_id}
    #Getting parcel monies detail
    ${monies}=      Getting parcels monies details    ${counter_token}    ${parcel_id}
    #changing the parcel status into collected
    Validating the parcel and changing the parcel status into collected    ${counter_token}    ${parcel_id}    ${monies}

Verify that the customer is able to collect the single parcel with the pin and monies from the counter
    [Tags]   Collect_single_parcel_with_pin_and_monies
    ${Admin_token}=     Login as admin backend
    #Driver login
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating parcel by new recipient
    ${parcel_id}   ${EAN}=   Create Parcel By Driver using recipient with pin and monies    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    #Counter login
    ${requestId}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #getting the parcels by id
    Get Parcel By Id    ${counter_token}    ${parcel_id}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}
    #Updating the parcel status to drop-off
    Validating the parcel and changing the parcel status into drop-off    ${counter_token}    ${parcel_id}
    #Login recipient
    ${requestId_recipient}=     Login as Recipient first step    ${Recipient_phone_number}
    ${recipient_token}=     Login As Recipient second step    ${requestId_recipient}
    #getting the group id
    ${group_id}=    Get the group id    ${recipient_token}    ${Counter_id}
    #changing the parcel status to collecting
    Change the status of the parcel into collecting    ${Counter_token}    ${group_id}    ${parcel_id}
    #Getting the parcel id from the group API
    Getting the parcel id using group    ${counter_token}    ${group_id}
    #Getting parcel monies detail
    ${monies}=      Getting parcels monies details    ${counter_token}    ${parcel_id}
    #changing the parcel status into collected
    Validating the parcel and changing the parcel status into collected    ${counter_token}    ${parcel_id}    ${monies}