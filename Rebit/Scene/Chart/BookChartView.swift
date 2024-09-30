//
//  BookChartView.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import SwiftUI
import Charts
import RealmSwift

struct BookChartView: View {
    @ObservedResults(BookReview.self)
    var bookList
    
    @State private var monthList: [(month: String, reviewCnt: Int)] = []
    @State private var selectedYear = 2024
    @State private var yearList: [Int] = []
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                monthHeaderView()
                monthChartView()
            }
            .frame(maxWidth: .infinity)
            .frame(height: proxy.size.height * 0.5)
        }
    }
    
    func monthHeaderView() -> some View {
        return HStack {
            Text("월별통계")
                .font(.callout.bold())
            Menu {
                Picker(selection: $selectedYear,
                       label: EmptyView(),
                       content: {
                    ForEach($yearList, id: \.self) { item in
                        Text(String(item.wrappedValue))
                    }
                })
                .pickerStyle(.automatic)
                .accentColor(.white)
                .onChange(of: selectedYear) { value in
                    configureMonthList(of: value)
                }
            } label: {
                Text(String(selectedYear))
                    .font(.subheadline)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 6)
                    .background(.gray.opacity(0.5))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
    }
    
    func monthChartView() -> some View {
        Chart {
            ForEach(monthList, id: \.month) { item in
                BarMark(
                    x: .value("월", item.month),
                    y: .value("개수", item.reviewCnt),
                    width: 20,
                    stacking: .unstacked
                )
                .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 5, topTrailing: 5)))
                .foregroundStyle(.theme)
            }
        }
        .padding()
        .onAppear {
            let year = Calendar.current.component(.year, from: Date())
            configureMonthList(of: year)
            configureYearList()
        }
    }
    
    func configureMonthList(of year: Int) {
        var result: [(String, Int)] = []
        for i in 1...12 {
            let month = Date.startOfMonth(for: i, of: year)
            let nextMonth = Date.startOfMonth(for: i+1, of: year)
            let list = bookList.where { $0.endDate >= month && $0.endDate < nextMonth }
            result.append(("\(i)월", list.count))
        }
        monthList = result
    }
    
    func configureYearList() {
        let sortedList = bookList.sorted(byKeyPath: "endDate", ascending: true)
        guard let minDate = sortedList.first?.endDate else { return }
        guard let maxDate = sortedList.last?.endDate else { return }
        
        let minYear = Calendar.current.component(.year, from: minDate)
        let maxYear = Calendar.current.component(.year, from: maxDate)
        
        yearList = Array(minYear...maxYear)
    }
}
