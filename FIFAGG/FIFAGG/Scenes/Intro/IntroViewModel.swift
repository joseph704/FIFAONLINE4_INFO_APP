//
//  IntroViewModel.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/07/12.
//

import Foundation

struct IntroViewModel: ViewModelType {
    let input: Input
    let output: Output
    
    init(input: Input) {
        self.input = input
        
        self.output = Output()
    }
}

extension IntroViewModel {
    struct Input {
        
    }
    
    struct Output {
        
    }
}
