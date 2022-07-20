//
//  ViewModelType.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/07/14.
//

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
