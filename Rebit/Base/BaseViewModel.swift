//
//  BaseViewModel.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import Foundation
import Combine

protocol BaseViewModel: AnyObject {
    associatedtype Input
    associatedtype Output
    
    var cancellables: Set<AnyCancellable> { get set }
    var input: Input { get set }
    var output: Output { get set }
    func transform()
}
