//
//  BookWriteView.swift
//  Rebit
//
//  Created by 홍정민 on 9/15/24.
//

import SwiftUI
import RealmSwift

struct BookWriteView: View {
    private enum Field: Hashable {
        case title
        case content
        case initial
    }
    
    @Binding var isFullPresented: Bool
    @StateObject private var viewModel: BookWriteViewModel
    @FocusState private var focusedField: Field?
    
    init(book: Book, isFullPresented: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: BookWriteViewModel(book: book))
        self._isFullPresented = isFullPresented
    }
    
    var body: some View {
        ScrollView {
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
            .padding()

        }
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(viewModel.output.dismissRequest) { _ in
            isFullPresented = false
        }
        .onTapGesture {
            print("안녕")
            UIApplication.shared.endEditing()
        }
        .onSubmit {
            switch focusedField {
            case .title:
                focusedField = .content
            default:
                print("default")
            }
        }
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
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func readingStatusView() -> some View {
        VStack(alignment: .leading) {
            Text("독서 상태를 알려주세요")
                .font(.subheadline)
            HStack {
                ForEach(ReadingStatus.allCases, id: \.self) { item in
                    StatusCardView(selectedIndex: $viewModel.output.selectedStatus, index: item.rawValue)
                }
                
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func ratingView() -> some View {
        VStack(alignment: .leading) {
            Text("평점을 매겨주세요")
                .font(.subheadline)
            CustomCosmosView(rating: $viewModel.output.rating)
                .onTapGesture(count: 999999) { }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func dateView() -> some View {
        VStack(alignment: .leading) {
            Text("독서한 기간을 알려주세요")
                .font(.subheadline)
            DatePicker("시작일", selection: $viewModel.output.startDate, displayedComponents: .date)
                .font(.subheadline)
                .onTapGesture(count: 999999) { }
            DatePicker("종료일", selection: $viewModel.output.endDate, displayedComponents: .date)
                .font(.subheadline)
                .onTapGesture(count: 999999) { }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func summaryView() -> some View {
        VStack(alignment: .leading) {
            Text("나만의 한줄평을 입력해보세요")
                .font(.subheadline)
            
            TextField("이 책을 한줄로 정의해보세요", text: $viewModel.output.summaryText)
                .font(.footnote)
                .tint(.black)
                .padding(10)
                .focused($focusedField, equals: .title)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.1))
                )
                .frame(height: 35)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func reviewView() -> some View {
        VStack(alignment: .leading) {
            Text("전체적인 감상평을 남겨보세요")
                .font(.subheadline)
            
            TextEditor(text: $viewModel.output.reviewText)
                .font(.footnote)
                .textInputAutocapitalization(.none)
                .autocorrectionDisabled()
                .tint(.black)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .scrollContentBackground(.hidden)
                .frame(height: 200)
                .focused($focusedField, equals: .content)
                .overlay(alignment: .topLeading) {
                    Text("책을 읽은 후의 감상을 적어보세요")
                        .font(.footnote)
                        .foregroundStyle(.gray.opacity(0.6))
                        .padding(.vertical, 15)
                        .padding(.horizontal, 13)
                        .opacity(viewModel.output.reviewText.isEmpty ? 1.0 : 0)
                }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func writeButton() -> some View {
        Button(action: {
            viewModel.input.saveReview.send(())
        }, label: {
            Text("작성하기")
                .asThemeBasicButtonModifier()
        })
    }
}

struct StatusCardView: View {
    @Binding var selectedIndex: Int
    var index: Int
    
    var body: some View {
        Button(action: {
            selectedIndex = index
        }, label: {
            Text(ReadingStatus.allCases[index].title)
                .font(.caption)
                .padding(.vertical, 8)
                .padding(.horizontal, 13)
                .background(selectedIndex == index ? .theme : .white)
                .foregroundStyle(selectedIndex == index ? .white : .black)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(selectedIndex == index ? .clear: .gray.opacity(0.4), lineWidth: 1)
                )
        })
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    BookWriteView(
        book: Book(title: "", image: "", author: "", publisher: "", pubdate: "", isbn: "", description: ""),
        isFullPresented: .constant(true)
    )
}
