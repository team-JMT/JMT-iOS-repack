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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as? GroupListCell else { return UITableViewCell() }
        cell.setupData(imageUrl: viewModel?.groupList[indexPath.row].groupProfileImageUrl ?? "", name: viewModel?.groupList[indexPath.row].groupName ?? "", isSelected: viewModel?.groupList[indexPath.row].isSelected ?? false)
        return cell
    }
}

extension GroupListBottomSheet: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        Task {
            do {
                try await viewModel?.updateSelectedGroup(id: viewModel?.groupList[indexPath.row].groupId ?? 0)
                viewModel?.didUpdateGroupName?(indexPath.row)
                
                self.dismiss(animated: true)
            } catch {
                print(error)
            }
        }
    }
}
