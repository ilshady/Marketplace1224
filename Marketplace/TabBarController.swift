//
//  TabBarController.swift
//  Marketplace
//
//  Created by Нуржан Орманали on 02.03.2021.
//

import UIKit

enum TabbarControllerType: CaseIterable {
    case main
    case qrcode
    case profile
    case basket
}

class TabBarController: UITabBarController {
    
    let urls: [String] = [
        "https://1224.kz",
        "https://1224.kz"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = getControllers()
    }
    
    private func getControllers() -> [UIViewController] {
        
        var controllers: [UIViewController] = []
        
        TabbarControllerType.allCases.forEach({ type in
            switch type {
            case .main:
                let controller = WebViewController(with: "https://1224.kz")
                controller.tabBarItem = UITabBarItem(title: "Главная", image: #imageLiteral(resourceName: "Home"), selectedImage: #imageLiteral(resourceName: "Home"))
                controllers.append(controller)
            case .qrcode:
                let controller = QRViewController()
                controller.tabBarItem = UITabBarItem(title: "Сканер", image: #imageLiteral(resourceName: "QR"), selectedImage: #imageLiteral(resourceName: "QR"))
                controllers.append(controller)
            case .profile:
                if let token = UserDefaults.standard.string(forKey: "Token"), !token.isEmpty {
                    let controller = WebViewController(with: "https://1224.kz/my-account/", token: token)
                    controller.tabBarItem = UITabBarItem(title: "Профиль", image: #imageLiteral(resourceName: "Person"), selectedImage: #imageLiteral(resourceName: "Person"))
                    controllers.append(controller)
                } else {
                    let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "loginViewController")
                    loginController.tabBarItem = UITabBarItem(title: "Профиль", image: #imageLiteral(resourceName: "Person"), selectedImage: #imageLiteral(resourceName: "Person"))
                    controllers.append(loginController)
                }
            case .basket:
                if let token = UserDefaults.standard.string(forKey: "Token"), !token.isEmpty {
                    let controller = WebViewController(with: "https://1224.kz/cart/", token: token)
                    controller.tabBarItem = UITabBarItem(title: "Корзина", image: #imageLiteral(resourceName: "Cart"), selectedImage: #imageLiteral(resourceName: "Cart"))
                    controllers.append(controller)
                } else {
                    let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "loginViewController")
                    loginController.tabBarItem = UITabBarItem(title: "Корзина", image: #imageLiteral(resourceName: "Cart"), selectedImage: #imageLiteral(resourceName: "Cart"))
                    controllers.append(loginController)
                }
            }
        })
        
        return controllers
    }
    
}
