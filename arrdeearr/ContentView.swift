//
//  ContentView.swift
//  arrdeearr
//
//  Created by Marcos Ojeda on 3/2/24.
//

import SwiftUI

struct ContentView: View {
  @Binding var document: ArrdeearrDocument

  var body: some View {
    let rootOrdering = document.store?.categories.ordering["root"] ?? [];
    let categoryStore = document.store?.categories;

    NavigationSplitView{

      List(rootOrdering, id: \.self) { item in
        Text(categoryStore?.categoryFor(id: item)?.name ?? "no name???")
      }.listStyle(.sidebar)
    } content: {} detail: {}
  }
}

struct OutlineContentView: View {
  @Binding var document: ArrdeearrDocument

  var body: some View {
    let outlineData: [CategoryTree] = CategoryTree.forCategoryStore(store: document.store!.categories, atPath: "root") ?? []

    NavigationSplitView {
      List(outlineData) { (category: CategoryTree) in
        OutlineGroup(category, children: \.children) { item in
          NavigationLink("\(item.value.name)", value: item.id)
        }
      }
    } content: {} detail: {}
  }
}

struct ConfigurableDisclosureContentView: View {
  @Binding var document: ArrdeearrDocument;

  var body: some View {
    let sidebarState = document.store!.application.sideBarOpenedState

    let selectedCategoryRow = document.store!.application.selectedCategoryRow

    func isOpen(path: String) -> Bool {
      return sidebarState[path] ?? false == true
    }

    let outlineData: [CategoryTree] = CategoryTree.forCategoryStore(store: document.store!.categories, atPath: "root") ?? []

      return NavigationSplitView {
        // TODO(marcos): figure out how to correctly reference the selection
        List(outlineData, id: \.id, selection: .constant(selectedCategoryRow)) { item in
          ConfigurableDisclosureGroup(data: item, path: \.children, isOpen: {tree in isOpen(path: tree.id)} ) { treeEntry in
              NavigationLink(treeEntry.value.name, value: treeEntry.id)
            }
        }
      } content: {} detail: {}
  }
}


let catStore = RDRWStore(categories: CategoryStore(
  categories: [
    Category(id: "foo", parentId: "root", name: "Fooooo"),
    Category(id: "bar", parentId: "root", name: "Baaaaar"),
    Category(id: "baz", parentId: "foo", name: "Baz!"),
    Category(id: "qux", parentId: "baz", name: "Quxx!")
  ],
  ordering:[
    "root": ["foo", "bar"],
    "foo": ["baz"],
    "baz": ["qux"],
  ]
), application: ApplicationStore(
    sideBarOpenedState: ["foo": true, "baz": false]
  )
);


#Preview("Outline Content View") {
  @State var doc = ArrdeearrDocument(version:1,
    store: catStore)

  return OutlineContentView(document: $doc);
}

#Preview("Default Content View") {
  @State var doc = ArrdeearrDocument(version:1,
    store: catStore)
  return ContentView(document: $doc);
}

#Preview("Configurable Content View") {
  @State var doc = ArrdeearrDocument(version:1,
    store: catStore)
  return ConfigurableDisclosureContentView(document: $doc);
}
