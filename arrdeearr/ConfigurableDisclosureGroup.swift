//
//  ConfigurableDisclosureGroup.swift
//  arrdeearr
//
//  Created by Marcos Ojeda on 3/16/24.
//

import Foundation
import SwiftUI

struct ConfigurableDisclosureGroup<Treelike, Children>: View where Children: View , Treelike: Identifiable{
  let data: Treelike;
  let path: KeyPath<Treelike, [Treelike]?>;
  let isOpen: (_ item: Treelike) -> Bool;
  let children: (Treelike) -> Children;

  var body: some View {
    let childData = data[keyPath: path];
    if (childData != nil) {
      DisclosureGroup(
        isExpanded: .constant(isOpen(data)),
        content: { ForEach(childData!) {child in ConfigurableDisclosureGroup(data: child, path: path, isOpen: isOpen, children: children)}  },
        label: { children(data)}
        )
    } else {
      children(data)
    }
  }
}

let outlineData: [CategoryTree] = CategoryTree.forCategoryStore(store: catStore.categories, atPath: "root") ?? []

struct StatefulSidebar_Preview: View {
  var sidebarState = State(initialValue: catStore.application.sideBarOpenedState)

  func isOpen(path: String) -> Bool {
    return sidebarState.wrappedValue[path] ?? false == true
  }

  var body: some View {
    NavigationSplitView {
      List(outlineData) { item in
        ConfigurableDisclosureGroup(data: item, path: \.children, isOpen: {tree in isOpen(path: tree.id)} ) { treeEntry in
            NavigationLink(treeEntry.value.name, value: treeEntry.id)
          }
      }
    } content: {} detail: {}
  }
}

#Preview("sidebar with state") {
  StatefulSidebar_Preview()
}
