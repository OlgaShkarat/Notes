//
//  TransitionStyleModel.swift
//  Notes
//
//  Created by Ольга on 23.08.2020.
//  Copyright © 2020 Ольга. All rights reserved.
//

import Foundation

enum TransitionStyle {
    case root
    case modal
}

enum TransitionError: Error {
    case navigationControllerMissing
    case connotPop
    case unknown
}
