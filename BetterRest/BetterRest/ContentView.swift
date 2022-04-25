//
//  ContentView.swift
//  BetterRest
//
//  Created by Patompong Manprasatkul on 24/04/2022.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1

    private static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }

    private var calculatedBedtimeTitle: String {
        do {
            let configuration = MLModelConfiguration()
            let mlModel = try SleepCalculator(configuration: configuration)

            let modelInput = SleepCalculatorInput(wake: getSeconds(from: wakeUp), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let prediction = try mlModel.prediction(input: modelInput)
            let sleepTime = wakeUp - prediction.actualSleep
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "Sorry, can't calculate bedtime at this moment"
        }
    }

    var body: some View {
        NavigationView {
            Form  {
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up?")
                        .font(.headline)

                    DatePicker("Please enter a time", selection: $wakeUp,  displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)

                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    Picker(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", selection: $coffeeAmount) {
                        ForEach(1...20, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text("Your estimates bedtime is ...")
                        .font(.headline)
                    Text(calculatedBedtimeTitle)
                        .font(.largeTitle.bold())
                }
            }
            .navigationTitle("BetterRest")
        }
    }

    private func getSeconds(from date: Date) -> Double {
        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: date)
        return Double((dateComponent.hour ?? 0) * 60 + (dateComponent.minute ?? 0)) * 60
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
