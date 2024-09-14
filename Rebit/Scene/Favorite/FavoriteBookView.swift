//
//  FavoriteBookView.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import SwiftUI

struct Movie : Identifiable {
    var id : Int
    var title : String
    var imageName : String
}

var latestmovie = [Movie(id: 0, title: "The Avengers", imageName: "1"),
                   Movie(id: 1, title: "Onward", imageName: "2"),
                   Movie(id: 2, title: "Soul", imageName: "3"),
                   Movie(id: 3, title: "Cruella", imageName: "4"),
                   Movie(id: 4, title: "Jungle Cruise", imageName: "5")
]


struct FavoriteBookView: View {
    var body: some View {
        NavigationView {
            BookCarouselView()
                .navigationTitle("Favorites")
        }
    }
}

struct BookCarouselView: View {
    @State private var currentIndex: Int = 0
    @GestureState var dragOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<latestmovie.count, id: \.self) { index in
                VStack {
                    Image(latestmovie[index].imageName)
                        .resizable()
                        .frame(width: 210, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .opacity(currentIndex == index ? 1.0 : 0.6)
                        .scaleEffect(currentIndex == index ? 1.0 : 0.85)
                    Text(latestmovie[index].title)
                        .font(.title)
                        .bold()
                        .opacity(currentIndex == index ? 1 : 0)
                    Text("Jenny Desmond")
                        .opacity(currentIndex == index ? 1 : 0)
                    Text("This is largest animal our planet the blue whale.\n you will find a fascinating story full of unkwnowned")
                        .multilineTextAlignment(.leading)
                        .lineLimit(4)
                        .frame(maxWidth: 210)
                        .padding()
                        .foregroundColor(.gray)
                        .opacity(currentIndex == index ? 1 : 0)
                }
                .offset(x: CGFloat(index - currentIndex) * 210 + dragOffset, y: 0)
            }
        }
        .padding()
        .gesture (
            DragGesture()
                .onEnded { value in
                    let threshold: CGFloat = 50
                    if value.translation.width > threshold {
                        withAnimation {
                            currentIndex = max(0, currentIndex - 1)
                        }
                    } else if value.translation.width < -threshold {
                        withAnimation {
                            currentIndex = min(latestmovie.count - 1, currentIndex + 1)
                        }
                    }
                }
        )
    }
}

#Preview {
    FavoriteBookView()
}
