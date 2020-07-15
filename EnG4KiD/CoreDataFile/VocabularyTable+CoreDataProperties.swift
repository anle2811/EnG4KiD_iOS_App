//
//  VocabularyTable+CoreDataProperties.swift
//  EnG4KiD
//
//  Created by MacPro An Lê on 3/18/20.
//  Copyright © 2020 An Lê. All rights reserved.
//
//

import Foundation
import CoreData


extension VocabularyTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VocabularyTable> {
        return NSFetchRequest<VocabularyTable>(entityName: "VocabularyTable")
    }

    @NSManaged public var engWord: String?
    @NSManaged public var vnWord: String?
    @NSManaged public var imgWord: Data?
    @NSManaged public var img1Word: Data?
    @NSManaged public var isLearned: Bool
    @NSManaged public var oneTopic: TopicTable?

}
