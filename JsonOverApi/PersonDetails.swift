class PersonDetails {
    static func getDetails(person : Dictionary<String, String>) -> Person{
        let person = Person(person: person)
        return person
    }
}

