*** Settings ***
Resource    Delete_config.robot

*** Variables ***
${search_key}      Robot

*** Test Cases ***
Delete the driver from back office (no.of times)
    Opening the browser and navigate to URL
    Login into the back office
    Click the courier option
    FOR    ${index}    IN RANGE    1    ${TIMES}+1
    Click the delivery driver option
    Click advanced filter option
    Click column drop-down in filter
    Click name in filter drop-down
    Enter the search key    ${search_key}
    Click apply filter button locator
    Deleting the dealers
    END