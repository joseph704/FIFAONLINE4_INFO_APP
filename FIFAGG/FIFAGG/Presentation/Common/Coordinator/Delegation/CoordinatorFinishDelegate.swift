//
//  CoordinatorFinishDelegate.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/09/20.
//

import Foundation

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
