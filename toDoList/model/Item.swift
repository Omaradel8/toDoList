//
//  File.swift
//  toDoList
//
//  Created by Omar Adel on 11/5/19.
//  Copyright © 2019 z510. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var checked: Bool = false
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

