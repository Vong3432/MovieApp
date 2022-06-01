//
//  AuthViewUITests.swift
//  MovieAppUITests
//
//  Created by Vong Nyuksoon on 28/05/2022.
//

import XCTest
@testable import MovieApp

// Naming structure: test_unitOfWork_stateUnderTest_expectedBehavior
// Naming structure: test_[struct]_[ui component]_[expectedBehavior]
// Testing structure: Given, When, Then
class AuthViewUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // set app to test env
        app.launchEnvironment = ["UITESTS":"1"]

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
    }

    func test_AuthView_SignInButton_shouldDisabled_whenPwOrEmailIsEmpty() {
        // Given
        app.tabBars["Tab Bar"].buttons["Profile"].tap()
        app.buttons["SignInBtn"].tap()
        
        XCTAssertTrue(app.staticTexts["SignInPageTitle"].exists)
        
        let elementsQuery = app.scrollViews.otherElements
        let usernameTextField = elementsQuery.textFields["UsernameField"]
        let passwordfieldSecureTextField = elementsQuery/*@START_MENU_TOKEN@*/.secureTextFields["PasswordField"]/*[[".secureTextFields[\"Password\"]",".secureTextFields[\"PasswordField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let signInBtn = elementsQuery.buttons["SignInBtn"]
        
        // When
        usernameTextField.doubleTap()
        app.keys["delete"].tap()
        usernameTextField.typeText("\n")
        
        passwordfieldSecureTextField.doubleTap()
        app.keys["delete"].tap()
        passwordfieldSecureTextField.typeText("\n")
        
        // Then
        XCTAssertFalse(signInBtn.isEnabled)
    }
    
    func test_AuthView_SignInButton_shouldEnable_whenPwAndEmailIsFilled() {
        // Given
        app.tabBars["Tab Bar"].buttons["Profile"].tap()
        app.buttons["SignInBtn"].tap()
        
        XCTAssertTrue(app.staticTexts["SignInPageTitle"].exists)
        
        let elementsQuery = app.scrollViews.otherElements
        let usernameTextField = elementsQuery.textFields["UsernameField"]
        let passwordfieldSecureTextField = elementsQuery/*@START_MENU_TOKEN@*/.secureTextFields["PasswordField"]/*[[".secureTextFields[\"Password\"]",".secureTextFields[\"PasswordField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let signInBtn = elementsQuery.buttons["SignInBtn"]
        
        // When
        usernameTextField.doubleTap()
        usernameTextField.typeText("asd")
        app.keys["delete"].tap()
        usernameTextField.typeText("\n")
        
        passwordfieldSecureTextField.doubleTap()
        passwordfieldSecureTextField.typeText("asd")
        app.keys["delete"].tap()
        passwordfieldSecureTextField.typeText("\n")
        
        // Then
        XCTAssertTrue(signInBtn.isEnabled)
    }
    
    func test_AuthView_SignInButton_shouldEnable_whenPwAndEmailIsFilled_butIncorrectCredential() {
        // Given
        app.tabBars["Tab Bar"].buttons["Profile"].tap()
        app.buttons["SignInBtn"].tap()
        
        XCTAssertTrue(app.staticTexts["SignInPageTitle"].exists)
        
        let elementsQuery = app.scrollViews.otherElements
        let usernameTextField = elementsQuery.textFields["UsernameField"]
        let passwordfieldSecureTextField = elementsQuery/*@START_MENU_TOKEN@*/.secureTextFields["PasswordField"]/*[[".secureTextFields[\"Password\"]",".secureTextFields[\"PasswordField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let signInBtn = elementsQuery.buttons["SignInBtn"]
        
        usernameTextField.doubleTap()
        usernameTextField.typeText("asd")
        app.keys["delete"].tap()
        usernameTextField.typeText("\n")
        
        passwordfieldSecureTextField.doubleTap()
        passwordfieldSecureTextField.typeText("asd")
        app.keys["delete"].tap()
        passwordfieldSecureTextField.typeText("\n")
        
        // When
        XCTAssertTrue(signInBtn.isEnabled)
        signInBtn.tap()
        
        // wait for 3s for result
        let exp = expectation(description: "SignInResponse")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            exp.fulfill()
        }
        
        // Then
        wait(for: [exp], timeout: 5)
        let errorMsg = app.staticTexts["FormErrorLabel"]
        XCTAssertTrue(errorMsg.exists)
    }
    
    func test_AuthView_SignInButton_shouldEnable_whenPwAndEmailIsFilled_withCorrectCredential() {
        // Given
        app.tabBars["Tab Bar"].buttons["Profile"].tap()
        app.buttons["SignInBtn"].tap()
        
        XCTAssertTrue(app.staticTexts["SignInPageTitle"].exists)
        
        let elementsQuery = app.scrollViews.otherElements
        let usernameTextField = elementsQuery.textFields["UsernameField"]
        let passwordfieldSecureTextField = elementsQuery/*@START_MENU_TOKEN@*/.secureTextFields["PasswordField"]/*[[".secureTextFields[\"Password\"]",".secureTextFields[\"PasswordField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let signInBtn = elementsQuery.buttons["SignInBtn"]
        
        usernameTextField.doubleTap()
        app.keys["delete"].tap()
        usernameTextField.typeText(Keys.username)
        usernameTextField.typeText("\n")
        
        passwordfieldSecureTextField.doubleTap()
        app.keys["delete"].tap()
        passwordfieldSecureTextField.typeText(Keys.pw)
        passwordfieldSecureTextField.typeText("\n")
        
        // When
        XCTAssertTrue(signInBtn.isEnabled)
        signInBtn.tap()
        
        // wait for 3s for result
        let exp = expectation(description: "SignInResponse")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            exp.fulfill()
        }
        
        // Then
        wait(for: [exp], timeout: 5)
        let errorMsg = app.staticTexts["FormErrorLabel"]
        XCTAssertFalse(errorMsg.exists)
    }

}
