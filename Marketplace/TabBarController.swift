//
//  TabBarController.swift
//  Marketplace
//
//  Created by Нуржан Орманали on 02.03.2021.
//

import UIKit

enum TabbarControllerType: CaseIterable {
    case main
    case orders
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
                controller.tabBarItem = UITabBarItem(title: "Главная", image: #imageLiteral(resourceName: "4. Home"), selectedImage: #imageLiteral(resourceName: "4. Home"))
                controllers.append(controller)
            case .orders:
                if let token = UserDefaults.standard.string(forKey: "Token"), !token.isEmpty {
                    let controller = WebViewController(with: "https://1224.kz/my-account/orders", token: token)
                    controller.tabBarItem = UITabBarItem(title: "Мои заказы", image: #imageLiteral(resourceName: "26. Receipt"), selectedImage: #imageLiteral(resourceName: "26. Receipt"))
                    controllers.append(controller)
                } else {
                    let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "loginViewController")
                    loginController.tabBarItem = UITabBarItem(title: "Мои заказы", image: #imageLiteral(resourceName: "26. Receipt"), selectedImage: #imageLiteral(resourceName: "26. Receipt"))
                    controllers.append(loginController)
                }
            case .profile:
                if let token = UserDefaults.standard.string(forKey: "Token"), !token.isEmpty {
                    let controller = WebViewController(with: "https://1224.kz/my-account/", token: token)
                    controller.tabBarItem = UITabBarItem(title: "Профиль", image: #imageLiteral(resourceName: "18. Account"), selectedImage: #imageLiteral(resourceName: "18. Account"))
                    controllers.append(controller)
                } else {
                    let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "loginViewController")
                    loginController.tabBarItem = UITabBarItem(title: "Профиль", image: #imageLiteral(resourceName: "18. Account"), selectedImage: #imageLiteral(resourceName: "18. Account"))
                    controllers.append(loginController)
                }
            case .basket:
                if let token = UserDefaults.standard.string(forKey: "Token"), !token.isEmpty {
                    let controller = WebViewController(with: "https://1224.kz/cart/", token: token)
                    controller.tabBarItem = UITabBarItem(title: "Корзина", image: #imageLiteral(resourceName: "8. Basket"), selectedImage: #imageLiteral(resourceName: "8. Basket"))
                    controllers.append(controller)
                } else {
                    let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "loginViewController")
                    loginController.tabBarItem = UITabBarItem(title: "Корзина", image: #imageLiteral(resourceName: "8. Basket"), selectedImage: #imageLiteral(resourceName: "8. Basket"))
                    controllers.append(loginController)
                }
            }
        })
        
        return controllers
    }
    
}
