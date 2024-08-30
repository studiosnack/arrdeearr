//
//  ContentView.swift
//  arrdeearr
//
//  Created by Marcos Ojeda on 3/2/24.
//

import SwiftUI

struct SelectedCategoryKey: FocusedValueKey {
  typealias Value = Category
}

extension FocusedValues {
  var selectedCategory: SelectedCategoryKey.Value? {
    get { self[SelectedCategoryKey.self]}
    set { self[SelectedCategoryKey.self] = newValue }
  }
}

/**
 unused
 */
struct OldContentView: View {
  @Binding var document: ArrdeearrDocument

  var body: some View {
    let rootOrdering = document.store.categories.ordering["root"] ?? [];
    let categoryStore = document.store.categories;

    NavigationSplitView{

      List(rootOrdering, id: \.self) { item in
        Text(categoryStore.categoryFor(id: item)?.name ?? "no name???")
      }.listStyle(.sidebar)
    } content: {} detail: {}
  }
}

/**
 unused
 */
struct OutlineContentView: View {
  @Binding var document: ArrdeearrDocument

  var body: some View {
    let outlineData: [CategoryTree] = CategoryTree.forCategoryStore(store: document.store.categories, atPath: "root") ?? []

    NavigationSplitView {
      List(outlineData) { (category: CategoryTree) in
        OutlineGroup(category, children: \.children) { item in
          NavigationLink("\(item.value.name)", value: item.id)
        }
      }
    } content: {} detail: {}
  }
}

/**
 unused
 */
struct ConfigurableDisclosureContentView: View {
  @Binding var document: ArrdeearrDocument;
  
  var body: some View {

    let selectedCategoryRow = Binding(get: {
      document.store.application.selectedCategoryRow
    }, set: {
      rowId in document.store.application.selectedCategoryRow = rowId
    })

    let availableItems = selectedCategoryRow.wrappedValue != nil ? document.store.items.itemsWithCategory(id: selectedCategoryRow.wrappedValue!) : []

    func bindingForPath(path: String) -> Binding<Bool> {
      Binding(get: {document.store.application.sideBarOpenedState[path] ?? false}, set: {val in document.store.application.sideBarOpenedState[path] = val ? val : nil})
    }

    let outlineData: [CategoryTree] = CategoryTree.forCategoryStore(store: document.store.categories, atPath: "root") ?? []

    return NavigationSplitView {
      VStack{
        List(outlineData, id: \.id, selection: selectedCategoryRow) { item in
            ConfigurableDisclosureGroup(data: item, path: \.children, isOpen: {tree in bindingForPath(path: tree.id)} ) { treeEntry in
                SidebarCategoryRow(treeEntry: treeEntry)
            }
        }
        Spacer()
        RootTextFieldButton(store: $document.store)
      }
      } content: {
        availableItems.count > 0 ? List(availableItems, id: \.id) { item in
          let itemName = item.propertyWith(label: "Name") ?? "missing name"
          Text("\(itemName)")
        } : nil
      } detail: {
      }
  }
}

struct ContentView: View {
  @Binding var document: ArrdeearrDocument;
  
  var body: some View {
    
    return NavigationSplitView {
      NavigationSidebarContent(document: $document, selectedRow: $document.store.application.selectedCategoryRow)
    } content: {
      NavigationContent(document: $document)
    } detail: {
    }
  }
}


let catStore = RDRWStore(categories: CategoryStore(
  categories: [
    Category(id: "foo", name: "Fooooo", parentId: "root"),
    Category(id: "bar", name: "Baaaaar", parentId: "root"),
    Category(id: "baz", name: "Baz!", parentId: "foo"),
    Category(id: "qux", name: "Quxx!", parentId: "baz")
  ],
  ordering:[
    "root": ["foo", "bar"],
    "foo": ["baz"],
    "baz": ["qux"],
  ]
), application: ApplicationStore(
    sideBarOpenedState: ["foo": true, "baz": false]
  ),
                         items: ItemStore(items: ["a":
    Item(id: "a", dateAdded: 123, properties: [
      Field(label: "Name", value: "A thing", type: .string),
      Field(label: "Category", categoryId: "foo", type: .string)
    ])
  ])
);


#Preview("Configurable Content View") {
  @Previewable @State var doc = ArrdeearrDocument(version:1,
    store: catStore)
  return ConfigurableDisclosureContentView(document: $doc);
}

#Preview("Outline Content View") {
  @Previewable @State var doc = ArrdeearrDocument(version:1,
    store: catStore)

  return OutlineContentView(document: $doc);
}

#Preview("Default Content View") {
  @Previewable @State var doc = ArrdeearrDocument(version:1,
    store: catStore)
  return OldContentView(document: $doc);
}

