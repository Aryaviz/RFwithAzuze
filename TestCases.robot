*** Settings ***
Documentation  Auto1/QA Task
Library      SeleniumLibrary
Library      String
Library      helpers.HelpLib
Library      Collections    
Suite Setup  Open URL Locally
Suite Teardown  Close Browser


*** Test Cases ***
TC1 - Check Filters on Advanced Searh Page
    Given Open URL AutoHero
    And User is on Advanced Search Page
    When User Select Filter for First registration
    And User Select Filter for Price Decsending
    Then Verify all cars are filtered by First Registration
    And Verify all Cars are Filtered By Price Descending


*** Keywords ***
Open Tests in Souce Labs
    ${desired_capabilities}=    Create Dictionary
    Set to Dictionary    ${desired_capabilities}    build    test_run
    Set to Dictionary    ${desired_capabilities}    platformName    Windows 10
    Set to Dictionary    ${desired_capabilities}    name    Auto1
    Set to Dictionary    ${desired_capabilities}    browserName    chrome

    ${executor}=    Evaluate          str('http://milan.novovic:0f772a45-b623-4d44-a01f-9a1db40f0d5d@ondemand.saucelabs.com:80/wd/hub')
    Create Webdriver    Remote      desired_capabilities=${desired_capabilities}    command_executor=${executor}   


Open URL Locally
    Open Browser    https://www.autohero.com/de/search/    chrome
    Maximize Browser Window

Open URL AutoHero
    Go To    https://www.autohero.com/de/search/   

User is on Advanced Search Page
    Sleep   5s
    Click Element                       //button[contains(text(),'Erweiterte Suche')]
    Wait Until Element Is Visible       //span[contains(text(),'Erstzulassung ab')]

User Select Filter for First registration
    Click Element                        //span[contains(text(),'Erstzulassung ab')]
    Wait Until Element Is Visible        //select[@name='yearRange.min']/*[text()='2014']   
    Click Element                        //select[@name='yearRange.min']/*[text()='2014']
    Sleep   3s
    Click Element                        //a[contains(text(),'Ergebnisse')]

Verify all cars are filtered by first registration

#This Keyword  will take all elements with registration, 
#pass it to python method which will return if there are registration before 2014
 
    Sleep   3s
    @{locators}    Get Webelements      //*[contains(@class,'specItem___')][1]
    ${result}=       Create List
    :FOR   ${locator}   IN    @{locators}
        \       ${name}=    Get Text    ${locator}
        \       Append To List  ${result}  ${name}         

    ${yearsSorted}=    Return Years Only    ${result}

    #python script to check if there are registration before 2014
    ${boleanY}=    Registration    ${yearsSorted}

    Should Be Equal as Strings     ${boleanY}   True

    #list with registration
    Log  ${yearsSorted}
    Log  ${boleanY}


User Select Filter for Price Decsending 
    Wait Until Element Is Visible    //select[contains(@name,'sort')]  
    Click Element                    //select[contains(@name,'sort')]
    Sleep   2s
    Click Element                    //*[text()='Höchster Preis']

Verify all Cars are Filtered By Price Descending

#Take all prices, create a list, and return as float so to check if list is sorted

    Sleep   2s
    @{locators}    Get Webelements      //*[contains(@class,'totalPrice')][1]
    ${priceAll}=       Create List
    :FOR   ${locator}   IN    @{locators}
        \       ${name}=    Get Text    ${locator}
        \       Append To List  ${priceAll}  ${name}     

    ${prices}=    Return Price Only    ${priceAll}

    ${sortPrices}=    Sorted List     ${prices}

    Should Be Equal as Strings     ${sortPrices}   True

    Log  ${prices}
    Log  ${priceAll}   


 








