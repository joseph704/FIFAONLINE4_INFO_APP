//
//  IntroViewModel.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/07/12.
//

import Foundation
import RxSwift

// TODO: 테스트를 위한 Import기에 지워야함
import RealmSwift

struct IntroViewModel: ViewModelType {
    private let fetchMetaInfoUseCase: FetchMetaInfoUseCase
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(fetchMetaInfoUseCase: FetchMetaInfoUseCase) {
        self.fetchMetaInfoUseCase = fetchMetaInfoUseCase
    }
    
    func convert(from: Input, disposedBag: DisposeBag) -> Output {
        fetchMetaInfoUseCase.execute()
            .subscribe(onError: { error in
                print(error.localizedDescription)
            }, onCompleted: {
                print("성공")
                let realmSPID = DefaultRealmStorage<SpidDTO>(configuration: Realm.Configuration())
                realmSPID.queryAll().subscribe {
                    print($0)
                }
                .disposed(by: disposedBag)
                
                let realmMatchtype = DefaultRealmStorage<MatchtypeDTO>(configuration: Realm.Configuration())
                realmMatchtype.queryAll().subscribe {
                    print($0)
                }
                .disposed(by: disposedBag)
                
                let realmSeasonId = DefaultRealmStorage<SeasonIdDTO>(configuration: Realm.Configuration())
                realmSeasonId.queryAll().subscribe {
                    print($0)
                }
                .disposed(by: disposedBag)
               
                let realmSPPosition = DefaultRealmStorage<SPPostionDTO>(configuration: Realm.Configuration())
                realmSPPosition.queryAll().subscribe {
                    print($0)
                }
                .disposed(by: disposedBag)
                
                let realmDivision = DefaultRealmStorage<DivisionDTO>(configuration: Realm.Configuration())
                realmDivision.queryAll().subscribe {
                    print($0)
                }
                .disposed(by: disposedBag)
            })
            .disposed(by: disposeBag)

        return Output()
    }
}

extension IntroViewModel {
    struct Input {
        
    }
    
    struct Output {
        
    }
}
