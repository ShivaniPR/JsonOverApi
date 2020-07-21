import UIKit
import RxSwift
import RxCocoa
import RxDataSources

extension MySection : SectionModelType {
    typealias Item = Person
    
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}

class PersonDetails {
    static func getDetails(price : Dictionary<String, String>) -> Person{
        let contact = Person(emailId: price["emailId"]!, firstName: price["firstName"]!, lastName: price["lastName"]!, imageUrl: price["imageUrl"]!)
        return contact
    }
}

class DetailsViewController: UIViewController{
    let disposeBag = DisposeBag()
    let detail = UserDefaults.standard.object(forKey: "Data")!
    let tableView = UITableView()
    var contact:Array<Person> = []
    var dataSource: RxTableViewSectionedReloadDataSource<MySection>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        if let prices = detail as? [[String:String]] {
            for price in prices {
                let contacts = PersonDetails.getDetails(price : price)
                contact.append(contacts)
            }
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: "Cell")
        setDataSource()
    }
    func setDataSource(){
        let sections = [MySection(items: contact)]
        let dataSource = RxTableViewSectionedReloadDataSource<MySection>(
            configureCell: { dataSource, cv, indexPath, item in
                let cell = cv.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PersonTableViewCell
                cell.backgroundColor = .white
                cell.contact = self.contact[indexPath.row]
                return cell
        })
        self.dataSource = dataSource
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension DetailsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
