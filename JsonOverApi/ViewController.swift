import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    let email = UITextField()
    let submit = UIButton()
    let invalidEmail = UILabel()
    let emailPlaceholder = NSLocalizedString("emailTextBoxPlaceholder", comment: "")
    let buttonTitle = NSLocalizedString("submitButton", comment: "")
    let incorrectEmail = NSLocalizedString("incorrectEmailString", comment: "")
    let incorrectEmailTitle = NSLocalizedString("incorrectEmailTitle", comment: "")
    let okayButton = NSLocalizedString("okay", comment: "")
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        emailTextDisplay()
        submitButton()
    }
    
    func emailTextDisplay(){
        email.translatesAutoresizingMaskIntoConstraints = false
        email.placeholder = String.localizedStringWithFormat(emailPlaceholder)
        email.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        email.tintColor = .lightGray
        email.layer.cornerRadius = 15
        email.textAlignment = .center
        view.addSubview(email)
        NSLayoutConstraint.activate([
            email.topAnchor.constraint(equalTo:view.topAnchor,constant: 220),
            email.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            email.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            email.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -400)
        ])
    }
    
    func submitButton(){
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle(String.localizedStringWithFormat(buttonTitle), for: .normal)
        submit.backgroundColor = UIColor.red
        submit.layer.cornerRadius = 15
        view.addSubview(submit)
        NSLayoutConstraint.activate([
            submit.topAnchor.constraint(equalTo:email.topAnchor,constant: 70),
            submit.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            submit.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            submit.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -330)
        ])
        submit.rx.tap
            .bind {
                self.didTapOnSubmit()
        }.disposed(by: disposeBag)
    }
    
    func didTapOnSubmit()
    {
        guard email.text!.isValidEmail() else {
            invalidEmailDisplay()
            return
        }
        let changeVC = DetailsViewController()
        present(changeVC, animated: true, completion: nil)
        let postBody = ["emailId" : "\(email.text!)"]
        guard let requestUrl = URL(string: "https://surya-interview.appspot.com/list") else { return }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let http = try? JSONSerialization.data(withJSONObject: postBody, options: []) else {return}
        request.httpBody = http
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {return}
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                let p = json["items"]
                self.userDefaults.set(p, forKey: "Data")
            }catch let jsonErr{
                print(jsonErr)
            }
        }
        task.resume()
    }
    
    func invalidEmailDisplay(){
        let alert = UIAlertController(title: String.localizedStringWithFormat(incorrectEmailTitle),
                                      message: String.localizedStringWithFormat(incorrectEmail),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String.localizedStringWithFormat(okayButton), style: .default, handler: { action in
            self.email.text = " "}))
        self.present(alert, animated: true)
        submit.backgroundColor = UIColor.red
    }
}
extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
