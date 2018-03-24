//
//  XCTestCase+Localizations.swift
//  YourDay
//
//  Created by André Claaßen on 01.03.16.
//  Copyright © 2016 Andre Claaßen. All rights reserved.
//

import Foundation
import XCTest
import YourGoals

extension XCTestCase {
    
    /// extract the system language and elimnate all variants of "en-XX".
    var systemLanguage: String {
        let sysLanguage = Locale.preferredLanguages[0]
        if sysLanguage.left$(2) == "en" {
            return "en"
        }
        
        return sysLanguage
    }
    
    func assertLanguage(_ language:String) {
        XCTAssert(["de-DE", "en"].any({$0 == language}), "unsupported language")
        XCTAssert(["de-DE", "en"].any({$0 == self.systemLanguage}), "unsupported system language")
    }
    
    func XCTAssertLocalized(_ language:String, _ expression: @autoclosure () -> Bool ) {
        
        assertLanguage(language)
        guard language == systemLanguage else {
            return
        }
        
        XCTAssert(expression())
    }
    
    func XCTAssertEqualLocalized(_ language:String, _ referenceString:String, _ actualString:String) {
        assertLanguage(language)
        let systemLanguage = Locale.preferredLanguages[0]
        
        guard language == systemLanguage else {
            return
        }
        
        XCTAssertEqual(referenceString, actualString)
    }
    
    func XCTLocalizedString(_ localizedStringsHash:[String:String]) -> String {
        return localizedStringsHash[systemLanguage]!
    }
}

