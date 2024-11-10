//
//  MVIContainer.swift
//  Rebit
//
//  Created by 홍정민 on 11/2/24.
//

import SwiftUI
import Combine

final class MVIContainer<Intent, Model>: ObservableObject {
    let intent: Intent
    let model: Model
    
    private var cancellable: Set<AnyCancellable> = []
    
    init(
        intent: Intent,
        model: Model,
        modelChangePublisher: ObjectWillChangePublisher
    ) {
        self.intent = intent
        self.model = model
        
        modelChangePublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: objectWillChange.send)
            .store(in: &cancellable)
    }
    
    func binding<Value>(
        for keyPath: ReferenceWritableKeyPath<Model, Value>
    ) -> Binding<Value> {
        Binding(
            get: { self.model[keyPath: keyPath] },
            set: { self.model[keyPath: keyPath] = $0 }
        )
    }
}

