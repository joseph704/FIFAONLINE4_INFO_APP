//
//  DefaultAppCoordinator.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/09/20.
//

import Foundation
import UIKit

final class DefaultAppCoordinator: AppCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showIntroFlow()
    }
    
    func showIntroFlow() {
        let introCoordinator = DefaultIntroCoordinator(navigationController)
        introCoordinator.finishDelegate = self
        introCoordinator.start()
        childCoordinators.append(introCoordinator)
    }
}

extension DefaultAppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === childCoordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
