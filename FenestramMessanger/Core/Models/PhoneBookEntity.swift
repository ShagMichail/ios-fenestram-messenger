//
//  PhoneBookEntity.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 02.09.2022.
//

import UIKit
import Contacts

final public class PhoneBookEntity : NSObject {
    let givenName: String
    let familyName: String
    let phoneNumbers: [String]
    let emailAddress: String
    var identifier: String
    var image: UIImage

    init(givenName: String,
         familyName: String,
         phoneNumbers: [String],
         emailAddress: String,
         identifier: String,
         image: UIImage) {
        self.givenName = givenName
        self.familyName = familyName
        self.phoneNumbers = phoneNumbers
        self.emailAddress = emailAddress
        self.identifier = identifier
        self.image = image
    }

    static func generateModelArray() -> [PhoneBookEntity] {
        let contactStore = CNContactStore()
        var contactsData = [PhoneBookEntity]()
        let key = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactImageDataKey,CNContactThumbnailImageDataKey,CNContactPhoneNumbersKey,CNContactEmailAddressesKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
        try? contactStore.enumerateContacts(with: request, usingBlock: { (contact, stoppingPointer) in
            let givenName = contact.givenName
            let familyName = contact.familyName
            let emailAddress = contact.emailAddresses.first?.value ?? ""
            let phoneNumbers: [String] = contact.phoneNumbers.map{ $0.value.stringValue }
            let identifier = contact.identifier
            var image = UIImage()
            if contact.thumbnailImageData != nil{
                image = UIImage(data: contact.thumbnailImageData!)!

            } else if contact.thumbnailImageData == nil ,givenName.isEmpty || familyName.isEmpty {
                image = Asset.photo.image
            }
            contactsData.append(PhoneBookEntity(givenName: givenName,
                                                familyName: familyName,
                                                phoneNumbers: phoneNumbers,
                                                emailAddress: emailAddress as String,
                                                identifier: identifier,
                                                image: image))
        })
        return contactsData
    }
}
