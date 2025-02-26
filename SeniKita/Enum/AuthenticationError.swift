//
//  AuthenticationError.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 25/02/25.
//

import Foundation

enum AuthenticationError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
}
