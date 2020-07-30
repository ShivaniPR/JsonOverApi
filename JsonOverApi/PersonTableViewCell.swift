import UIKit

class PersonTableViewCell: UITableViewCell {
    private weak var firstnameLabel:UILabel!
    private weak var lastnameLabel:UILabel!
    private weak var emailIdLabel:UILabel!
    private weak var profileImageView:UIImageView!
    private weak var containerView:UIView!
    
    var person:Person? {
        didSet {
            guard let person = person else {return}
            if let fname = person.firstName {
                firstnameLabel.text = fname
                profileImageView.profileImageDisplay(emailId: person.emailId!)
            }
            if let lname = person.lastName {
                lastnameLabel.text = lname
            }
            if let email = person.emailId {
                emailIdLabel.text = email
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let firstname = UILabel()
        firstnameLabel = firstname
        let lastname = UILabel()
        lastnameLabel = lastname
        let emailId = UILabel()
        emailIdLabel = emailId
        let profileImage = UIImageView()
        profileImageView = profileImage
        let containerViewLabel = UIImageView()
        containerView = containerViewLabel
        firstnameDisplay()
        lastnameDisplay()
        emailIdDisplay()
        profileImageViewDisplay()
        containerViewDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func firstnameDisplay(){
        firstnameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        firstnameLabel.textColor = .black
        firstnameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(firstnameLabel)
        NSLayoutConstraint.activate([
            firstnameLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor),
            firstnameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor)
        ])
    }
    
    func lastnameDisplay(){
        lastnameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        lastnameLabel.textColor = .black
        lastnameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(lastnameLabel)
        NSLayoutConstraint.activate([
            lastnameLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor),
            lastnameLabel.leadingAnchor.constraint(equalTo:self.firstnameLabel.trailingAnchor,constant: 5),
        ])
    }
    
    func emailIdDisplay(){
        emailIdLabel.font = UIFont.boldSystemFont(ofSize: 14)
        emailIdLabel.textColor =  .black
        emailIdLabel.layer.cornerRadius = 5
        emailIdLabel.clipsToBounds = true
        emailIdLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(emailIdLabel)
        NSLayoutConstraint.activate([
            emailIdLabel.topAnchor.constraint(equalTo:self.firstnameLabel.bottomAnchor),
            emailIdLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor),
            emailIdLabel.topAnchor.constraint(equalTo:self.firstnameLabel.bottomAnchor),
            emailIdLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor)
        ])
    }
    
    func profileImageViewDisplay(){
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 35
        profileImageView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10),
            profileImageView.widthAnchor.constraint(equalToConstant:70),
            profileImageView.heightAnchor.constraint(equalToConstant:70)
        ])
    }
    
    func containerViewDisplay(){
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo:self.profileImageView.trailingAnchor, constant:10),
            containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10),
            containerView.heightAnchor.constraint(equalToConstant:40)
        ])
    }
}

extension UIImageView {
    func profileImageDisplay(emailId : String){
        if let a = UserDefaults.standard.value(forKey: emailId){
            DispatchQueue.main.async {
                self.image = UIImage(data: a as! Data)
            }
        }
        else{
            self.image = #imageLiteral(resourceName: "defaultImg")
        }
        
    }
}
