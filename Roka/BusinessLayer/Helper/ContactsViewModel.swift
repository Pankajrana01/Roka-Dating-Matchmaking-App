//
//  ContactsViewModel.swift
//  Contacts
//
//  Created by Jay Mehta on 05/01/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import Contacts
import Foundation
import CountryPickerView

class ContactsViewModel {

    let titleForVC = "Contacts"
    let cellId = "ContactsTableViewCell"

    private let indexLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    private let unnamedString = "#"

    private var sectionTitleForContacts = [String]()
    private var contacts = [[CNContact]]()
    var shareContacts = [CNContact]()
    var filteredContacts = [CNContact]()

    var numberListDictionary = [NSDictionary]()
    
    private lazy var cpv: CountryPickerView = {
        let countryPickerView = CountryPickerView()
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        return countryPickerView
    }()
    
    private func getCountryCode() -> String {
       if let code = cpv.getCountryByPhoneCode(DefaultSelectedCountryCode)?.phoneCode {
            return code
        } else if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String,
            let code = cpv.getCountryByCode(countryCode)?.phoneCode {
            return code
        }
        return "N.A."
    }
    
    
    // MARK: - Helper methods

    private func setData(fromContactsResult contactsResult: [String: [CNContact]]) {
        for key in contactsResult.keys.sorted() where key != self.unnamedString {
            sectionTitleForContacts.append(key)
            contacts.append(contactsResult[key]?.sorted { (contactA: CNContact, contactB: CNContact) -> Bool in
                let nameA = contactA.givenName + contactA.familyName
                let nameB = contactB.givenName + contactB.familyName

                return nameA.uppercased() < nameB.uppercased()
            } ?? []
            )
        }

        if let unnamedContacts = contactsResult[self.unnamedString] {
            sectionTitleForContacts.append(self.unnamedString)
            contacts.append(unnamedContacts)
        }
        
        shareContacts = contacts.flatMap({ $0 })
        filteredContacts = contacts.flatMap({ $0 })
    }

    private func clearData() {
        sectionTitleForContacts.removeAll()
        contacts.removeAll()
    }


    // MARK: - Contacts fetch methods

    func fetchContacts(_ result:@escaping(String?) -> Void) {
        clearData()

        let store = CNContactStore()

        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactIdentifierKey, CNContactMiddleNameKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey, CNContactOrganizationNameKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])

        var contactsWithInitials = [String: [CNContact]]()

        do {
            try? store.enumerateContacts(with: request) { (contact: CNContact, _) in
                var contactInitial = contact.givenName.first?.description.uppercased() ?? contact.familyName.first?.description.uppercased() ?? self.unnamedString
                if !self.indexLetters.contains(contactInitial) {
                    contactInitial = self.unnamedString
                }

                contactsWithInitials[contactInitial]?.append(contact)

                if contactsWithInitials[contactInitial] == nil {
                    contactsWithInitials[contactInitial] = [contact]
                }
            }

            self.setData(fromContactsResult: contactsWithInitials)

            result("success")
        } catch let err {
            print("Failed to enumerate contacts due to error \(err)")
            result("failed")
        }
    }


    // MARK: - Data extraction methods

    func getNumberOfSectionsForContacts() -> Int {
        return sectionTitleForContacts.count
    }

    func getSectionTitle(forSection section: Int) -> String {
        return sectionTitleForContacts[section]
    }

    func getNumberOfContacts(forSection section: Int) -> Int {
        return contacts[section].count
    }

    func getContactName(forIndexPath indexPath: IndexPath) -> String {
        let contact = contacts[indexPath.section][indexPath.row]
        return calculateName(contact: contact)
    }
    
    func calculateName(contact: CNContact) -> String {
        var contactName = contact.givenName + " " + contact.familyName

        if (contact.givenName + contact.familyName).isEmpty {
            contactName = contact.phoneNumbers.first?.value.stringValue ?? ""
        }
        return contactName
    }
    
    func updateContacts(_ result:@escaping(String?) -> Void) {
        DispatchQueue.main.async {
            for section in 0..<self.sectionTitleForContacts.count{
                for i in 0..<self.contacts[section].count{
                    let contact = self.contacts[section][i]
                    var contactName = contact.givenName + " " + contact.familyName
                    
                    if (contact.givenName + contact.familyName).isEmpty {
                        contactName = contact.phoneNumbers.first?.value.stringValue ?? ""
                    }
                    if contact.phoneNumbers.first != nil{
                        let numberValue = contact.phoneNumbers[0].value
                        
                        if let countryCode = numberValue.value(forKey: "countryCode") as? String {
                            let digits = numberValue.value(forKey: "digits") as? String
                            let country =
                            self.cpv.getCountryByCode("\(countryCode.uppercased())")
                            print(country as Any)
                            
                            let dict = NSMutableDictionary()
                            dict["id"] = contact.identifier
                            dict["name"] = contactName
                            dict["countryCode"] = country?.phoneCode
                            dict["number"] = digits?.deletingPrefix(country?.phoneCode ?? "+")
                            self.numberListDictionary.append(dict)
                        }
                    }
                }
            }
            print(self.numberListDictionary)
            result("success")
        }
    }

    func getContact(forIndexPath indexPath: IndexPath) -> CNContact {
        return contacts[indexPath.section][indexPath.row]
    }

    func getAllSectionTitles() -> [String] {
        return sectionTitleForContacts
    }
    
    
    func getProfilePhoto(forIndexPath indexPath: IndexPath) -> Data? {
        let contact = contacts[indexPath.section][indexPath.row]
        return contact.imageData
    }
    
    func initials(firstName: String?, lastName: String?) -> String {
        var initialsString = ""
        
        if let firstInitial = firstName?.prefix(1) {
            initialsString += String(firstInitial)
        }
        
        if let lastInitial = lastName?.prefix(1) {
            initialsString += String(lastInitial)
        }
        
        return initialsString
        
    }
    
    func getInitials(from name: String, count: Int) -> String {
        let cleanedName = name.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        let words = cleanedName.components(separatedBy: " ")
        let initials = words.prefix(count).compactMap { $0.first }
        return String(initials.prefix(count)).uppercased()
    }
    
     func imageWithInitials(initials: String) -> UIImage {
           // Placeholder image creation logic
           let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
           let userImage = renderer.image { context in
               UIColor.appBrownColor.setFill()
               context.fill(CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))

               let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 20,weight: .semibold),
                   .foregroundColor: UIColor.white
               ]

               let text = NSString(string: initials)
               let textSize = text.size(withAttributes: attributes)
               let origin = CGPoint(x: (50 - textSize.width) / 2, y: (50 - textSize.height) / 2)

               text.draw(at: origin, withAttributes: attributes)
           }

           return userImage
       }

}

// MARK: - Country picker Delegate
extension ContactsViewModel: CountryPickerViewDelegate, CountryPickerViewDataSource {
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView,
                           didSelectCountry country: Country) {
    }
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
