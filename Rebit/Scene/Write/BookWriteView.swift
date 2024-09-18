//
//  BookWriteView.swift
//  Rebit
//
//  Created by 홍정민 on 9/15/24.
//

import SwiftUI

struct BookWriteView: View {
    @Binding var isFullPresented: Bool
    @State private var summaryText: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var rating: Double = 5
    @State private var reviewText: String = ""
    @State private var selectedStatus: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            titleView()
            readingStatusView()
            ratingView()
            dateView()
            summaryView()
            reviewView()
            writeButton()
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
    
    func titleView() -> some View {
        HStack {
            Text("이 책은 어떤 책인가요?")
                .font(.system(size: 20).bold())
            Spacer()
            Button(action: {
                isFullPresented = false
            }, label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.black)
            })
            .frame(alignment: .trailing)
        }
        .frame(maxWidth: .infinity)
    }
    
    func readingStatusView() -> some View {
        VStack(alignment: .leading) {
            Text("독서 상태를 알려주세요")
                .font(.subheadline)
            HStack {
                ForEach(ReadingStatus.allCases, id: \.self) { item in
                    StatusCardView(selectedIndex: $selectedStatus, index: item.rawValue)
                }
             
            }
        }
    }
    
    func ratingView() -> some View {
        VStack(alignment: .leading) {
            Text("평점을 매겨주세요")
                .font(.subheadline)
            CustomCosmosView(rating: $rating)
            
        }
    }
    
    func dateView() -> some View {
        VStack(alignment: .leading) {
            Text("독서한 기간을 알려주세요")
                .font(.subheadline)
            DatePicker("시작일", selection: $startDate, displayedComponents: .date)
                .font(.subheadline)
            DatePicker("종료일", selection: $endDate, displayedComponents: .date)
                .font(.subheadline)
        }
    }
    
    func summaryView() -> some View {
        VStack(alignment: .leading) {
            Text("나만의 한줄평을 입력해보세요")
                .font(.subheadline)
            HStack(alignment: .top) {
                Image(systemName: "quote.opening")
                    .font(.system(size: 10))
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.1))
                    
                    TextField("", text: $summaryText)
                        .font(.footnote)
                        .tint(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                }
                .frame(height: 35)
                
                Image(systemName: "quote.closing")
                    .font(.system(size: 10))
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    func reviewView() -> some View {
        VStack(alignment: .leading) {
            Text("전체적인 감상평을 남겨보세요")
                .font(.subheadline)
            
            TextEditor(text: $reviewText)
                .font(.footnote)
                .textInputAutocapitalization(.none)
                .autocorrectionDisabled()
                .tint(.black)
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .scrollContentBackground(.hidden)
        }
    }

    func writeButton() -> some View {
        Button(action: {}, label: {
            Text("작성하기")
                .asThemeBasicButtonModifier()
        })
    }
}


enum ReadingStatus: Int, CaseIterable {
    case expected = 0
    case current
    case completed
    
    var title: String {
        switch self {
        case .expected:
            return "독서예정"
        case .current:
            return "독서중"
        case .completed:
            return "독서완료"
        }
    }
}

struct StatusCardView: View {

    @Binding var selectedIndex: Int
    var index: Int

    var body: some View {
        Button(action: {
            selectedIndex = index
        }, label: {
            RoundedRectangle(cornerRadius: 10)
                .stroke(selectedIndex == index ? .theme.opacity(0.5) : .gray.opacity(0.5), lineWidth: 1.5)
                .frame(height: 100)
                .overlay {
                    VStack {
                        Image(.character)
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text(ReadingStatus.allCases[index].title)
                            .font(.caption)
                    }
                }
        })
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    BookWriteView(isFullPresented: .constant(false))
}
