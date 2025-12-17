*** Settings ***
Library    Collections
Resource    ../../Resources/BackendUtils/BackendAuth.robot
Resource    ../../Resources/BackendUtils/AdminCampaigns.robot

*** Test Cases ***
Verify that the user is able to add and publish the Amazon page campaign
    [Tags]  Add_and_publish_Amazon_page_campaign
    #Login as admin
    ${Admin_token}=     Login as admin backend
    #Adding a new Amazon page campaign
    ${Campaign_id}=     Creating a new Amazon page campaign    ${Admin_token}
    #Publishing the campaign
    Publishing the campaign    ${Admin_token}    ${Campaign_id}

Verify that the user is able to add and publish the inventory page campaign
    [Tags]  Add_and_publish_inventory_page_campaign
    #Login as admin
    ${Admin_token}=     Login as admin backend
    #Adding a new inventory page campaign
    ${Campaign_id}=     Creating a new inventory page campaign    ${Admin_token}
    #Publishing the campaign
    Publishing the campaign    ${Admin_token}    ${Campaign_id}

Verify that the user is able to add and publish the profile page campaign
    [Tags]  Add_and_publish_profile_page_campaign
    #Login as admin
    ${Admin_token}=     Login as admin backend
    #Adding a new profile page campaign
    ${Campaign_id}=     Creating a new profile page campaign    ${Admin_token}
    #Publishing the campaign
    Publishing the campaign    ${Admin_token}    ${Campaign_id}

Verify that the user is able to add and publish the profile KP page campaign
    [Tags]  Add_and_publish_profile_KP_page_campaign
    #Login as admin
    ${Admin_token}=     Login as admin backend
    #Adding a new profile KP page campaign
    ${Campaign_id}=     Creating a new profile KP page campaign    ${Admin_token}
    #Publishing the campaign
    Publishing the campaign    ${Admin_token}    ${Campaign_id}

Verify that the user is able to add and publish the profile courier page campaign
    [Tags]  Add_and_publish_profile_courier_page_campaign
    #Login as admin
    ${Admin_token}=     Login as admin backend
    #Adding a new profile courier page campaign
    ${Campaign_id}=     Creating a new profile courier page campaign    ${Admin_token}
    #Publishing the campaign
    Publishing the campaign    ${Admin_token}    ${Campaign_id}

Verify that the user is able to add and publish the profile billing info page campaign
    [Tags]  Add_and_publish_profile_billing_info_page_campaign
    #Login as admin
    ${Admin_token}=     Login as admin backend
    #Adding a new profile billing info page campaign
    ${Campaign_id}=     Creating a new profile billing info page campaign    ${Admin_token}
    #Publishing the campaign
    Publishing the campaign    ${Admin_token}    ${Campaign_id}

Verify that the user is able to add and publish the profile billing invoice page campaign
    [Tags]  Add_and_publish_profile_billing_invoice_page_campaign
    #Login as admin
    ${Admin_token}=     Login as admin backend
    #Adding a new profile billing invoice page campaign
    ${Campaign_id}=     Creating a new profile billing invoice page campaign    ${Admin_token}
    #Publishing the campaign
    Publishing the campaign    ${Admin_token}    ${Campaign_id}

Verify that the user is able to add and publish the profile configuration page campaign
    [Tags]  Add_and_publish_profile_configuration_page_campaign
    #Login as admin
    ${Admin_token}=     Login as admin backend
    #Adding a new profile configuration page campaign
    ${Campaign_id}=     Creating a new profile configuration page campaign    ${Admin_token}
    #Publishing the campaign
    Publishing the campaign    ${Admin_token}    ${Campaign_id}

Verify that the user is able to add and publish the profile business schedule page campaign
    [Tags]  Add_and_publish_profile_business_schedule_page_campaign
    #Login as admin
    ${Admin_token}=     Login as admin backend
    #Adding a new profile business schedule page campaign
    ${Campaign_id}=     Creating a new profile business schedule page campaign    ${Admin_token}
    #Publishing the campaign
    Publishing the campaign    ${Admin_token}    ${Campaign_id}

Verify that the user is able to add and publish the profile holiday schedule page campaign
    [Tags]  Add_and_publish_profile_holiday_schedule_page_campaign
    #Login as admin
    ${Admin_token}=     Login as admin backend
    #Adding a new profile holiday schedule page campaign
    ${Campaign_id}=     Creating a new profile holiday schedule page campaign    ${Admin_token}
    #Publishing the campaign
    Publishing the campaign    ${Admin_token}    ${Campaign_id}

Verify that the user is able to add and publish the support page campaign
    [Tags]  Add_and_publish_support_page_campaign
    #Login as admin
    ${Admin_token}=     Login as admin backend
    #Adding a new support page campaign
    ${Campaign_id}=     Creating a new support page campaign    ${Admin_token}
    #Publishing the campaign
    Publishing the campaign    ${Admin_token}    ${Campaign_id}

Verify that the user is able to add and publish the FAQ page campaign
    [Tags]  Add_and_publish_FAQ_page_campaign
    #Login as admin
    ${Admin_token}=     Login as admin backend
    #Adding a new FAQ page campaign
    ${Campaign_id}=     Creating a new FAQ page campaign    ${Admin_token}
    #Publishing the campaign
    Publishing the campaign    ${Admin_token}    ${Campaign_id}

Verify that the user is able to add and publish the scanner page campaign
    [Tags]  Add_and_publish_scanner_page_campaign
    #Login as admin
    ${Admin_token}=     Login as admin backend
    #Adding a new scanner page campaign
    ${Campaign_id}=     Creating a new scanner page campaign    ${Admin_token}
    #Publishing the campaign
    Publishing the campaign    ${Admin_token}    ${Campaign_id}