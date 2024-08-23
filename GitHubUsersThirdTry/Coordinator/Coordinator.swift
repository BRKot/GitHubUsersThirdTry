//
//  Coordinator.swift
//  GitHubUsers
//
//  Created by Databriz on 22/08/2024.
//

import UIKit
import SnapKit

protocol Coordinator {
    func start()
}

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.backgroundColor = UIColor.white
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setupBackButton(for viewController: UIViewController) {
        let backImage = UIImage(named: "BackIcone")
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(backImage, for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 210)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)

        let barButton = UIBarButtonItem(customView: backButton)

        viewController.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backButtonPressed() {
        self.navigationController.popViewController(animated: true)
    }
    
    func start() {
        showFirstViewController()
    }
    
    func showFirstViewController() {
        let usersView = UsersViewController()
        let presenter = UsersPresenter(view: usersView)
        usersView.presenter = presenter
        
        presenter.selectedUser = { userLogin in
            self.showSecondViewController(login: userLogin)
        }
        
        navigationController.pushViewController(usersView, animated: false)
    }
    
    func showSecondViewController(login: String) {
        let userInformation = UserInformationCardViewController()
        let presenter = UserInformationCardPresenter(view: userInformation, userLogin: login)
        userInformation.presenter = presenter
        
        setupBackButton(for: userInformation)
        
        presenter.selectedUser = { userLogin in
            self.showSecondViewController(login: userLogin)
        }
        
        navigationController.pushViewController(userInformation, animated: false)
    }
}
