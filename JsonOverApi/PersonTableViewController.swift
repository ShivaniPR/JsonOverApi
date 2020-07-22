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
    static func getDetails(person : Dictionary<String, String>) -> Person{
        let contact = Person(emailId: person["emailId"]!, firstName: person["firstName"]!, lastName: person["lastName"]!, imageUrl: person["imageUrl"]!)
        return contact
    }
}

class PersonTableViewController: UIViewController{
    let disposeBag = DisposeBag()
    let personData = UserDefaults.standard.object(forKey: "Data")!
    let tableView = UITableView()
    var personDetails:Array<Person> = []
    var dataSource: RxTableViewSectionedReloadDataSource<MySection>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        if let personData = personData as? [[String:String]] {
            for person in personData {
                let persons = PersonDetails.getDetails(person : person)
                personDetails.append(persons)
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
        let sections = [MySection(items: personDetails)]
        let dataSource = RxTableViewSectionedReloadDataSource<MySection>(
            configureCell: { dataSource, cv, indexPath, item in
                let cell = cv.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PersonTableViewCell
                cell.backgroundColor = .white
                cell.person = self.personDetails[indexPath.row]
                return cell
        })
        self.dataSource = dataSource
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension PersonTableViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
