//
//  UserListViewController.swift
//  observer-pattern
//
//  Created by Victor Roldan on 30/05/22.
//

import UIKit
import Combine

class UserListViewController: UIViewController {
    
    lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var loading : UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(style: .large)
        loading.color = .white
        loading.translatesAutoresizingMaskIntoConstraints = false
        return loading
    }()
    
    var viewModel = UserViewModel()
    var anyCancellable : [AnyCancellable] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptions()
        configTableView()
        viewModel.getUsers()
        
    }
    
    func subscriptions(){
        viewModel.reloadData.sink { _ in} receiveValue: { _ in
            self.tableView.reloadData()
        }.store(in: &anyCancellable)
        
        viewModel.$isLoading.sink {[weak self] state in
            guard let state = state else {return}
            self?.configLoading(state: state)
        }.store(in: &anyCancellable)

    }
    
    private func configTableView(){
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
    }
    
    func configLoading(state : Bool){
        if state {
            loading.startAnimating()
            tableView.addSubview(loading)
            NSLayoutConstraint.activate([
                loading.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
                loading.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            ])
            return
        }
        loading.removeFromSuperview()
    }
}

extension UserListViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = viewModel.userList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = user.name + " " + user.lastName
        return cell
    }
}
