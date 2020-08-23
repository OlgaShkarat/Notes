//
//  Task.swift
//  Notes
//
//  Created by Ольга on 16.08.2020.
//  Copyright © 2020 Ольга. All rights reserved.
//

import Foundation

struct Task: Equatable {
    var content: String
    
    init(content: String) {
        self.content = content
    }
    
    init(original: Task, updateContent: String) {
        self = original
        self.content = updateContent
    }
}
