//
//  File.swift
//  
//
//  Created by Christiano Gontijo on 03/06/2024.
//

enum MacroError: CustomStringConvertible, Error {
    case onlyApplicableToEnum(macroName: String)

    var description: String {
        switch self {
        case .onlyApplicableToEnum(macroName: let macroName):
            return "@\(macroName) can only be applied to an enum"
        }

    }

}
