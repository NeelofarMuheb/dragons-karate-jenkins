@Regression
Feature: Create Account Test

  Background: API Test Setup
    #callonce read is Karate Step to execute and read another feature file.
    #the result of callonce can store into new variable using def step.
    * def result = callonce read('GenerateToken.feature')
    And print result
    * def generatedToken = result.response.token
    Given url "https://tek-insurance-api.azurewebsites.net"

  Scenario: Create Account
    Given path "/api/accounts/add-primary-account"
    And header Authorization = "Bearer " + generatedToken
    And request
      """
      {
      "email": "shokriyan_karate3@tekschool.us",
      "firstName": "Mohammad",
      "lastName": "Shokriyan",
      "title": "Mr.",
      "gender": "MALE",
      "maritalStatus": "SINGLE",
      "employmentStatus": "Software Developer",
      "dateOfBirth": "1988-02-27"
      }
      """
    When method post
    Then status 201
    And print response
    And assert response.email == "shokriyan_karate3@tekschool.us"
    #Delete created account
    Given path "/api/accounts/delete-account"
    And header Authorization = "Bearer " + generatedToken
    And param primaryPersonId = response.id
    When method delete
    Then status 200
    And print response
    And assert response == "Account Successfully deleted"