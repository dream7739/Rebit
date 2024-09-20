//
//  BookReviewView.swift
//  Rebit
//
//  Created by 홍정민 on 9/20/24.
//

import SwiftUI
import RealmSwift

struct BookReviewView: View {
    @ObservedRealmObject var bookInfo: BookInfo
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
            
            VStack {
                Image(._4)
                    .resizable()
                    .frame(width: 150, height: 230)
                    .padding()
                Text("언젠가 우리가 같은 별을 바라본다면")
                    .font(.callout.bold())
                Text("게게")
                
                Divider()
                HStack {
                    Rectangle()
                        .fill(.white)
                        .overlay(alignment: .top) {
                            VStack(alignment: .center) {
                                Text("독서기간")
                                    .foregroundStyle(.gray)
                                    .font(.callout)
                                Text("24.07.01~")
                                    .font(.subheadline)
                                Text("24.07.14")
                                    .font(.subheadline)
                            }
                            
                        }
                    Rectangle()
                        .fill(.white)
                        .overlay(alignment: .top) {
                            VStack(alignment: .center) {
                                Text("평점")
                                    .foregroundStyle(.gray)
                                    .font(.callout)
                                Text("5.0")
                                    .font(.subheadline)
                            }
                            
                        }
                    Rectangle()
                        .fill(.white)
                        .overlay(alignment: .top) {
                            VStack(alignment: .center) {
                                Text("회독수")
                                    .foregroundStyle(.gray)
                                    .font(.callout)
                                Text("1회")
                                    .font(.subheadline)
                            }
                        }
                }
                .frame(height: 60)
                .padding(.horizontal, 10)
                Divider()
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("한줄평")
                        .font(.subheadline)
                    Text("감정을 느끼지 못하는 사람의 삶은 어떠한가?")
                        .font(.subheadline)
                    Text("감상평")
                        .font(.subheadline)
                    Text("주인공은 감정을 잘 느끼지 못한다. 하지만 일련의 과정으로 감정을 느끼고, 다른 사람의 감정에 공감하게 된다. 선천적인 뇌의 기형으로 감정을 잘 느끼지 못하더라도, 사람은 경험과 교류를 통해서 변할 수 있음을 알게되었다.")
                        .font(.subheadline)
                    
                }
                .padding()
                
                Spacer()
                
            }
            .background(
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 0, bottomLeading: 0, bottomTrailing: 30, topTrailing: 30))
                    .fill(.white)
                    .shadow(color: .gray.opacity(0.3), radius: 10, x: 10, y: 10)
            )
            .padding(.trailing, 20)
            .padding(.vertical)
            
        }
       
    }
    
}

#Preview {
    BookReviewView(bookInfo: BookInfo(title: "", content: "", author: "", isbn: "", pubdate: "", publisher: ""))
}
