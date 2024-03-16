//
//  ContentView.swift
//  arrdeearr
//
//  Created by Marcos Ojeda on 3/2/24.
//

import SwiftUI

struct ContentView: View {
  @Binding var document: arrdeearrDocument

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
  @Binding var document: arrdeearrDocument

  var body: some View {
    let outlineData: [CategoryTree] = CategoryTree.forCategoryStore(store: document.store!.categories, atPath: "root") ?? []

    NavigationSplitView {
      List(outlineData) { (category: CategoryTree) in
        OutlineGroup(category, children: \.children) { item in
          Text("\(item.value.name)")
        }
      }
    } content: {} detail: {}

    //    OutlineGroup(outlineData, children: \.children) { item in
//      Text("\(item.name)")
//    }
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
)
);

struct OutlineView: View {
  var body: some View {
        OutlineContentView(document: .constant(
          arrdeearrDocument(
            version:1,
            store: catStore
          )
        )
        )
  }
}

#Preview("Outline Content View") {
  OutlineView()
}

struct DefaultContentView: View {
  @State var doc = arrdeearrDocument(version:1,
    store: RDRWStore())

  var body: some View {
    ContentView(document: $doc)
  }
}

#Preview("Default Content View") {
  DefaultContentView()
}
