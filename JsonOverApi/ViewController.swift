import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    private weak var email:UITextField!
    private weak var submit:UIButton!
    let emailPlaceholder = NSLocalizedString("emailTextBoxPlaceholder", comment: "")
    let buttonTitle = NSLocalizedString("submitButton", comment: "")
    let incorrectEmail = NSLocalizedString("incorrectEmailString", comment: "")
    let incorrectEmailTitle = NSLocalizedString("incorrectEmailTitle", comment: "")
    let error = NSLocalizedString("error", comment: "")
    let errorMessage = NSLocalizedString("errorMessage", comment: "")
    let okayButton = NSLocalizedString("okButtonText", comment: "")
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        emailTextDisplay()
        submitButtonDisplay()
    }
    
    func emailTextDisplay(){
        let emailId = UITextField()
        email = emailId
        email.translatesAutoresizingMaskIntoConstraints = false
        email.placeholder = String.localizedStringWithFormat(emailPlaceholder)
        email.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        email.tintColor = .lightGray
        email.layer.cornerRadius = 8
        email.textAlignment = .center
        view.addSubview(email)
        NSLayoutConstraint.activate([
            email.topAnchor.constraint(equalTo:view.topAnchor,constant: 220),
            email.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 25),
            email.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -25),
            email.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -400)
        ])
    }
    
    func submitButtonDisplay(){
        let submitButton = UIButton()
        submit = submitButton
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle(String.localizedStringWithFormat(buttonTitle), for: .normal)
        submit.backgroundColor = UIColor.systemBlue
        submit.layer.cornerRadius = 8
        submit.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        submit.setTitleColor(UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), for: .highlighted)
        view.addSubview(submit)
        NSLayoutConstraint.activate([
            submit.topAnchor.constraint(equalTo:email.topAnchor,constant: 70),
            submit.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 25),
            submit.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -25),
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
            setInvalidEmailAlert()
            return
        }
        UserDefaults.standard.set(true, forKey: "launchedBefore")
        let loginVC = PersonTableViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
        let postBody = ["emailId" : "\(email.text!)"]
        guard let requestUrl = URL(string: "https://surya-interview.appspot.com/list") else { return }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let http = try? JSONSerialization.data(withJSONObject: postBody, options: []) else {return}
        request.httpBody = http
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return}
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                let personDetails = json["items"]
                self.userDefaults.set(personDetails, forKey: "Data")
            }catch let jsonErr{
                self.setJsonErrorAlert()
                print(jsonErr)
            }
        }
        task.resume()
    }
    
    func setJsonErrorAlert(){
        let alert = UIAlertController(title: String.localizedStringWithFormat(error),
                                      message: String.localizedStringWithFormat(errorMessage),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String.localizedStringWithFormat(okayButton), style: .default, handler: .none))
        self.present(alert, animated: true)
    }
    
    func setInvalidEmailAlert(){
        let alert = UIAlertController(title: String.localizedStringWithFormat(incorrectEmailTitle),
                                      message: String.localizedStringWithFormat(incorrectEmail),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String.localizedStringWithFormat(okayButton), style: .default, handler: { action in
            self.email.text = " "}))
        self.present(alert, animated: true)
    }
}

extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
