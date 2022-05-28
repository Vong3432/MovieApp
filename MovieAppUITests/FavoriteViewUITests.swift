//
//  FavoriteViewUITests.swift
//  MovieAppUITests
//
//  Created by Vong Nyuksoon on 28/05/2022.
//

import XCTest
//@testable import MovieApp

// Naming structure: test_unitOfWork_stateUnderTest_expectedBehavior
// Naming structure: test_[struct]_[ui component]_[expectedBehavior]
// Testing structure: Given, When, Then
class FavoriteViewUITests: XCTestCase {

    let app = XCUIApplication()
    var testFavoriteMovie: XCUIElement? = nil
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // set app to test env
        app.launchEnvironment = ["UITESTS":"1"]

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        // pre-signin
        app.tabBars["Tab Bar"].buttons["Profile"].tap()
        app.buttons["Login"].tap()
        
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
        
        XCTAssertTrue(signInBtn.isEnabled)
        signInBtn.tap()
        
        sleep(3)
        app.swipeUp()
        
        // Mark random movie as favorite for testing
        app.tabBars["Tab Bar"].buttons["Home"].tap()
        let firstCell = app.tables["HomeList"].cells.firstMatch
        testFavoriteMovie = firstCell
        firstCell.tap()
        
        // load data
        sleep(3)
        
        let favoriteBtn = app.buttons["FavoriteBtn"].firstMatch
        XCTAssertTrue(favoriteBtn.exists)
        favoriteBtn.tap()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
    }

    func test_FavoriteView_movieRowView_shouldNavigateToDetailWhenTapped() {
        // Given
        app.tabBars["Tab Bar"].buttons["Favorite"].tap()
        let list = app.tables["FavoriteList"]
        let firstCell = list.cells.firstMatch

        // When
        firstCell.tap()

        // wait for 3s
        sleep(3)

        // Then
        let title = app.staticTexts["MovieTitle"]
        XCTAssertTrue(title.exists)
    }
    
    func test_FavoriteView_movieRowView_shouldRemoveWhenSwipe() {
        
        // Given
//        app.tabBars["Tab Bar"].buttons["Favorite"].tap()
//        let list = app.tables["FavoriteList"]
//
//        guard let testFavoriteMovie = testFavoriteMovie else {
//            XCTestError(_nsError: NSError(domain: "Error test favorite movie empty", code: 10001, userInfo: nil))
//            return
//        }
//
//        let targetCell = list.cells[testFavoriteMovie.title].firstMatch
//
//        // When
//        targetCell.swipeLeft(velocity: .slow)
//        let deleteBtn = targetCell.buttons["Delete"]
//        XCTAssertTrue(deleteBtn.exists)
//
//        deleteBtn.tap() // perform deletion
//
//        // Then
//        XCTAssertFalse(targetCell.exists)
    }

}
