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
    @State var image: UIImage?
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    .theme.opacity(0.3)
                )
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                asHorizontalPageContent(height: proxy.size.height) {
                    ForEach(bookInfo.reviewList, id: \.id) { review in
                        ReviewContentView(bookInfo: bookInfo, reviewInfo: review, image: image)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            image = ImageFileManager.shared.loadImageToDocument(filename: "\(bookInfo.id)")
        }
    }
}

struct ReviewContentView: View {
    @ObservedRealmObject var bookInfo: BookInfo
    @ObservedRealmObject var reviewInfo: BookReview
    var image: UIImage?
    
    var body: some View {
        VStack {
            headerView()
            Divider()
            infoSectionView()
            Divider()
            contentSectionView()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(
            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomTrailing: 30, topTrailing: 30))
                .fill(.white)
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 10, y: 5)
        )
        .padding(.trailing, 20)
        .padding(.vertical)
    }
    
    func headerView() -> some View {
        VStack {
            Image(uiImage: image ?? UIImage())
                .resizable()
                .frame(width: 150, height: 230)
                .padding(.top, 10)
            Text(bookInfo.title)
                .font(.callout.bold())
            Text(bookInfo.author)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .overlay(alignment: .topTrailing) {
            optionMenuView()
        }
    }
    
    func optionMenuView() -> some View {
        HStack(alignment: .center, spacing: 4) {
            Button(action: {
                $reviewInfo.isLike.wrappedValue.toggle()
            }, label: {
                if $reviewInfo.isLike.wrappedValue {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.red)
                        .imageScale(.large)
                } else {
                    Image(systemName: "heart")
                        .foregroundStyle(.black)
                        .imageScale(.large)
                }
            })
            Menu {
                Button("수정", action: {})
                Button("삭제", action: {})
                Button("상세정보", action: {})
            } label: {
                Image(.dotList)
                    .frame(width: 30, height: 30)
            }
        }
        .padding(.top, 10)
        .padding(.trailing, 10)
    }
    
    func infoSectionView() -> some View {
        HStack {
            infoBoxView("독서기간", reviewInfo.periodDescription)
            infoBoxView("평점", reviewInfo.ratingDescription)
            infoBoxView("리뷰수", bookInfo.reviewCountDescription)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
    }
    
    func infoBoxView(_ title: String, _ content: String) -> some View {
        Rectangle()
            .fill(.white)
            .overlay(alignment: .center) {
                VStack(alignment: .center, spacing: 4) {
                    Text(title)
                        .foregroundStyle(.gray)
                        .font(.caption)
                    Text(content)
                        .font(.callout.bold())
                }
            }
    }
    
    func contentSectionView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            contentView("한줄평", reviewInfo.title)
            contentView("감상평", reviewInfo.content)
            contentView("독서기간", reviewInfo.readingDateDescription)
            contentView("저장일", reviewInfo.saveDateDescription)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
    }
    
    func contentView(_ title: String, _ content: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .asTitleGrayForeground()
            Text(content)
                .asContentBlackForeground()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}



