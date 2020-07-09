import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    var email = UITextField()  //object that displays editable text area on the interface
    var submit = UIButton() // control that executes code in response to user actions
    let userDefaults = UserDefaults.standard // UserDefaults - interface to the UserDefaults database where data is stored in key-value pairs , standard - returns the shared defaults object
    
    override func viewDidLoad() {
        super.viewDidLoad() // called after the view controller is loaded on to the memory
        emailTextDisplay()
        submitButton()
    }
    
    func emailTextDisplay(){
        email.translatesAutoresizingMaskIntoConstraints = false // bool value that determines if the view's autoresizing mask is converted into AutoLayout constraints
        email.placeholder = "Enter your email"
        email.textAlignment = .center
        email.borderStyle = .line
        view.addSubview(email)
        NSLayoutConstraint.activate([
            email.topAnchor.constraint(equalTo:view.topAnchor,constant: 220),
            email.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            email.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            email.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -400)
        ])
        //NSLayoutConstraint -  relationship between the UI objects based on the autolayout system.
        //item1.attribute1 = multiplier × item2.attribute2 + constant
    }
    
    func submitButton(){
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.backgroundColor = UIColor.darkGray
        submit.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        //self - target, #selector - action, touchUpInside - UIControl.event is used for a tap interaction(finger is inside the bounds of control)
        view.addSubview(submit)
        NSLayoutConstraint.activate([
            submit.topAnchor.constraint(equalTo:email.topAnchor,constant: 70),
            submit.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            submit.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            submit.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -330)
        ])
    }
    
    @objc func buttonAction(_ sender:UIButton!) //@objc is to expose the instance of the method to objective C
    {
        let postBody = ["emailId" : "\(email.text!)"]
        guard let requestUrl = URL(string: "https://surya-interview.appspot.com/list") else { return }
        //guard - used to unwrap an optional, it exits if the optional is nil.
        //URL - identifies the location of the resource
        var request = URLRequest(url: requestUrl) // URLRequest - encapsulates the url to be loaded and includes HTTP methods
        request.httpMethod = "POST"
        //GET - to retrieve information from the endpoint
        //POST - to send data to the server
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // parse the request body as a json
        guard let http = try? JSONSerialization.data(withJSONObject: postBody, options: []) else {return}
        //JSONSerialization - object that converts between JSON and the equivalent Foundation objects
        //data() - Returns JSON data from a Foundation object.
        //withJSONObject - obj from which we need to generate the JSON data
        request.httpBody = http // httpbody- data sent as the body of request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //URLSession - provides an API for data transfer from and to endpoints
            // shared - shared a singleton session object
            //dataTask - retrieves the contents of a URL based on the request
            if let error = error {
                print("Error took place \(error)")
                return
            }
            guard let data = data else {return}
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                // jsonObject - Returns a Foundation object from given JSON data.
                let employees = json["items"] as! [[String : AnyObject]]
                self.userDefaults.set(employees, forKey: "employee")
            }catch let jsonErr{
                print(jsonErr)
            }
        }
        task.resume() // resumes the task if the task is suspended
        printStoreDetails()
    }
    func printStoreDetails(){
        let details = userDefaults.object(forKey: "employee")!
        //object() - Returns the object associated with the specified key.
        print(details)
    }
}
