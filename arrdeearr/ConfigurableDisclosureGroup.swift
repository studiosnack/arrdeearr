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
