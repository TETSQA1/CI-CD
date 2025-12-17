*** Settings ***
Resource    Delete_config.robot

*** Variables ***
${search_key}      Robot

*** Test Cases ***
Delete the customer from back office (no.of times)
    Opening the browser and navigate to URL
    Login into the back office
    Click the customer option
    Click advanced filter option
    Click column drop-down in filter
    Click name in filter drop-down
    Enter the search key    ${search_key}
    Click apply filter button locator
    FOR    ${index}    IN RANGE    1    ${TIMES}+1
    Deleting the customer
    END