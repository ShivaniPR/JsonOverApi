import UIKit

class PersonTableViewCell: UITableViewCell {
    
    var contact:Person? {
        didSet {
            guard let contactItem = contact else {return}
            if let fname = contactItem.firstName {
                firstnameLabel.text = fname
                profileImageView.downloaded(from: contactItem.imageUrl!)
            }
            if let lname = contactItem.lastName {
                lastnameLabel.text = lname
            }
            if let email = contactItem.emailId {
                emailIdLabel.text = " \(email) "
            }
        }
    }
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true 
        return view
    }()
    
    let profileImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 35
        img.clipsToBounds = true
        return img
    }()
    
    let firstnameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lastnameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailIdLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor =  .white
        label.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)        
        self.contentView.addSubview(profileImageView)
        containerView.addSubview(firstnameLabel)
        containerView.addSubview(lastnameLabel)
        containerView.addSubview(emailIdLabel)
        self.contentView.addSubview(containerView)
        
        profileImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant:70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant:70).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo:self.profileImageView.trailingAnchor, constant:10).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
        containerView.heightAnchor.constraint(equalToConstant:40).isActive = true
        
        firstnameLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        firstnameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        
        lastnameLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        lastnameLabel.leadingAnchor.constraint(equalTo:self.firstnameLabel.trailingAnchor,constant: 5).isActive = true
        
        emailIdLabel.topAnchor.constraint(equalTo:self.firstnameLabel.bottomAnchor).isActive = true
        emailIdLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        emailIdLabel.topAnchor.constraint(equalTo:self.firstnameLabel.bottomAnchor).isActive = true
        emailIdLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
