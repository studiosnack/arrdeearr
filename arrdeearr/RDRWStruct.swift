//
//  RDRWStruct.swift
//  arrdeearr
//
//  Created by Marcos Ojeda on 3/9/24.
//

import Foundation

struct Category: Codable {
  var id: String;
  var parentId: String;
  var name: String;
}

struct CategoryTree: Identifiable {
  let value: Category;
  let children: [CategoryTree]?;

  var id: String {
    get {
      return self.value.id
    }
  }

  static func forCategoryStore(store: CategoryStore, atPath: String) -> [CategoryTree]? {
    let kids: [String]? = store.ordering[atPath];
    if (kids != nil) {
      var res: [CategoryTree] = [];
      for catId in kids! {
        let branch = CategoryTree(
          value: store.categoryFor(id: catId)!,
          children: CategoryTree.forCategoryStore(store: store, atPath: catId))
        res.append(branch)
      }
      return res;
    }
    return nil;
  }
}

struct CategoryStore: Codable {
  var categories: [Category] = [];
//    let sideBarOpenedState: [String: Bool]? = [];
  var ordering: [String: [String]] = [:]; // the value of this dict is a bunch of ids of actual categories

  func categoryFor(id: String) -> Category? {
    return self.categories.first(where: {$0.id == id})
  }

  func categoryAsTree(id: String) -> [CategoryTree]? {
    let kids: [String]? = self.ordering[id];
    if (kids != nil) {
      var res: [CategoryTree] = [];
      for catId in kids! {
        let branch = CategoryTree(
          value: self.categoryFor(id: catId)!,
          children: self.categoryAsTree(id: catId))
        res.append(branch)
      }
      return res;
      /**
        not sure why this didn't work as a map closure
       */
    }
    return nil;
  }
}

struct ApplicationStore: Codable {
  var sideBarOpenedState: [String: Bool] = [:];
  var wantsChildInput: [String: Bool] = [:];
  var selectedCategoryRow: String?;
  var currentView: ApplicationView?;

  enum ApplicationView: String, Codable {
    case category
    case fit
  }
}

struct ItemStore: Codable {
  var items: [String: Item] = [:];

  struct Item: Codable {
    let id: String;
    var dateAdded: Double;
    var properties: [Field];
  }
  struct Field: Codable {
    var label: String;
    var categoryId: String?;
    var value: String?;
    var type: FieldType;
    var hidden: Bool?;

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


struct RDRWStore: Codable {
  var categories: CategoryStore = CategoryStore();
  var application: ApplicationStore = ApplicationStore();
  var items: ItemStore = ItemStore();
  var fits: FitStore = FitStore();
}

struct RDRWDbService: Codable {
  let mainstore: RDRWStore;
}

