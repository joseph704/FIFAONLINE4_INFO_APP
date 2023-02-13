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
