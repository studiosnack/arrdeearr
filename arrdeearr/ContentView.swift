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

struct DefaultContentView_Preview: PreviewProvider {

  static var previews: some View {
    ContentView(document: .constant(
      arrdeearrDocument(
        version:1,
        store: RDRWStore(categories: CategoryStore(
          categories: [
            Category(id: "foo", parentId: "root", name: "Fooooo"),
            Category(id: "bar", parentId: "root", name: "Baaaaar")
          ],
          ordering:[
            "root": ["foo", "bar"]
          ]
        )
        )
      )
    )
    )
  }

}

//struct DefaultContentView: View {
//  @State var doc = arrdeearrDocument(version:1,
//    store: RDRWStore())
//
//  var body: some View {
//    ContentView(document: $doc)
//  }
//}
//
//#Preview {
//  DefaultContentView()
//}
