*** Settings ***
Library    Collections
Library    RequestsLibrary
Library    String
Library    DateTime
Library    OperatingSystem
Library    BuiltIn
Library    Process
Library    Browser

*** Variables ***
${Site_URL}      https://bo.test.kanguro.com/auth/login?
${TIMES}    100
${Email_locator}       id=:r0:
${Password_locator}    id=:r1:
${continue_button_locator}   css=button[class='MuiButtonBase-root MuiButton-root MuiButton-contained MuiButton-containedPrimary MuiButton-sizeLarge MuiButton-containedSizeLarge MuiButton-disableElevation MuiButton-fullWidth css-bwnq0a']
${Customer_option_locator}   xpath=//a[@href='/recipients']
${Advance_filter_button-locator}     css=button[class='MuiButtonBase-root MuiButton-root MuiButton-contained MuiButton-containedPrimary MuiButton-sizeMedium MuiButton-containedSizeMedium MuiButton-disableElevation css-1prp8n9']
${Column_name_locator}  xpath=//input[@id='column-label-id']
${Filter_phone_drop-down_locator}     xpath=//li[@role="option" and text()="Phone"]
${Search_key_locator}   id=value-label-id
${meatball_menu_locator}        xpath=//tbody/tr[1]/td[1]/button[1]//*[name()='svg']
${customer_delete_locator}   xpath=//li[normalize-space()='Delete']
${Apply_filter_locator}    xpath=//button[contains(@class, "MuiButtonBase-root") and text()='Apply filters']
${name_locator}     xpath=//li[@role="option" and text()='Name']
${delete_pop-up_button_locator}  xpath=//button[@type="button" and text()='Delete']
${dealers_locators}  xpath=//div[@class="MuiBox-root css-i9gxme" and text()='Delivery drivers']
${table_row_locator}   xpath=//tr[@class="MuiTableRow-root MuiTableRow-hover css-cadlvo"][1]
${delete_button_locator}  xpath=//a[contains(@class,"MuiButtonBase") and text()="Delete"]
${Advance_filter_locator}  xpath=//button[@type='button']//span["Advance filters"]
${courier_locator}      xpath=//div[@class="MuiBox-root css-i9gxme" and contains(text(),"Couriers")]
${configuration_side_menu_locator}   xpath=//div[text()="Configuration"]
${Special_telephone_locator}        xpath=//div[text()="Special telephones"]
${base_url}     https://api.test.kanguro.com/api
${Special_phone_get_list_endpoint}     /v1/admin/specialPhones/list?pageNumber=0&pageSize=100
${Delete_special_phone_endpoint}      /v1/admin/specialPhones/
${Admin_login_endpoint}     /v1/admin/auth/login-email
${Delete_special_schedule_endpoint}     /v1/admin/specialPhones/

*** Keywords ***
Opening the browser and navigate to URL
    New Browser    chromium    headless=False  timeout=500
    New Context    viewport={'width': 1600, 'height': 900}
    New Page    about:blank
    Go To    ${Site_URL}    wait_until=domcontentloaded     timeout=60

Login into the back office
    Wait For Elements State    css=input[name='email']  state=stable     timeout=60
    Fill Text    css=input[name='email']    test@kanguro.com
    Wait For Elements State   css=input[name='password']   state=stable   timeout=30
    Fill Text    css=input[name='password']    password
    ${Continue_button_status}=  Run Keyword And Return Status    Wait For Elements State   ${Continue_button_locator}   state=stable  timeout=10
    Run Keyword If    '${Continue_button_status}' == 'visible'      Click   ${Continue_button_locator}
    ...  ELSE
    ...  Log   Clicking spanish continue button
    Click   xpath=//button[@type="button" and contains(.,"Continuar")]
    Check the web app language is in English or in Spanish

*** Keywords ***
Check the web app language is in English or in Spanish
    ${Language_status}=     Run Keyword And Return Status    Wait For Elements State  xpath=//a[contains(.,'Inicio')]   state=stable    timeout=10
    Run Keyword If    '${Language_status}' == 'visible'
    ...  Change app language to english
    ...  ELSE
    ...  Log    The app language is in english and did not need to change the language

Change app language to english
    Wait For Elements State   css=button#basic-button  state=stable  timeout=60
    Click   css=button#basic-button
    Wait For Elements State    xpath=//li[@role='menuitem' and contains(.,'English')]  state=stable     timeout=20

Click the customer option 
    Wait For Elements State    ${Customer_option_locator}    state=stable   timeout=60
    Click     ${Customer_option_locator}

Click the courier option
    Wait For Elements State    ${courier_locator}     state=stable   timeout=60
    Click     ${courier_locator}

Click the delivery driver option
    Wait For Elements State    ${dealers_locators}   state=stable  timeout=60
    Click  ${dealers_locators}

Click advanced filter option
    Wait For Elements State    ${Advance_filter_locator}     state=stable  timeout=20
    Click    ${Advance_filter_locator}

Click column drop-down in filter
    Wait For Elements State    ${Column_name_locator}      state=stable  timeout=10
    Click    ${Column_name_locator}

Click name in filter drop-down
    Wait For Elements State    ${name_locator}   state=stable   timeout=10
    Click    ${name_locator}

Click phone in column
    Wait For Elements State    ${Column_name_locator}      state=stable  timeout=10

Enter the search key
    [Arguments]      ${search_key}
    Wait For Elements State   ${Search_key_locator}   state=stable       timeout=10
    Fill Text    ${Search_key_locator}    ${search_key}

Click apply filter button locator
    Wait For Elements State    ${Apply_filter_locator}    state=stable     timeout=10
    Click   ${Apply_filter_locator}

Deleting the customer
     Wait For Elements State    ${meatball_menu_locator}   state=stable   timeout=60
     Click    ${meatball_menu_locator}
     Wait For Elements State    ${customer_delete_locator}    state=stable      timeout=60
     Click    ${customer_delete_locator}
     Wait For Elements State    ${delete_pop-up_button_locator}   state=stable  timeout=60
     Click    ${delete_pop-up_button_locator}

Deleting the dealers
     Wait For Elements State    ${table_row_locator}    state=stable   timeout=60
     Click    ${table_row_locator}
     Wait For Elements State    ${delete_button_locator}    state=stable  timeout=10
     Click   ${delete_button_locator}
     Wait For Elements State    ${delete_pop-up_button_locator}   state=stable  timeout=10
     Click    ${delete_pop-up_button_locator}

Click configuration side menu
    Wait For Elements State    ${configuration_side_menu_locator}   state=stable    timeout=20
    Click    ${configuration_side_menu_locator}

Click special telephone option
    Wait For Elements State    ${Special_telephone_locator}  state=stable      timeout=20
    Click    ${Special_telephone_locator}

Click phone option in the column
    Wait For Elements State    ${Filter_phone_drop-down_locator}    state=stable    timeout=10
    Click    ${Filter_phone_drop-down_locator}

Deleting the special phone numbers
     Wait For Elements State    ${table_row_locator}    state=stable   timeout=60
     Click    ${table_row_locator}
     Wait For Elements State    ${delete_button_locator}    state=stable  timeout=10
     Click   ${delete_button_locator}
     Wait For Elements State    ${delete_pop-up_button_locator}   state=stable  timeout=10
     Click    ${delete_pop-up_button_locator}

Admin login
    ${headers}=   Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    email=test@kanguro.com     password=password
    ${response}=   Post    ${base_URL}${Admin_login_endpoint}    headers=${HEADERS}    json=${data}
    ${response_json}=        Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    Should Be Equal As Strings    ${response.status_code}    200
    ${response_dict}=    Evaluate    json.loads($response.content)    json
    ${accessToken}=    Get From Dictionary    ${response_dict}    accessToken    default=None
    ${Admin_token}=    Set Variable    Bearer ${accessToken}
    Log    accessToken: ${accessToken}
    Log    driver_token: ${Admin_token}
    Should Not Be Empty    ${accessToken}
    RETURN    ${Admin_token}

Getting special phone list via API
    [Arguments]  ${Admin_token}
    ${headers}=     Create Dictionary    Content-Type=application/json      Authorization=${Admin_token}
    ${response}=    GET  ${base_url}${Special_phone_get_list_endpoint}      headers=${headers}
    ${response_json}=        Evaluate    json.loads($response.content)    json
    ${special_phone_id}=    Set Variable    ${response_json['items'][0]['id']}
    RETURN   ${special_phone_id}

Delete special schedule
    [Arguments]  ${Admin_token}     ${special_phone_id}
    ${headers}=     Create Dictionary    Content-Type=application/json      Authorization=${Admin_token}
    ${response}=    DELETE  ${base_url}${Delete_special_schedule_endpoint}${special_phone_id}      headers=${headers}

