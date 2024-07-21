//
//  SidebarContent.swift
//  arrdeearr
//
//  Created by Marcos Ojeda on 7/21/24.
//

import SwiftUI

struct NavigationSidebarContent: View {

  @Binding var document: ArrdeearrDocument;

    var body: some View {
      
      let selectedCategoryRow = Binding(get: {
        document.store.application.selectedCategoryRow
      }, set: {
        rowId in document.store.application.selectedCategoryRow = rowId
      })

      let outlineData: [CategoryTree] = CategoryTree.forCategoryStore(store: document.store.categories, atPath: "root") ?? []

      func bindingForPath(path: String) -> Binding<Bool> {
        Binding(get: {document.store.application.sideBarOpenedState[path] ?? false}, set: {val in document.store.application.sideBarOpenedState[path] = val ? val : nil})
      }

      return List(outlineData, id: \.id, selection: selectedCategoryRow) { item in
          ConfigurableDisclosureGroup(data: item, path: \.children, isOpen: {tree in bindingForPath(path: tree.id)} ) { treeEntry in
              SidebarCategoryRow(treeEntry: treeEntry)
          }
        }
    }
}

//#Preview {
//    SidebarContent()
//}
