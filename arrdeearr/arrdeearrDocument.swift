//
//  arrdeearrDocument.swift
//  arrdeearr
//
//  Created by Marcos Ojeda on 3/2/24.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var exampleText: UTType {
        UTType(importedAs: "com.example.plain-text")
    }
  static var rdrwPackage: UTType {
    UTType(importedAs: "cx.generic.rdrw-doc")
  }
}

struct RDRWMetaService: Codable {
  let version: String;
}


struct arrdeearrDocument: FileDocument {
  var version: Int
  var store: RDRWStore?

  init(version: Int = 1, store: RDRWStore = RDRWStore()) {
    self.version = version
    self.store = store;
  }

  static var readableContentTypes: [UTType] { [.exampleText, .rdrwPackage] }

  init(configuration: ReadConfiguration) throws {
    let decoder = JSONDecoder()
    let wrapper = configuration.file.fileWrappers
    guard let data = wrapper?["config.json"]?.regularFileContents
    else {
        throw CocoaError(.fileReadCorruptFile)
    }
    let jsonData = try decoder.decode(RDRWDbService.self, from: data)
    version = 1
    store = jsonData.mainstore
  }

  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    let data = "text".data(using: .utf8)!
    return .init(regularFileWithContents: data)
  }
}
