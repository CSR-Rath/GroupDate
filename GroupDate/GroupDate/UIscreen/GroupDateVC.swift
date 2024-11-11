//
//  GroupDateVC.swift
//  GroupDate
//
//  Created by Rath! on 12/6/24.
//

import UIKit

class GroupDateVC: UIViewController {
    
    var models: [Model] = [
        Model(type: "Deposit", created: 1724424400, desc: "Salary deposit"),
        Model(type: "Withdrawal", created: 1724510000, desc: "Rent payment"),
        Model(type: "Transfer", created: 1024590200, desc: "Payment to friend"),
        Model(type: "Deposit", created: 1724683600, desc: "Freelance payment"),
        Model(type: "Withdrawal", created: 1604770000, desc: "Cash withdrawal"),
        Model(type: "Deposit", created: 1024816400, desc: "Bonus payment"),
        Model(type: "Withdrawal", created: 1624942800, desc: "Grocery purchase"),
        Model(type: "Transfer", created: 1695009200, desc: "Payment to utility provider"),
        Model(type: "Deposit", created: 1605115600, desc: "Freelance payment"),
        Model(type: "Withdrawal", created: 1625202000, desc: "Cash withdrawal"),
        Model(type: "Deposit", created: 1625280400, desc: "Salary deposit"),
        Model(type: "Withdrawal", created: 1625374800, desc: "Rent payment"),
        Model(type: "Transfer", created: 1825461200, desc: "Payment to friend"),
        Model(type: "Deposit", created: 1825547600, desc: "Freelance payment"),
        Model(type: "Withdrawal", created: 1605634000, desc: "Cash withdrawal"),
        Model(type: "Deposit", created: 1695720400, desc: "Bonus payment"),
        Model(type: "Withdrawal", created: 1625806800, desc: "Grocery purchase"),
        Model(type: "Transfer", created: 1625893200, desc: "Payment to utility provider"),
        Model(type: "Deposit", created: 1605909600, desc: "Freelance payment"),
        Model(type: "Withdrawal", created: 1620066000, desc: "Cash withdrawal")
    ]
    var totleAll = 0
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .lightGray
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        return tableView
    }()
    
    private var groupedEvents: [String: [Model]] = [:]
    private var dates: [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Group Date"
        navigationController?.navigationBar.isHidden  = false
        setupUI()
        getDate()
        totleAll = models.count
    }
    
    
    private func getDate(){
        
        DispatchQueue.main.async { [self] in
           groupEvents(models)
        }
        
    }
    
    
    private func setupUI() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
    }
    
    private func groupEvents(_ events: [Model]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        groupedEvents = Dictionary(grouping: events) { (event) -> String in
            
            // Example integer timestamp
            let timestamp: Int = event.created!

            // Convert the integer timestamp to a Date
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
        
            return dateFormatter.string(from: date)
        }
        
        dates =  groupedEvents.keys.sorted(by: { $0 > $1 })// big to small
        //groupedEvents.keys.sorted() // small to big
        
        tableView.reloadData()

    }
}

extension GroupDateVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = dates[section]
        guard let events = groupedEvents[date] else {
            return 0
        }
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        let date = dates[indexPath.section]
        guard let events = groupedEvents[date],
              let event = events[safe: indexPath.row] else {
            return cell
        }

        cell.textLabel?.text = event.desc
        return cell
    }
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        header.backgroundColor =  .red
        
        let title = UILabel()
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = dates[section]
        header.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: header.centerYAnchor),
        ])
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastSection = tableView.numberOfSections-1
        let last = tableView.numberOfRows(inSection: lastSection) - 1
        
        if indexPath.section == lastSection{
            if indexPath.row == last &&  models.count < totleAll {
                // Cell api add new page
            }
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
}



extension Int{
    func toDate(dateForMate: String) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(self / 1000))

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = dateForMate
        // Set the locale to Khmer (Cambodia)
        displayFormatter.locale = Locale(identifier: "Kh-Km")
        let formattedDate = displayFormatter.string(from: date)

        return formattedDate
    }
}
