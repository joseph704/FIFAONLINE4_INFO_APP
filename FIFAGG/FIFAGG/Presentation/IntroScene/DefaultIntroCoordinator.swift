//
//  DefaultIntroCoordinator.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/09/15.
//

import Foundation
import UIKit

final class DefaultIntroCoordinator: IntroCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var introViewController: IntroViewController
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.introViewController = IntroViewController()
    }
    
    func start() {
        self.introViewController.viewModel = IntroViewModel()
        self.navigationController.viewControllers = [self.introViewController]
    }
    
    func finish() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
