//
//  ItemB+CoreDataProperties.swift
//  test-nfc-fetch-children
//
//  Created by Alex Marshall on 1/17/20.
//  Copyright © 2020 Alex Marshall. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemB> {
        return NSFetchRequest<ItemB>(entityName: "ItemB")
    }


}
