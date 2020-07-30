struct Person {
    var emailId : String?
    var firstName : String?
    var lastName : String?
    var imageUrl : String?
    
    init(person : Dictionary<String, String>) {
        self.emailId = person["emailId"]
        self.firstName = person["firstName"]
        self.lastName = person["lastName"]
        self.imageUrl = person["imageUrl"]
    }
}

