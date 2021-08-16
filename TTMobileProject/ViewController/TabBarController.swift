//
//  TabBarController.swift
//  TTMobileProject
//
//  Created by Mihailo Jovanovic on 16.8.21..
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.selectedIndex = UserDefaults.standard.integer(forKey: "selectedTab")
        
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let selectedIndex = tabBar.items?.firstIndex(of: item) else {
            return
        }
        UserDefaults.standard.set(selectedIndex, forKey: "selectedTab")
    }

}
