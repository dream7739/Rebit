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
    @ObservedResults(BookReview.self, where: { $0.status == 2 })
    var bookList
    
    @ObservedResults(ReadingGoal.self, where: { $0.year == Date.currentYear() })
    var goalList
    
    @State private var goalAchievePercent: Double = 0.0
    @State private var monthList: [(month: String, reviewCnt: Int)] = []
    @State private var yearList: [(year: String, reviewCnt: Int)] = []
    @State private var selectedYear = Date.currentYear()
    @State private var selectYearList: [Int] = []
    @State private var isSheetPresent = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                goalHeaderView()
                monthView()
                yearView()
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 15)
            .sheet(isPresented: $isSheetPresent, onDismiss: {
                goalAchievePercent = configureAchieve()
            }, content: {
                GoalSettingView(isSheetPresent: $isSheetPresent)
                    .presentationDetents([.height(200)])
            })
        }
        .padding(.bottom, 30)
    }
    
    //목표 설정
    func goalHeaderView() -> some View {
        VStack {
            if goalList.isEmpty {
                VStack(alignment: .center) {
                    Text("chart-no-goal".localized)
                        .font(.callout)
                    Button(action: {
                        isSheetPresent.toggle()
                    }) {
                        Text("chart-goal-register".localized)
                            .asGreenCapsuleBackground()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 150)
            } else {
                VStack(alignment: .leading) {
                    HStack {
                        Text("chart-year-goal".localized)
                            .font(.callout.bold())
                        Spacer()
                        Button(action: {
                            isSheetPresent.toggle()
                        }, label: {
                            Text("chart-goal-modify".localized)
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        })
                    }
                    HStack {
                        CircularProgressView(progress: $goalAchievePercent)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("chart-year-goal-count".localized + ": " + getGoalCnt().formatted() + "chart-year-goal-count-subfix".localized)
                                .asContentBlackForeground()
                            Text("chart-current-goal-count".localized + ": " + getAchieveCnt().formatted() + "chart-year-goal-count-subfix".localized)
                                .asContentBlackForeground()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                }
                .onAppear {
                    goalAchievePercent = configureAchieve()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 150)
    }
    
    //월별
    private func monthHeaderView() -> some View {
        return VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text("chart-montly-graph".localized)
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
            Text("chart-montly-total".localized + " \(monthList.map { $0.reviewCnt }.reduce(0) { $0 + $1 })" + "chart-montly-total-subfix".localized)
                .asTitleGrayForeground()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func monthChartView() -> some View {
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
            configureMonthList(of: Date.currentYear())
            configureSelectYearList()
        }
    }
    
    private func monthView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            monthHeaderView()
            monthChartView()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 250)
    }
    
    //년도별
    private func yearHeaderView() -> some View {
        return VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text("chart-yearly-graph".localized)
                    .font(.callout.bold())
            }
            Text("chart-montly-total".localized + " \(yearList.map { $0.reviewCnt }.reduce(0) { $0 + $1 })" + "chart-montly-total-subfix".localized)
                .asTitleGrayForeground()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func yearChartView() -> some View {
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
    
    private func yearView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            yearHeaderView()
            yearChartView()
        }
        .frame(maxWidth: .infinity)
    }
}

extension BookChartView {
    //올해의 리뷰 권수
    private func getAchieveCnt() -> Int {
        let achieveCnt = yearList.filter { $0.year == "\(Date.currentYear())년" }.first?.reviewCnt ?? 0
        return achieveCnt
    }
    
    //올해의 목표 권수
    private func getGoalCnt() -> Int {
        guard let goalCnt = goalList.first?.goal, goalCnt != 0  else { return 0 }
        return goalCnt
    }
    
    //올해 목표달성률
    private func configureAchieve() -> Double {
        let achieveCnt = getAchieveCnt()
        let goalCnt = getGoalCnt()
        
        guard goalCnt != 0 else { return 0 }
        
        let achievePercent = Double(achieveCnt) / Double(goalCnt)
        return achievePercent
    }
    
    private func configureMonthList(of year: Int) {
        var result: [(String, Int)] = []
        for i in 1...12 {
            let month = Date.startOfMonth(for: i, of: year)
            let nextMonth = Date.startOfMonth(for: i+1, of: year)
            let list = bookList.where { $0.endDate >= month && $0.endDate < nextMonth }
            result.append(("\(i)" + "chart-graph-month".localized, list.count))
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
            result.append(("\(item.year)" + "chart-graph-year".localized, reviewList.count))
        }
        
        yearList = result
    }
}
