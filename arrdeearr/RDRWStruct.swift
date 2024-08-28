//
//  RDRWStruct.swift
//  arrdeearr
//
//  Created by Marcos Ojeda on 3/9/24.
//

import Foundation

let nanoid = NanoID(alphabet: .nolookalikesSafe, size: 6)

struct Category: Codable, Equatable {
  var id: String;
  var name: String;
  var parentId: String;

  
  init(id: String, name: String, parentId: String) {
    self.id = id;
    self.parentId = parentId;
    self.name = name;
  }
  
  init(name: String, parentId: String = "root") {
    self.id = nanoid.new();
    self.parentId = parentId;
    self.name = name;
  }
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

struct CategoryStore: Codable, Equatable {
  var categories: [Category] = [];
//  sidebareOpenedState is vestigial property in the
//  spec but doesn't get used
//  let sideBarOpenedState: [String: Bool]? = [];
  var ordering: [String: [String]] = [:]; // the value of this dict is a bunch of ids of actual categories

  func categoryFor(id: String) -> Category? {
    return self.categories.first(where: {$0.id == id})
  }

  mutating func add(parentId: String, name: String) {
    let newCat = Category(name: name, parentId: parentId)
    self.categories.append(newCat)
    if (self.ordering[parentId] == nil || self.ordering[parentId]?.count ?? 0 == 0) {
      self.ordering[parentId] = [newCat.id]
    } else if (self.ordering[parentId] != nil && self.ordering[parentId]?.count ?? 0 > 0) {
      self.ordering[parentId]?.append(newCat.id)
    }
  }

  mutating func addCategoryTo(parentId: String, category: Category) {
    let currentOrdering = self.ordering[parentId]
    if (currentOrdering != nil) {
      self.categories.append(category)
      self.ordering[parentId]?.append(category.id)
    }
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

struct ApplicationStore: Codable, Equatable {
  var sideBarOpenedState: [String: Bool] = [:];
  var wantsChildInput: [String: Bool] = [:];
  var selectedCategoryRow: String?;
  var currentView: ApplicationView?;

  mutating func toggleWantsChildInput(for categoryId: String) {    
    self.wantsChildInput[categoryId] = self.wantsChildInput[categoryId] == nil ? true: nil;
  }
    
  enum ApplicationView: String, Codable, Equatable {
    case category
    case fit
  }
}

struct Item: Codable, Equatable {
  let id: String;
  var dateAdded: Double;
  var properties: [Field];

  func propertyWith(label: String) -> String? {
    self.properties.first(where: {p in p.label == label})?.value
  }
}

struct Field: Codable, Equatable {
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

struct ItemStore: Codable, Equatable {
  var items: [String: Item] = [:];
  
  func itemsWithCategory(id: String) -> [Item] {
    self.items.values.filter { item in
      item.properties.contains(where: {field in field.categoryId == id})
    }
  }
}

struct FitStore: Codable, Equatable {}


struct RDRWStore: Codable, Equatable {
  var categories: CategoryStore = CategoryStore();
  var application: ApplicationStore = ApplicationStore();
  var items: ItemStore = ItemStore();
  var fits: FitStore = FitStore();
}

struct RDRWDbService: Codable {
  let mainstore: RDRWStore;
}

