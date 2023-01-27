//
//  Coordinator.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/09/15.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    init(_ navigationController: UINavigationController)
    
    func start()
    func finish()
}

