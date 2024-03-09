//
//  RDRWStruct.swift
//  arrdeearr
//
//  Created by Marcos Ojeda on 3/9/24.
//

import Foundation

struct RDRWStore: Codable {
  let categories: CategoryStore?;
  let application: ApplicationStore?;
  let items: ItemStore?;
  let fits: FitStore?;

  struct CategoryStore: Codable {
    let categories: [Category];
    let sideBarOpenedState: [String: Bool]?;
    let ordering: [String: [String]]; // the value of this dict is a bunch of ids of actual categories

    struct Category: Codable {
      let id: String;
      let parentId: String;
      let name: String;
    }

    func categoryFor(id: String) -> Category? {
      return self.categories.first(where: {$0.id == id})
    }
  }
  struct ApplicationStore: Codable {
    let sideBarOpenedState: [String: Bool];
    let wantsChildInput: [String: Bool];
    let selectedCategoryRow: String?;
    let currentView: ApplicationView?;

    enum ApplicationView: String, Codable {
      case category
      case fit
    }
  }
  struct ItemStore: Codable {
    let items: [String: Item];

    struct Item: Codable {
      let id: String;
      let dateAdded: Double;
      let properties: [Field];
    }
    struct Field: Codable {
      let label: String;
      let categoryId: String?;
      let value: String?;
      let type: FieldType;
      let hidden: Bool?;

      enum FieldType: String, Codable {
        case string
        case number
        case currency
        case year
        case url
        case date
        case boolean
      }
    }
  }
  struct FitStore: Codable {}
}

struct RDRWDbService: Codable {
  let mainstore: RDRWStore;
}

