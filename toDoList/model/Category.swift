//
//  Category.swift
//  toDoList
//
//  Created by Omar Adel on 11/5/19.
//  Copyright © 2019 z510. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
