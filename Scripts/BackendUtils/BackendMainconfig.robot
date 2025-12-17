*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    json
Library    String
Library    DateTime
Library    OperatingSystem
Library    BuiltIn
Library    Process
Resource   ../../Resources/CommonUtils/CommonUtils.robot

*** Variables ***
#Environment URLs
${base_URL}                https://api.test.kanguro.com/api

#Driver
${Create_new_delivery_driver_endpoint}   /v1/admin/deliveryDrivers
${driver_login_first_step}               /v1/deliveryDriver/auth/login-first-step
${driver_login_second_step}              /v1/deliveryDriver/auth/login-second-step
${Create_recipient_end_point}            /v1/deliveryDriver/parcels/recipients
${Assign_delivery_driver_endpoint_1}     /v1/deliveryDriver/parcelsManagement/
${Assign_delivery_driver_endpoint_2}     /deliveryDriverId
${Recipient_deliver_groups_endpoint}     /v1/deliveryDriver/parcels/recipientDeliverGroups
${DD_KP_id_endpoint}                     /v1/deliveryDriver/kanguroPoints/
${Request_counter_confirm_return_endpoint1}    /v1/deliveryDriver/parcels/counter/
${Request_counter_confirm_return_endpoint2}    /confirm-return

#Parcels base end point
${Parcels_base_end_point}                /v1/deliveryDriver/parcels/
${Expire_parcels_endpoint2}              /expire
${POD_endpoint_2}                        /pod
${Dropping_parcel_endpoint_2}            /dropping
${Get_invitation_endpoint_2}             /invitation

#Counter
${counter_login_first_step}              /v1/counter/auth/login-first-step
${counter_login_second_step}             /v1/counter/auth/login-second-step
${attachments}          []
@{my_list}                               item1   item2
${get_by_group_counter_endpoint}         /v1/counter/parcels/group/
${Validate_parcel_endpoint}              /v1/counter/parcels/
${get_by_EAN}                            /v1/counter/parcels/ean/
${valid}                                 True
${Change_to_collecting_endpoint1}        /v1/counter/parcels/
${Change_to_collecting_endpoint2}        /collecting
${action_collect}                        deliver-to-recipient
${action_return}                         collect-from-recipient
${action_return_driver}                  deliver-to-delivery-driver
${Create_return_group_endpoint}          /v1/counter/parcels/group/return
${create_labelless_parcel_endpoint}      /v1/counter/parcels/labelless
${action_labelless}                      collect-from-recipient
${Validate_parcel_endpoint}              /v1/counter/parcels/
${Get_parcel_monies_endpoint}            /v1/counter/parcels/
${update_recipient_endpoint1}            /v1/counter/parcels/
${update_recipient_endpoint2}            /recipient
${update_EAN_endpoint1}                  /v1/counter/parcels/
${update_EAN_endpoint2}                  /ean
${return_couriers_endpoint}              /v1/counter/parcels/group/return
${get_parcel_by_id}                      /v1/counter/parcels
${Returning_status_change_endpoint1}     /v1/counter/parcels/
${Returning_status_change_endpoint2}     /returning
${Update_counter_schedule_endpoint1}     /v1/admin/counters/
${Update_counter_schedule_endpoint2}     /schedule
${Possible_actions_endpoint1}    /v1/counter/parcels/code/
${Possible_actions_endpoint2}    /possibleActions
${Confirm_action_endpoint}       /v1/counter/parcels/confirmAction
${future_parcels_endpoint}       /v1/counter/parcels/future?pageNumber=0&pageSize=10
${Update_vacation_endpoint1}     /v1/admin/counters/
${Update_vacation_endpoint2}     /holidays

#Recipient
${Recipient_login_endpoint}          /v1/recipient/auth/login-invitation
${Recipient_profile_end_point}           /v1/recipient/profile/me
${group_id_endpoint1}                    /v1/recipient/parcels/counter/
${group_id_endpoint2}                    /confirm/
${update_recipient_profile_endpoint}     /v1/recipient/profile/me
${Signature}            signature/236eee459271ce2de102e1c2c5d1bbf5b.png
${get_by_group_recipient_endpoint}      /v1/recipient/parcels/group/
${Recipient_login_first_step_endpoint}   /v1/recipient/auth/login-first-step
${Recipient_login_Second_step_endpoint}  /v1/recipient/auth/login-second-step

#Admin
${Admin_login_endpoint}                  /v1/admin/auth/login-email
${Special_phones_endpoint}               /v1/admin/specialPhones
${Call_bot_login_endpoint}              /v1/callBot/auth/login
${call_bot_API_key}     udS62SQEnXhM8BmhGuB4KNoFs0bJ9l
${call_bot_API_secret}      8bfYidQKtlOeNs6zivf0nfWuNHztTe
${create_call-bot_provider_endpoint}        /v1/admin/callBots
${create_derivation_endpoint}       /v1/admin/derivations
${Assign_derivation_call-bot_endpoint}      /v1/admin/derivations/assignCallbots
${Accept_derivation_endpoint1}       /v1/callBot/derivations/
${Accept_derivation_endpoint2}      /accept
${Reject_derivation_endpoint1}      /v1/callBot/derivations/
${Reject_derivation_endpoint2}      /reject
${Update_courier_KP_endpoint1}       /v1/admin/kanguroPoints/
${Update_courier_KP_endpoint2}      /couriers
${parcel_status_change_endpoint1}    /v1/admin/parcels/
${parcel_status_change_endpoint2}    /status
${parcel_monies_admin_endpoint}     /v1/admin/parcels/
${Derivation_status_endpoint}        /v1/callbot/derivations/
${Add_FAQ_endpoint}     /v1/admin/faqs
${Edit_FAQ_endpoint}   /v1/admin/faqs/
${Delete_FAQ_endpoint}      /v1/admin/faqs/
${Update_derivation_endpoint}       /v1/admin/derivations/
${Add_account_endpoint}     /v1/admin/accounts
${Add_contract_endpoint1}   /v1/admin/accounts/
${Add_contract_endpoint2}   /contracts
${Update_contract_endpoint1}    /v1/admin/accounts/
${Update_contract_endpoint2}    /contracts/
${Add_contacts_endpoint1}      /v1/admin/accounts/
${Add_contacts_endpoint2}     /contacts
${Update_contact_endpoint1}   /v1/admin/accounts/
${Update_contact_endpoint2}   /contacts/
${Delete_contact_endpoint1}   /v1/admin/accounts/
${Delete_contact_endpoint2}   /contacts/
${Check_tutorial_send_flag_endpoint2}       /couriers/
${Check_tutorial_send_flag_endpoint3}      /checkSendTutorialsFlags
${Change_parcel_status_endpoint1}   /v1/admin/parcels/
${Change_parcel_status_endpoint2}   /status
${Create_campaign_endpoint}         /v1/admin/campaigns
${Update_campaign_endpoint}         /v1/admin/campaigns/
${Publish_campaign_endpoint}        /v1/admin/campaigns/
${Senders_base_endpoint}      /v1/admin/senders

#Labelless sender
${Create_labelless_sender_endpoint}     /v1/admin/senders
${Add_labelless_sender_to_courier_endpoint}     /v1/admin/courierLabellessSenders

#Courier
${Create_new_courier_endpoint}          /v1/admin/couriers
${update_deliverdriver_endpoint}        /v1/admin/deliveryDrivers/
${Add_courier_endpoint}     /v1/admin/couriers
${Add_courier_tutorial_endpoint}    /v1/admin/courierTutorials

#Kanguro points
${New_KP_base_endpoint}         /v1/admin/kanguroPoints
${KP_Status_change_endpoint}    /status

#Counter settings
${New_counter_base_endpoint}         /v1/admin/counters/
${Counter_settings_endpoint1}        /v1/admin/counters/
${Counter_settings_endpoint2}        /settings

*** Keywords ***
Generate Random Driver Name
    ${Names}=   Create List   James    John    Michael    David    Sarah    Emma
    Append To List    ${Names}    Oliver    Mia    Sophia    William  Benjamin    Lucas    Jack    Henry
    Append To List    ${Names}     Samuel    Grace    Lily    Ava    Charlotte    Thomas     Isabella    Amelia
    ${names_length}=    Evaluate    len(${Names})
    ${random_name_index}=    Evaluate    random.randint(0, ${names_length} - 1)    modules=random
    ${random_user}=    Get From List    ${Names}    ${random_name_index}
    ${random_string}=    Generate Random String    4    [01234]
    ${random_string}=    Replace String    ${random_string}    [    ${EMPTY}
    ${random_string}=    Replace String    ${random_string}    ]    ${EMPTY}
    ${random_name}=     Catenate   ${random_user}  Robotdriver       ${random_string}
    RETURN    ${random_name}

Generate Random Recipient Name
    ${Names}=   Create List   James    John    Michael    David    Sarah    Emma
    Append To List    ${Names}    Oliver    Mia    Sophia    William  Benjamin    Lucas    Jack    Henry
    Append To List    ${Names}     Samuel    Grace    Lily    Ava    Charlotte    Thomas     Isabella    Amelia
    ${names_length}=    Evaluate    len(${Names})
    ${random_name_index}=    Evaluate    random.randint(0, ${names_length} - 1)    modules=random
    ${random_user}=    Get From List    ${Names}    ${random_name_index}
    ${random_string}=    Generate Random String    4    [01234]
    ${random_string}=    Replace String    ${random_string}    [    ${EMPTY}
    ${random_string}=    Replace String    ${random_string}    ]    ${EMPTY}
    ${random_name}=     Catenate   ${random_user}  Robotcustomer       ${random_string}
    RETURN    ${random_name}

Generate Random sender Name
    ${Names}=   Create List   James    John    Michael    David    Sarah    Emma
    Append To List    ${Names}    Oliver    Mia    Sophia    William  Benjamin    Lucas    Jack    Henry
    Append To List    ${Names}     Samuel    Grace    Lily    Ava    Charlotte    Thomas     Isabella    Amelia
    ${names_length}=    Evaluate    len(${Names})
    ${random_name_index}=    Evaluate    random.randint(0, ${names_length} - 1)    modules=random
    ${random_user}=    Get From List    ${Names}    ${random_name_index}
    ${random_string}=    Generate Random String    4    [01234]
    ${random_string}=    Replace String    ${random_string}    [    ${EMPTY}
    ${random_string}=    Replace String    ${random_string}    ]    ${EMPTY}
    ${random_name}=     Catenate   ${random_user}  Robotsender       ${random_string}
    RETURN    ${random_name}

Generate Random Counteruser Name
   ${Names}=   Create List   James    John    Michael    David    Sarah    Emma
    Append To List    ${Names}    Oliver    Mia    Sophia    William  Benjamin    Lucas    Jack    Henry
    Append To List    ${Names}     Samuel    Grace    Lily    Ava    Charlotte    Thomas     Isabella    Amelia
    ${names_length}=    Evaluate    len(${Names})
    ${random_name_index}=    Evaluate    random.randint(0, ${names_length} - 1)    modules=random
    ${random_user}=    Get From List    ${Names}    ${random_name_index}
    ${random_string}=    Generate Random String    4    [01234]
    ${random_string}=    Replace String    ${random_string}    [    ${EMPTY}
    ${random_string}=    Replace String    ${random_string}    ]    ${EMPTY}
    ${random_name}=     Catenate   ${random_user}  Robotcounteruser       ${random_string}
    RETURN    ${random_name}

Generate Random account name
   ${Names}=   Create List   AccountA    AccountB    AccountC    AccountD    AccountE    AccountF
    Append To List    ${Names}    AccountG    AccountH    AccountI    AccountJ  AccountK    AccountL    AccountM    AccountN
    Append To List    ${Names}     AccountO    AccountP    AccountQ    AccountR    AccountS    AccountU     AccountV    AccountW
    ${names_length}=    Evaluate    len(${Names})
    ${random_name_index}=    Evaluate    random.randint(0, ${names_length} - 1)    modules=random
    ${random_name}=    Get From List    ${Names}    ${random_name_index}
    ${random_string}=    Generate Random String    4    [01234]
    ${random_string}=    Replace String    ${random_string}    [    ${EMPTY}
    ${random_string}=    Replace String    ${random_string}    ]    ${EMPTY}
    ${random_name}=     Catenate   ${random_name}  Robot       ${random_string}
    RETURN    ${random_name}

Generate random courier name
    ${random_string}=    Generate Random String    4    [01234]
    ${random_string}=    Replace String    ${random_string}    [    ${EMPTY}
    ${random_string}=    Replace String    ${random_string}    ]    ${EMPTY}
    ${random_name}=     Catenate   Robotcourier       ${random_string}
    RETURN    ${random_name}

Generate random counter name
    ${random_string}=    Generate Random String    4    [01234]
    ${random_string}=    Replace String    ${random_string}    [    ${EMPTY}
    ${random_string}=    Replace String    ${random_string}    ]    ${EMPTY}
    ${random_name}=     Catenate   Robotcounter       ${random_string}
    RETURN    ${random_name}

Generate Random Phone Number
    ${prefix}=    Set Variable    +886-
    ${random_digits}=    Generate Random String    10    0123456789
    ${phone_number}=    Catenate    SEPARATOR=    ${prefix}    ${random_digits}
    RETURN    ${phone_number}

Generate Random EAN
    ${prefix}=    Set Variable    599
    ${random_digits}=    Generate Random String    9    0123456789
    ${ean}=    Catenate    SEPARATOR=     ${prefix}    ${random_digits}
    RETURN    ${ean}

Generate Random Email Recipient
    ${Names}=   Create List   James    John    Michael    David    Sarah    Emma
    Append To List    ${Names}    Oliver    Mia    Sophia    William  Benjamin    Lucas    Jack    Henry
    Append To List    ${Names}     Samuel    Grace    Lily    Ava    Charlotte    Thomas     Isabella    Amelia
    ${names_length}=    Evaluate    len(${Names})
    ${random_name_index}=    Evaluate    random.randint(0, ${names_length} - 1)    modules=random
    ${random_user}=    Get From List    ${Names}    ${random_name_index}
    # Ensure no spaces exist in the generated string
    ${random_domain}=    Generate Random String    4    0123456789
    ${email}=    Set Variable    ${random_user}@robotrecipient${random_domain}.test
    RETURN    ${email}

Generate Random Email
    ${Names}=   Create List   James    John    Michael    David    Sarah    Emma
    Append To List    ${Names}    Oliver    Mia    Sophia    William  Benjamin    Lucas    Jack    Henry
    Append To List    ${Names}     Samuel    Grace    Lily    Ava    Charlotte    Thomas     Isabella    Amelia
    ${names_length}=    Evaluate    len(${Names})
    ${random_name_index}=    Evaluate    random.randint(0, ${names_length} - 1)    modules=random
    ${random_user}=    Get From List    ${Names}    ${random_name_index}
    # Ensure no spaces exist in the generated string
    ${random_domain}=    Generate Random String    4    0123456789
    ${email}=    Set Variable    ${random_user}@robotuser${random_domain}.test
    RETURN    ${email}

Generate Random Email Driver
    ${Names}=   Create List   James    John    Michael    David    Sarah    Emma
    Append To List    ${Names}    Oliver    Mia    Sophia    William  Benjamin    Lucas    Jack    Henry
    Append To List    ${Names}     Samuel    Grace    Lily    Ava    Charlotte    Thomas     Isabella    Amelia
    ${names_length}=    Evaluate    len(${Names})
    ${random_name_index}=    Evaluate    random.randint(0, ${names_length} - 1)    modules=random
    ${random_user}=    Get From List    ${Names}    ${random_name_index}
    # Ensure no spaces exist in the generated string
    ${random_domain}=    Generate Random String    4    0123456789
    ${email}=    Set Variable    ${random_user}@robotdriver${random_domain}.test
    RETURN    ${email}

Generate Random number
    ${random_number}=       Generate Random String   8   0123456789
    RETURN  ${random_number}

Generate derivation code
    ${code}=    Generate Random String    10    0123456789
    ${code_with_postal}=    Catenate    SEPARATOR=-    ${code}    ${postal_code}
    Log    ${code_with_postal}
    RETURN    ${code_with_postal}

Generate Random contents
   ${Contents}=   Create List       What services do you offer     How do I book a shipment       How can I track my shipment
    Append To List    ${Contents}     Do you offer international shipping     Book online or contact our sales team    Offer air, sea, and ground transportation
    Append To List    ${Contents}     Tracking number provided via email     We handle international shipments    Can I track my delivery
    ${names_length}=    Evaluate    len(${Contents})
    ${random_name_index}=    Evaluate    random.randint(0, ${names_length} - 1)    modules=random
    ${random_user}=    Get From List    ${Contents}    ${random_name_index}
    ${random_string}=    Generate Random String    4    [01234]
    ${random_string}=    Replace String    ${random_string}    [    ${EMPTY}
    ${random_string}=    Replace String    ${random_string}    ]    ${EMPTY}
    ${random_name}=     Catenate   ${random_user}  Robotcontents       ${random_string}
    RETURN    ${random_name}