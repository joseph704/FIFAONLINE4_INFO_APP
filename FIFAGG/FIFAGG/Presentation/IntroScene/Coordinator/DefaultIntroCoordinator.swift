//
//  DefaultIntroCoordinator.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/09/15.
//

import Foundation
import UIKit

import RealmSwift

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
        self.introViewController.viewModel = IntroViewModel(
            fetchMetaInfoUseCase: DefaultFetchMetaInfoUseCase(
                metaInfoRepository: DefaultMetaInfoRepository(
                    dataTransferService: DefaultDataTransferService(
                        with: DefaultNetworkService(
                            config: ApiDataNetworkConfig(
                                baseURL: URL(string: "https://static.api.nexon.co.kr/fifaonline4/latest/")!
                            )
                        )
                    ),
                    spidRealmStorage: DefaultRealmStorage(configuration: Realm.Configuration())
                )
            )
        )
        self.navigationController.viewControllers = [self.introViewController]
    }
    
    func finish() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
