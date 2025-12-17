*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    json
Library    String
Library    DateTime
Library    OperatingSystem
Library    BuiltIn
Library    Process
Library    DateTime
Resource   BackendMainconfig.robot
Resource   ../../Resources/CommonUtils/CommonUtils.robot

*** Variables ***
${Campaign_title}   new robot campaign
${Subtitle}     Campaign subtitle
${Image}    campaigns/9b1043f004fa45ab7fc427449f7c7e63e.png
${Audience_file}    counterCampaign/aa1210c7f65951101d77fbf812b99555ab.csv
${Channel}      mobile
${Amazon_page_deep_link}        App/AmazonViewer
${Inventory_page_deep_link}      App/HistoryStack
${Profile_page_deep_link}          App/ProfileStack/Profile
${Profile_KP_page_deep_link}         App/ProfileStack/KanguroPointInfo
${Profile_courier_page_deep_link}      App/ProfileStack/CouriersPage
${Profile_billing_info_page_deep_link}   App/ProfileStack/BillingStack/BillingInfoPage
${Profile_billing_invoice_page_deep_link}    App/ProfileStack/BillingStack/InvoicesPage
${Profile_configuration_page_deep_link}       App/ProfileStack/Configuration
${Profile_business_schedule_page_deep_link}      App/ProfileStack/BusinessSchedule
${Profile_special_schedule_page_deep_link}       App/ProfileStack/SpecialSchedule
${Profile_holiday_schedule_page_deep_link}       App/ProfileStack/HolidaysSchedule
${Support_page_deep_link}       App/SupportStack/SupportPage
${FAQ_page_deep_link}           App/SupportStack/FAQ
${Scanner_page_deep_link}       App/CounterActions/Scan

*** Keywords ***
Creating a new Amazon page campaign
    [Arguments]     ${Admin_token}
    ${header}=  Create Dictionary   Content-Type=application/json       Authorization=${Admin_token}
    ${content}=  Create Dictionary      title=Amazon page    subtitle=Amazon page deep link notification     deepLink=${Amazon_page_deep_link}    image=${Image}
    ${data}=    Create Dictionary   title=${Campaign_title}    subtitle=${Subtitle}    audienceFile=${Audience_file}    channel=${Channel}   content=${content}   isPublish=${False}
    ${response}=    POST    ${base_URL}${Create_campaign_endpoint}      headers=${header}     json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)   json
    #Assertion
    Should Be True    'title' in ${response_json}   title is missing in the response
    Should Be True    'subtitle' in ${response_json}   subtitle is missing in the response
    Should Be True    'channel' in ${response_json}   channel is missing in the response
    Should Be True    'id' in ${response_json}   id is missing in the response
    #Extracting the values
    ${Campaign_id}=  Get From Dictionary    ${response_json}    id
    Log    ${Campaign_id}
    RETURN    ${Campaign_id}

Creating a new inventory page campaign
    [Arguments]     ${Admin_token}
    ${header}=  Create Dictionary   Content-Type=application/json       Authorization=${Admin_token}
    ${content}=  Create Dictionary      title=Inventory page    subtitle=Inventory page deep link notification     deepLink=${Inventory_page_deep_link}    image=${Image}
    ${data}=    Create Dictionary   title=${Campaign_title}    subtitle=${Subtitle}    audienceFile=${Audience_file}    channel=${Channel}   content=${content}   isPublish=${False}
    ${response}=    POST    ${base_URL}${Create_campaign_endpoint}      headers=${header}     json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)   json
    #Assertion
    Should Be True    'title' in ${response_json}   title is missing in the response
    Should Be True    'subtitle' in ${response_json}   subtitle is missing in the response
    Should Be True    'channel' in ${response_json}   channel is missing in the response
    Should Be True    'id' in ${response_json}   id is missing in the response
    #Extracting the values
    ${Campaign_id}=  Get From Dictionary    ${response_json}    id
    Log    ${Campaign_id}
    RETURN    ${Campaign_id}

Creating a new profile page campaign
    [Arguments]     ${Admin_token}
    ${header}=  Create Dictionary   Content-Type=application/json       Authorization=${Admin_token}
    ${content}=  Create Dictionary      title=Profile page    subtitle=Profile page deep link notification     deepLink=${Profile_page_deep_link}    image=${Image}
    ${data}=    Create Dictionary   title=${Campaign_title}    subtitle=${Subtitle}    audienceFile=${Audience_file}    channel=${Channel}   content=${content}   isPublish=${False}
    ${response}=    POST    ${base_URL}${Create_campaign_endpoint}      headers=${header}     json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)   json
    #Assertion
    Should Be True    'title' in ${response_json}   title is missing in the response
    Should Be True    'subtitle' in ${response_json}   subtitle is missing in the response
    Should Be True    'channel' in ${response_json}   channel is missing in the response
    Should Be True    'id' in ${response_json}   id is missing in the response
    #Extracting the values
    ${Campaign_id}=  Get From Dictionary    ${response_json}    id
    Log    ${Campaign_id}
    RETURN    ${Campaign_id}

Creating a new profile KP page campaign
    [Arguments]     ${Admin_token}
    ${header}=  Create Dictionary   Content-Type=application/json       Authorization=${Admin_token}
    ${content}=  Create Dictionary      title=Profile KP page    subtitle=Profile KP page deep link notification     deepLink=${Profile_KP_page_deep_link}    image=${Image}
    ${data}=    Create Dictionary   title=${Campaign_title}    subtitle=${Subtitle}    audienceFile=${Audience_file}    channel=${Channel}   content=${content}   isPublish=${False}
    ${response}=    POST    ${base_URL}${Create_campaign_endpoint}      headers=${header}     json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)   json
    #Assertion
    Should Be True    'title' in ${response_json}   title is missing in the response
    Should Be True    'subtitle' in ${response_json}   subtitle is missing in the response
    Should Be True    'channel' in ${response_json}   channel is missing in the response
    Should Be True    'id' in ${response_json}   id is missing in the response
    #Extracting the values
    ${Campaign_id}=  Get From Dictionary    ${response_json}    id
    Log    ${Campaign_id}
    RETURN    ${Campaign_id}

Creating a new profile courier page campaign
    [Arguments]     ${Admin_token}
    ${header}=  Create Dictionary   Content-Type=application/json       Authorization=${Admin_token}
    ${content}=  Create Dictionary      title=Profile courier page    subtitle=Profile courier page deep link notification     deepLink=${Profile_courier_page_deep_link}    image=${Image}
    ${data}=    Create Dictionary   title=${Campaign_title}    subtitle=${Subtitle}    audienceFile=${Audience_file}    channel=${Channel}   content=${content}   isPublish=${False}
    ${response}=    POST    ${base_URL}${Create_campaign_endpoint}      headers=${header}     json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)   json
    #Assertion
    Should Be True    'title' in ${response_json}   title is missing in the response
    Should Be True    'subtitle' in ${response_json}   subtitle is missing in the response
    Should Be True    'channel' in ${response_json}   channel is missing in the response
    Should Be True    'id' in ${response_json}   id is missing in the response
    #Extracting the values
    ${Campaign_id}=  Get From Dictionary    ${response_json}    id
    Log    ${Campaign_id}
    RETURN    ${Campaign_id}

Creating a new profile billing info page campaign
    [Arguments]     ${Admin_token}
    ${header}=  Create Dictionary   Content-Type=application/json       Authorization=${Admin_token}
    ${content}=  Create Dictionary      title=Profile billing info page    subtitle=Profile billing info page deep link notification     deepLink=${Profile_billing_info_page_deep_link}    image=${Image}
    ${data}=    Create Dictionary   title=${Campaign_title}    subtitle=${Subtitle}    audienceFile=${Audience_file}    channel=${Channel}   content=${content}   isPublish=${False}
    ${response}=    POST    ${base_URL}${Create_campaign_endpoint}      headers=${header}     json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)   json
    #Assertion
    Should Be True    'title' in ${response_json}   title is missing in the response
    Should Be True    'subtitle' in ${response_json}   subtitle is missing in the response
    Should Be True    'channel' in ${response_json}   channel is missing in the response
    Should Be True    'id' in ${response_json}   id is missing in the response
    #Extracting the values
    ${Campaign_id}=  Get From Dictionary    ${response_json}    id
    Log    ${Campaign_id}
    RETURN    ${Campaign_id}

Creating a new profile billing invoice page campaign
    [Arguments]     ${Admin_token}
    ${header}=  Create Dictionary   Content-Type=application/json       Authorization=${Admin_token}
    ${content}=  Create Dictionary      title=Profile billing invoice page    subtitle=Profile billing invoice page deep link notification     deepLink=${Profile_billing_invoice_page_deep_link}    image=${Image}
    ${data}=    Create Dictionary   title=${Campaign_title}    subtitle=${Subtitle}    audienceFile=${Audience_file}    channel=${Channel}   content=${content}   isPublish=${False}
    ${response}=    POST    ${base_URL}${Create_campaign_endpoint}      headers=${header}     json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)   json
    #Assertion
    Should Be True    'title' in ${response_json}   title is missing in the response
    Should Be True    'subtitle' in ${response_json}   subtitle is missing in the response
    Should Be True    'channel' in ${response_json}   channel is missing in the response
    Should Be True    'id' in ${response_json}   id is missing in the response
    #Extracting the values
    ${Campaign_id}=  Get From Dictionary    ${response_json}    id
    Log    ${Campaign_id}
    RETURN    ${Campaign_id}

Creating a new profile configuration page campaign
    [Arguments]     ${Admin_token}
    ${header}=  Create Dictionary   Content-Type=application/json       Authorization=${Admin_token}
    ${content}=  Create Dictionary      title=Profile configuration page    subtitle=Profile configuration page deep link notification     deepLink=${Profile_configuration_page_deep_link}    image=${Image}
    ${data}=    Create Dictionary   title=${Campaign_title}    subtitle=${Subtitle}    audienceFile=${Audience_file}    channel=${Channel}   content=${content}   isPublish=${False}
    ${response}=    POST    ${base_URL}${Create_campaign_endpoint}      headers=${header}     json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)   json
    #Assertion
    Should Be True    'title' in ${response_json}   title is missing in the response
    Should Be True    'subtitle' in ${response_json}   subtitle is missing in the response
    Should Be True    'channel' in ${response_json}   channel is missing in the response
    Should Be True    'id' in ${response_json}   id is missing in the response
    #Extracting the values
    ${Campaign_id}=  Get From Dictionary    ${response_json}    id
    Log    ${Campaign_id}
    RETURN    ${Campaign_id}

Creating a new profile business schedule page campaign
    [Arguments]     ${Admin_token}
    ${header}=  Create Dictionary   Content-Type=application/json       Authorization=${Admin_token}
    ${content}=  Create Dictionary      title=Profile business schedule page    subtitle=Profile business schedule page deep link notification     deepLink=${Profile_business_schedule_page_deep_link}    image=${Image}
    ${data}=    Create Dictionary   title=${Campaign_title}    subtitle=${Subtitle}    audienceFile=${Audience_file}    channel=${Channel}   content=${content}   isPublish=${False}
    ${response}=    POST    ${base_URL}${Create_campaign_endpoint}      headers=${header}     json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)   json
    #Assertion
    Should Be True    'title' in ${response_json}   title is missing in the response
    Should Be True    'subtitle' in ${response_json}   subtitle is missing in the response
    Should Be True    'channel' in ${response_json}   channel is missing in the response
    Should Be True    'id' in ${response_json}   id is missing in the response
    #Extracting the values
    ${Campaign_id}=  Get From Dictionary    ${response_json}    id
    Log    ${Campaign_id}
    RETURN    ${Campaign_id}

Creating a new profile holiday schedule page campaign
    [Arguments]     ${Admin_token}
    ${header}=  Create Dictionary   Content-Type=application/json       Authorization=${Admin_token}
    ${content}=  Create Dictionary      title=Profile holiday schedule page    subtitle=Profile holiday schedule page deep link notification     deepLink=${Profile_holiday_schedule_page_deep_link}    image=${Image}
    ${data}=    Create Dictionary   title=${Campaign_title}    subtitle=${Subtitle}    audienceFile=${Audience_file}    channel=${Channel}   content=${content}   isPublish=${False}
    ${response}=    POST    ${base_URL}${Create_campaign_endpoint}      headers=${header}     json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)   json
    #Assertion
    Should Be True    'title' in ${response_json}   title is missing in the response
    Should Be True    'subtitle' in ${response_json}   subtitle is missing in the response
    Should Be True    'channel' in ${response_json}   channel is missing in the response
    Should Be True    'id' in ${response_json}   id is missing in the response
    #Extracting the values
    ${Campaign_id}=  Get From Dictionary    ${response_json}    id
    Log    ${Campaign_id}
    RETURN    ${Campaign_id}

Creating a new support page campaign
    [Arguments]     ${Admin_token}
    ${header}=  Create Dictionary   Content-Type=application/json       Authorization=${Admin_token}
    ${content}=  Create Dictionary      title=Support page   subtitle=Support page deep link notification     deepLink=${Support_page_deep_link}    image=${Image}
    ${data}=    Create Dictionary   title=${Campaign_title}    subtitle=${Subtitle}    audienceFile=${Audience_file}    channel=${Channel}   content=${content}   isPublish=${False}
    ${response}=    POST    ${base_URL}${Create_campaign_endpoint}      headers=${header}     json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)   json
    #Assertion
    Should Be True    'title' in ${response_json}   title is missing in the response
    Should Be True    'subtitle' in ${response_json}   subtitle is missing in the response
    Should Be True    'channel' in ${response_json}   channel is missing in the response
    Should Be True    'id' in ${response_json}   id is missing in the response
    #Extracting the values
    ${Campaign_id}=  Get From Dictionary    ${response_json}    id
    Log    ${Campaign_id}
    RETURN    ${Campaign_id}

Creating a new FAQ page campaign
    [Arguments]     ${Admin_token}
    ${header}=  Create Dictionary   Content-Type=application/json       Authorization=${Admin_token}
    ${content}=  Create Dictionary      title=FAQ page   subtitle=FAQ page deep link notification     deepLink=${FAQ_page_deep_link}    image=${Image}
    ${data}=    Create Dictionary   title=${Campaign_title}    subtitle=${Subtitle}    audienceFile=${Audience_file}    channel=${Channel}   content=${content}   isPublish=${False}
    ${response}=    POST    ${base_URL}${Create_campaign_endpoint}      headers=${header}     json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)   json
    #Assertion
    Should Be True    'title' in ${response_json}   title is missing in the response
    Should Be True    'subtitle' in ${response_json}   subtitle is missing in the response
    Should Be True    'channel' in ${response_json}   channel is missing in the response
    Should Be True    'id' in ${response_json}   id is missing in the response
    #Extracting the values
    ${Campaign_id}=  Get From Dictionary    ${response_json}    id
    Log    ${Campaign_id}
    RETURN    ${Campaign_id}

Creating a new scanner page campaign
    [Arguments]     ${Admin_token}
    ${header}=  Create Dictionary   Content-Type=application/json       Authorization=${Admin_token}
    ${content}=  Create Dictionary      title=Scanner page   subtitle=Scanner page deep link notification     deepLink=${Scanner_page_deep_link}    image=${Image}
    ${data}=    Create Dictionary   title=${Campaign_title}    subtitle=${Subtitle}    audienceFile=${Audience_file}    channel=${Channel}   content=${content}   isPublish=${False}
    ${response}=    POST    ${base_URL}${Create_campaign_endpoint}      headers=${header}     json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)   json
    #Assertion
    Should Be True    'title' in ${response_json}   title is missing in the response
    Should Be True    'subtitle' in ${response_json}   subtitle is missing in the response
    Should Be True    'channel' in ${response_json}   channel is missing in the response
    Should Be True    'id' in ${response_json}   id is missing in the response
    #Extracting the values
    ${Campaign_id}=  Get From Dictionary    ${response_json}    id
    Log    ${Campaign_id}
    RETURN    ${Campaign_id}

Publishing the campaign
    [Arguments]     ${Admin_token}  ${Campaign_id}
    ${header}=  Create Dictionary   Content-Type=application/json       Authorization=${Admin_token}
    ${response}=    PATCH        ${base_URL}${Publish_campaign_endpoint}${Campaign_id}      headers=${header}
    Log    Response Body: ${response.content}
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    200

Updating the campaign
    [Arguments]     ${Admin_token}  ${Campaign_id}
    ${header}=  Create Dictionary   Content-Type=application/json       Authorization=${Admin_token}
    ${content}=  Create Dictionary      title=new robot campaign updated    subtitle=new robot campaign updated for test    deepLink=App/HistoryStack   image=campaigns/9b1043f004fa45ab7fc427449f7c7e63e.png
    ${data}=    Create Dictionary   title=Updated campaign 1    subtitle=Updated Campaign subtitle   channel=mobile  content=${content}   isPublish=${False}
    ${response}=    PUT    ${base_URL}${Update_campaign_endpoint}${Campaign_id}      headers=${header}     json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)   json
    #Assertion
    Should Be True    'id' in ${response_json}   id is missing in the response
    Should Be True    'title' in ${response_json}   title is missing in the response
    Should Be True    'subtitle' in ${response_json}   subtitle is missing in the response
    Should Be True    'channel' in ${response_json}   channel is missing in the response