//
//  Storage.swift
//  Notes
//
//  Created by Ольга on 28.08.2020.
//  Copyright © 2020 Ольга. All rights reserved.
//

import Foundation

class DataManager {
    
    var archiveURL: URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentDirectory.appendingPathComponent("Notes").appendingPathExtension("plist")
    }
    
    func loadEvents() -> [Task]? {
        guard let archiveURL = archiveURL else { return nil }
        guard let encodedEmojis = try? Data(contentsOf: archiveURL) else { return nil }
        let decoder = PropertyListDecoder()
        return try? decoder.decode([Task].self, from: encodedEmojis)
    }
    
    func saveEvents(_ events: [Task]) {
        guard let archiveURL = archiveURL else { return }
        let encoder = PropertyListEncoder()
        guard let encodedEmojis = try? encoder.encode(events) else { return }
        try? encodedEmojis.write(to: archiveURL, options: .noFileProtection)
    }
}
