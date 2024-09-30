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
    @State private var yearList: [(year: String, reviewCnt: Int)] = []
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectYearList: [Int] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                monthView()
                yearView()
            }
        }
    }
    
    //월별
    func monthHeaderView() -> some View {
        return VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text("월별통계")
                    .font(.callout.bold())
                Spacer()
                Menu {
                    Picker(selection: $selectedYear,
                           label: EmptyView()) {
                        ForEach($selectYearList, id: \.self) { item in
                            Text(String(item.wrappedValue))
                        }
                    }
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
            Text("총 \(monthList.map { $0.reviewCnt }.reduce(0) { $0 + $1 })권을 읽었어요")
                .asTitleGrayForeground()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
        .onAppear {
            let year = Calendar.current.component(.year, from: Date())
            configureMonthList(of: year)
            configureSelectYearList()
        }
    }
    
    func monthView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            monthHeaderView()
            monthChartView()
        }
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity)
        .frame(height: 250)
    }
    
    //년도별
    func yearHeaderView() -> some View {
        return VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text("년도별 통계")
                    .font(.callout.bold())
            }
            Text("총 \(yearList.map { $0.reviewCnt }.reduce(0) { $0 + $1 })권을 읽었어요")
                .asTitleGrayForeground()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func yearChartView() -> some View {
        Chart {
            ForEach(yearList, id: \.year) { item in
                BarMark(
                    x: .value("권수", item.reviewCnt),
                    y: .value("년도", item.year),
                    width: 20,
                    stacking: .unstacked
                )
                .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomTrailing: 5, topTrailing: 5)))
                .foregroundStyle(.theme)
            }
        }
        .frame(height: CGFloat(yearList.count * 65))
        .onAppear {
            configureYearList()
        }
    }
    
    func yearView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            yearHeaderView()
            yearChartView()
        }
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity)
    }
}

extension BookChartView {
    private func configureMonthList(of year: Int) {
        var result: [(String, Int)] = []
        for i in 1...12 {
            let month = Date.startOfMonth(for: i, of: year)
            let nextMonth = Date.startOfMonth(for: i+1, of: year)
            let list = bookList.where { $0.endDate >= month && $0.endDate < nextMonth }
            result.append(("\(i)월", list.count))
        }
        monthList = result
    }
    
    private func configureSelectYearList() {
        let sortedList = bookList.sorted(byKeyPath: "endDate", ascending: true)
        guard let minDate = sortedList.first?.endDate else { return }
        guard let maxDate = sortedList.last?.endDate else { return }
        
        let minYear = Calendar.current.component(.year, from: minDate)
        let maxYear = Calendar.current.component(.year, from: maxDate)
        
        selectYearList = Array(minYear...maxYear)
    }
    
    private func configureYearList() {
        var result: [(String, Int)] = []
        
        let list = bookList.distinct(by: ["year"]).sorted(byKeyPath: "year", ascending: false)
        
        for item in list {
            let reviewList = bookList.where { $0.year == item.year }
            result.append(("\(item.year)년", reviewList.count))
        }
        
        yearList = result
    }
}
