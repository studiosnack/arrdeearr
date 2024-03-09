//
//  arrdeearrApp.swift
//  arrdeearr
//
//  Created by Marcos Ojeda on 3/2/24.
//

import SwiftUI

@main
struct arrdeearrApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: arrdeearrDocument(version: 1)) { config in
            ContentView(document: config.$document)
        }
    }
}
