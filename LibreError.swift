//
//  File.swift
//  
//
//  Created by Lasha Maruashvili on 13.12.21.
//

import Foundation

public struct LibreError : Error {
    let errorCode: Int
    let errorMessage: String
    
    init(errorCode: Int, errorMessage: String) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }
}
