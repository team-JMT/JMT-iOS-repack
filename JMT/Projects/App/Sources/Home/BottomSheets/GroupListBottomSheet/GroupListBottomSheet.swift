//
//  GroupListBottomSheet.swift
//  JMTeng
//
//  Created by PKW on 2024/03/02.
//

import UIKit

class GroupListBottomSheet: UIViewController {
    
    var viewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}

extension GroupListBottomSheet: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.groupList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
        cell.textLabel?.text = viewModel?.groupList[indexPath.row].groupName ?? ""
        return cell
    }
}

extension GroupListBottomSheet: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didUpdateGroupName?(indexPath.row)
        self.dismiss(animated: true)
    }
}
