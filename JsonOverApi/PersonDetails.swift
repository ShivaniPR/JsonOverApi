class PersonDetails {
    static func getDetails(person : Dictionary<String, String>) -> Person{
        let person = Person(emailId: person["emailId"]!, firstName: person["firstName"]!, lastName: person["lastName"]!, imageUrl: person["imageUrl"]!)
        return person
    }
}

