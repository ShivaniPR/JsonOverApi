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
                profileImageView.setupProfileImage(emailId: person.emailId!)
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
        setupProfileImageView()
        setupContainerView()
        setupFirstNameView()
        setupLastNameView()
        setupEmailIdView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupFirstNameView(){
        let firstname = UILabel()
        firstnameLabel = firstname
        firstnameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        firstnameLabel.textColor = .black
        firstnameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(firstnameLabel)
        NSLayoutConstraint.activate([
            firstnameLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor),
            firstnameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor)
        ])
    }
    
    func setupLastNameView(){
        let lastname = UILabel()
        lastnameLabel = lastname
        lastnameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        lastnameLabel.textColor = .black
        lastnameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(lastnameLabel)
        NSLayoutConstraint.activate([
            lastnameLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor),
            lastnameLabel.leadingAnchor.constraint(equalTo:self.firstnameLabel.trailingAnchor,constant: 5),
        ])
    }
    
    func setupEmailIdView(){
        let emailId = UILabel()
        emailIdLabel = emailId
        emailIdLabel.font = UIFont.boldSystemFont(ofSize: 14)
        emailIdLabel.textColor =  .black
        emailIdLabel.layer.cornerRadius = 5
        emailIdLabel.clipsToBounds = true
        emailIdLabel.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(emailIdLabel)
        NSLayoutConstraint.activate([
            emailIdLabel.topAnchor.constraint(equalTo:self.firstnameLabel.bottomAnchor),
            emailIdLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor),
            emailIdLabel.topAnchor.constraint(equalTo:self.firstnameLabel.bottomAnchor),
            emailIdLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor)
        ])
    }
    
    func setupProfileImageView(){
        let profileImage = UIImageView()
        profileImageView = profileImage
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
    
    func setupContainerView(){
        let containerViewLabel = UIImageView()
        containerView = containerViewLabel
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
    func setupProfileImage(emailId : String){
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
