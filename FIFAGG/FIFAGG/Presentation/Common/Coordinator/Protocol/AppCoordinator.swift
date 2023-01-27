//
//  AppCoordinator.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/09/20.
//

import Foundation

protocol AppCoordinator: Coordinator {}

extension AppCoordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
