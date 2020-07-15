//
//  TopicTable+CoreDataProperties.swift
//  EnG4KiD
//
//  Created by MacPro An Lê on 3/18/20.
//  Copyright © 2020 An Lê. All rights reserved.
//
//

import Foundation
import CoreData


extension TopicTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TopicTable> {
        return NSFetchRequest<TopicTable>(entityName: "TopicTable")
    }

    @NSManaged public var titleTopic: String?
    @NSManaged public var imgTopic: Data?
    @NSManaged public var manyVocabulary: Set<VocabularyTable>?

}

// MARK: Generated accessors for topicOfVoca
extension TopicTable {

    @objc(addManyVocabularyObject:)
    @NSManaged public func addToManyVocabulary(_ value: VocabularyTable)

    @objc(removeManyVocabularyObject:)
    @NSManaged public func removeFromManyVocabulary(_ value: VocabularyTable)

    @objc(addManyVocabulary:)
    @NSManaged public func addToManyVocabulary(_ values: Set<VocabularyTable>)

    @objc(removeManyVocabulary:)
    @NSManaged public func removeFromManyVocabulary(_ values: Set<VocabularyTable>)

}
