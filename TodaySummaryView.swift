//
//  TodaySummaryView.swift
//  Rollerblade
//
//  Created by Benjamin Who on 1/24/22.
//

import SwiftUI

struct TodaySummaryView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest var todayIntakeEvents: FetchedResults<WaterIntakeEvent>

    @State var ringProgressValue = 0
    @State var sumOfTotalQuantityToday = 0
    @State var sumLiquidQuantityToday = 0

    @AppStorage("dailyGoal") var dailyGoal = 88
    @State var totalWaterQuantityToday: [Int] = []
    @State var sumOfWaterQuantityToday: Int = 0
    @State var totalLiquidQuantityToday: [Int] = []
    @State var sumOfLiquidQuantityToday: Int = 0
    
    
    init() {
        
        let calendar = Calendar.current
        let dateFrom = calendar.startOfDay(for: Date())
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        let predicateTodayEvents = NSPredicate(format: "timeOfConsumption <= %@ AND timeOfConsumption >= %@", dateTo! as CVarArg, dateFrom as CVarArg)
        self._todayIntakeEvents = FetchRequest(
            entity: WaterIntakeEvent.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \WaterIntakeEvent.timeOfConsumption, ascending: false)],
            predicate: predicateTodayEvents)
  
        
    }
    
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Water")
                        .font(.callout)
                        .padding(.top)
                    Text("\(sumOfTotalQuantityToday)/\(dailyGoal) oz")
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .padding(.bottom)
                        .foregroundColor(Color.blue)
                    Text("Total")
                        .font(.caption)
                    Text("\(sumLiquidQuantityToday) oz")
                        .font(.system(size: 19, weight: .medium, design: .rounded))
                        .padding(.bottom)
                }
                Spacer()
                SummaryPercentageRing(ringWidth: 20, percent: Double(ringProgressValue), backgroundColor: Color("backgroundBlue"), foregroundColors: [Color("lightBlue"), Color("darkBlue")])
                    .frame(width: 120, height: 120)
                    .padding(.leading, 20.0)
                    .padding(.top, 20.0)
                    .padding(.bottom, 20.0)
                    .padding(.trailing, 0)
            }
            NavigationLink(destination: DailyDetailView()) {}.opacity(0)
                .buttonStyle(.plain)
        }
        .onAppear {
            print("Today Summary entered view ... updating view.")
            totalWaterQuantityToday = todayIntakeEvents.map {Int($0.waterQuantity)}
            sumOfWaterQuantityToday = totalWaterQuantityToday.reduce(0, +)
            sumOfTotalQuantityToday = sumOfWaterQuantityToday
            print(sumOfWaterQuantityToday)
            totalLiquidQuantityToday = todayIntakeEvents.map {Int($0.quantity)}
            sumOfLiquidQuantityToday = totalLiquidQuantityToday.reduce(0, +)
            sumLiquidQuantityToday = sumOfLiquidQuantityToday
            ringProgressValue = Int(Float(sumOfWaterQuantityToday)/Float(dailyGoal)*100)
        }
    }
}


