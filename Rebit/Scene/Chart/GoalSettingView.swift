//
//  GoalSettingView.swift
//  Rebit
//
//  Created by 홍정민 on 9/30/24.
//

import SwiftUI
import RealmSwift

struct GoalSettingView: View {
    @ObservedResults(ReadingGoal.self, where: { $0.year == Date.currentYear() })
    var goalList
    
    @State private var goal = ""
    var body: some View {
        VStack(alignment: .center) {
            Text("올해 몇 권의 책을 읽을까요?")
            HStack {
                TextField("\(goalList.first?.goal ?? 0)" , text: $goal)
                    .frame(width: 40)
                    .padding(10)
                    .tint(.theme)
                    .background(.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
                Text("권")
            }
            Button(action: {
                if goalList.isEmpty {
                    guard let inputGoal = Int(goal) else { return }
                    let goal = ReadingGoal(year: Date.currentYear(), month: 0, goal: inputGoal)
                    $goalList.append(goal)
                } else {
                    guard let existGoal = goalList.first else { return }
                    guard let inputGoal = Int(goal) else { return }
                }
                
            }, label: {
                Text("등록하기")
                    .asThemeBasicButtonModifier()
                    .padding(.horizontal, 10)
            })
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(.white)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        
    }
}

//#Preview {
//    GoalSettingView()
//}
