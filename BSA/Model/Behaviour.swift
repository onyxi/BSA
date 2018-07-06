//
//  Behaviour.swift
//  BSA
//
//  Created by Pete Holdsworth on 27/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import Foundation

class Behaviour: Equatable {
    
    static func == (lhs: Behaviour, rhs: Behaviour) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String!
    let type: String!
    
    init(id: String, type: String!) {
        self.id = id
        self.type = type
    }
    
}
