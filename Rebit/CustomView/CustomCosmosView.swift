//
//  CustomCosmosView.swift
//  Rebit
//
//  Created by 홍정민 on 9/17/24.
//

import SwiftUI
import Cosmos

struct CustomCosmosView: UIViewRepresentable {
    
    @Binding var rating: Double

     func makeUIView(context: Context) -> CosmosView {
         CosmosView()
     }

     func updateUIView(_ uiView: CosmosView, context: Context) {
         uiView.rating = rating
         uiView.text = rating.formatted() + "점"
         // Autoresize Cosmos view according to it intrinsic size
         uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
         uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
       
         // Change Cosmos view settings here
         uiView.settings.starSize = 20
         uiView.settings.filledImage = UIImage(named: "ratingFill")
         uiView.settings.emptyImage = UIImage(named: "rating")
         uiView.settings.fillMode = .full
         uiView.didFinishTouchingCosmos = { rating in
             uiView.text = rating.formatted() + "점"
             uiView.rating = rating
             context.coordinator.rating = rating
         }

     }
    
    class Coordinator: NSObject {
        @Binding var rating: Double
        
        init(rating: Binding<Double>) {
            self._rating = rating
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(rating: $rating)
    }
}
