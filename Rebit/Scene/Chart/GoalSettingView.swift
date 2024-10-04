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
    @Binding var isSheetPresent: Bool
    @Environment(\.realm) var realm
    @Environment(\.colorScheme) var color
    
    var body: some View {
        VStack(alignment: .center) {
            Text("goal-title".localized)
            HStack {
                TextField("\(goalList.first?.goal ?? 0)" , text: $goal)
                    .frame(width: 40)
                    .padding(10)
                    .tint(.theme)
                    .background(.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
                Text("chart-year-goal-count-subfix".localized)
            }
            Button(action: {
                if goalList.isEmpty {
                    appendGoal()
                } else {
                    modifyGoal()
                }
                isSheetPresent.toggle()
            }, label: {
                Text("chart-goal-register".localized)
                    .asThemeBasicButtonModifier()
                    .padding(.horizontal, 10)
            })
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(color == .light ? .white : .black)
        .onAppear {
            if let goalCount = goalList.first?.goal {
                goal = "\(goalCount)"
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        
    }
    
    func appendGoal() {
        guard let inputGoal = Int(goal) else { return }
        let goal = ReadingGoal(year: Date.currentYear(), month: 0, goal: inputGoal)
        $goalList.append(goal)
    }
    
    func modifyGoal() {
        guard let existGoal = goalList.first else { return }
        guard let inputGoal = Int(goal) else { return }
        do {
            try realm.write {
                existGoal.thaw()?.goal = inputGoal
            }
        } catch {
            print("error \(error)")
        }
    }
}


//#Preview {
//    GoalSettingView()
//}
