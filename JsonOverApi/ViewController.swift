import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    var email = UITextField()
    var submit = UIButton()
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextDisplay()
        submitButton()
    }
    
    func emailTextDisplay(){
        email.translatesAutoresizingMaskIntoConstraints = false
        email.placeholder = "Enter your Email Id"
        email.textAlignment = .center
        email.borderStyle = .line
        view.addSubview(email)
        NSLayoutConstraint.activate([
            email.topAnchor.constraint(equalTo:view.topAnchor,constant: 80),
            email.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 5),
            email.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 5),
            email.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -550)
        ])
    }
    
    func submitButton(){
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.backgroundColor = UIColor.darkGray
        submit.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        view.addSubview(submit)
        NSLayoutConstraint.activate([
            submit.topAnchor.constraint(equalTo:email.topAnchor,constant: 70),
            submit.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 5),
            submit.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 5),
            submit.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -480)
        ])
    }
    
    @objc func buttonAction(_ sender:UIButton!)
    {
        let postBody = ["emailId" : "\(email.text!)"]
        let url = URL(string: "https://surya-interview.appspot.com/list")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let http = try? JSONSerialization.data(withJSONObject: postBody, options: []) else {return}
        request.httpBody = http
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            guard let data = data else {return}
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let employees = json["items"]! as! [[String : AnyObject]]
                self.userDefaults.set(employees, forKey: "employee")
            }catch let jsonErr{
                print(jsonErr)
            }
        }
        task.resume()
        printStoreDetails()
    }
    func printStoreDetails(){
        let details = userDefaults.object(forKey: "employee")
        print(details)
    }
}
