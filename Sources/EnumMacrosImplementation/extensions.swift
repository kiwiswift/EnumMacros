//
//  File.swift
//  
//
//  Created by Christiano Gontijo on 03/06/2024.
//

extension String {
    var capitalisedFirstLetter: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst()
        return firstLetter + remainingLetters
    }
}
