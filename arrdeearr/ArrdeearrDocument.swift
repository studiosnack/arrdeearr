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


struct ArrdeearrDocument: FileDocument {
  var version: Int
  var store: RDRWStore = RDRWStore()

  init(version: Int = 1, store: RDRWStore = RDRWStore()) {
    self.version = version
    self.store = store;
  }

  static var readableContentTypes: [UTType] { [.exampleText, .rdrwPackage] }

  init(configuration: ReadConfiguration) throws {
    let decoder = JSONDecoder()
    let wrapper = configuration.file.fileWrappers
    // should check here that this is a directory filewrapper
    guard let data = wrapper?["config.json"]?.regularFileContents
    else {
        throw CocoaError(.fileReadCorruptFile)
    }
    let jsonData = try decoder.decode(RDRWDbService.self, from: data)
    version = 1
    store = jsonData.mainstore
  }

  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    encoder.outputFormatting = .prettyPrinted
    let config = try encoder.encode(["mainstore": store])

    let updatedConfigWrapper = FileWrapper.init(regularFileWithContents: config)

    if (configuration.existingFile != nil) {
      let existingWrapper = configuration.existingFile!
      let existingConfig = existingWrapper.fileWrappers?["config.json"]


      let onDiskJson = try decoder.decode(RDRWDbService.self, from: existingConfig!.regularFileContents!)
      // the RDRWStore is equatable so we can just check if the disk version matches
      if (onDiskJson.mainstore == store) {
        print("no changes")
        // file unchanged, return existing wrapper
        return configuration.existingFile!
      } else {
        print("updating file")
        // only update the filewrapper's rdrwstore file, preserving all other contents
        // first, need to remove the existing config before we can add the new wrapper
        configuration.existingFile?.removeFileWrapper(existingConfig!)

        // set the preferred filename so that it has the right name when we add the updated version
        updatedConfigWrapper.preferredFilename = "config.json"
        existingWrapper.addFileWrapper(updatedConfigWrapper)
        return existingWrapper
      }
    } else {
      print("creating a new file")
      // create a new wrapper and populate it
      let meta = try encoder.encode(["version": version])

      let tempWrapper = FileWrapper.init(directoryWithFileWrappers: [
        "meta.json": .init(regularFileWithContents: meta),
        "config.json": updatedConfigWrapper,
      ])

      return tempWrapper
    }

  }
}
