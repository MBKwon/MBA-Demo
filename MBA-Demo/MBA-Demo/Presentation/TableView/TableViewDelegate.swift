//
//  TableViewDelegate.swift
//  MBA-Demo
//
//  Created by Moonbeom KWON on 2023/09/28.
//

import UIKit

class TableViewDelegate: NSObject {
    private let data: [UserInfo]
    
    init(with data: [UserInfo]) {
        self.data = data
    }
}

extension TableViewDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userInfo = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = userInfo.name
        content.secondaryText = "\(userInfo.age) years old"
        cell.contentConfiguration = content
        
        return cell
    }
}

extension TableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
