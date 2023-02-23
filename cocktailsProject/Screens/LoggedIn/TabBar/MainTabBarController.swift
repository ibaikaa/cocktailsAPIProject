//
//  MainTabBarController.swift
//  cocktailsProject
//
//  Created by ibaikaa on 23/2/23.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private var itemsImages: [UIImage] = [
        .init(systemName: "person.circle")!,
        .init(systemName: "plus.square")!,
        .init(systemName: "house.circle")!,
        .init(systemName: "heart.circle")!,
        .init(systemName: "cart.circle")!
    ]
    
    private func configureVCs() {
        guard let vcs = viewControllers else { return }
        for id in 0..<vcs.count {
            let vc = vcs[id]
            vc.tabBarItem.image = generateItemIcon(from: itemsImages[id])
            vc.tabBarItem.title = nil
        }
        self.selectedIndex = 2
    }
    
    private func generateItemIcon(from icon: UIImage) -> UIImage {
        icon.resizeImage(to: CGSize(width: 40, height: 40))
    }
    
    
    private func setTabBarAppearance() {
        // Colors configuring for UITabBar
        tabBar.backgroundColor = .mainBeige
        tabBar.tintColor = .mainOrange
        tabBar.unselectedItemTintColor = .tabBarItemLight
        tabBar.isTranslucent = true
        
        tabBar.clipsToBounds = true
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .mainBeige
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        
        tabBar.itemPositioning = .centered

    }
    
    
    override func loadView() {
        super.loadView()
        print("loaded tab bar")
        setTabBarAppearance()
        configureVCs()
    }
    
}
