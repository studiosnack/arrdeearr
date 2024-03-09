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
    let rootOrdering = document.store?.categories?.ordering["root"] ?? [];
    let categoryStore = document.store?.categories;

    NavigationSplitView{

      List(rootOrdering, id: \.self) { item in
        Text(categoryStore?.categoryFor(id: item)?.name ?? "no name???")
      }.listStyle(.sidebar)
    } content: {} detail: {}
  }
}

//#Preview {
//    ContentView()
//}
