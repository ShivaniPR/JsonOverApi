import UIKit
import RxSwift
import RxCocoa
import RxDataSources

extension TableSections : SectionModelType {
    typealias Item = Person
    
    init(original: TableSections, items: [Item]) {
        self.items = items
    }
}

class PersonTableViewController: UIViewController{
    let disposeBag = DisposeBag()
    let personData = UserDefaults.standard.object(forKey: "Data")!
    private weak var tableView:UITableView!
    var personDetails:Array<Person> = []
    var dataSource: RxTableViewSectionedReloadDataSource<TableSections>?
    
    override func viewDidAppear(_ animated: Bool) {
        setDataSource()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        let table = UITableView()
        tableView = table
        view.addSubview(tableView)
        if let personData = personData as? [[String:String]] {
            for person in personData {
                let persons = Person(person: person)
                personDetails.append(persons)
            }
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: "Cell")
        storeProfileImage(images: personDetails)
    }
    
    func storeProfileImage(images : [Person]){
        for image in images{
            let url = URL(string: image.imageUrl!)!
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil{
                    UserDefaults.standard.set(data, forKey: image.emailId!)
                }
                else {
                    print("404 Image Not Found")
                    return }
            }.resume()
        }
    }
    
    func setDataSource(){
        let sections = [TableSections(items: personDetails)]
        let dataSource = RxTableViewSectionedReloadDataSource<TableSections>(
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


