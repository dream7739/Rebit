//
//  BookWriteView.swift
//  Rebit
//
//  Created by 홍정민 on 9/15/24.
//

import SwiftUI

struct BookWriteView: View {
    @State private var summaryText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            titleView()
            readingStatusView()
            summaryView()
            dateView()
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
    
    func titleView() -> some View {
        Text("이 책은 어떤 책인가요?")
            .font(.system(size: 20).bold())
    }
    func readingStatusView() -> some View {
        VStack(alignment: .leading) {
            Text("독서 상태를 알려주세요")
                .font(.subheadline)
            HStack {
                StatusCardView(.expected)
                StatusCardView(.current)
                StatusCardView(.completed)
            }
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
    
    func dateView() -> some View {
        VStack {
            Text("독서한 기간을 알려주세요")
                .font(.subheadline)
        }
    }
}


struct StatusCardView: View {
    enum ReadingStatus: String {
        case expected = "독서예정"
        case current = "독서중"
        case completed = "독서완료"
    }
    
    var status: ReadingStatus
    
    init(_ status: ReadingStatus) {
        self.status = status
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.white)
            .shadow(color: .gray.opacity(0.3), radius: 3)
            .frame(height: 100)
            .overlay {
                VStack {
                    Image(.character)
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text(status.rawValue)
                        .font(.caption)
                }
            }
        
    }
}


#Preview {
    BookWriteView()
}
