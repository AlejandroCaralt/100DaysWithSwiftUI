//
//  ContentView.swift
//  BetterRest
//
//  Created by Alejandro Caralt on 17/11/25.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeUpTime
    @State private var sleepAmount = 8
    @State private var coffeeAmount = 1
    
    var recommendedSleepAmount: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 3600
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: Double(sleepAmount), coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "Sorry, something went wrong"
        }
    }
    
    static var defaultWakeUpTime : Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("Please enter the time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                } header: {
                    Text("When do you want to wake up")
                        .font(.headline)
                }
                
                Section {
                    Picker("", selection: $sleepAmount) {
                        ForEach(6...14, id: \.self) {
                            Text("\($0) hours")
                        }
                    }
                    .pickerStyle(.wheel)
                } header: {
                    Text("Desired amount for sleep")
                        .font(.headline)
                }
                
                Section {
                    Picker("", selection: $coffeeAmount) {
                        ForEach(1...20, id: \.self) {
                            Text("^[\($0) cup](inflect: true)")
                        }
                    }
                    .pickerStyle(.wheel)
                } header: {
                    Text("Daily coffee intake")
                        .font(.headline)
                }
                
                Section {
                    Text("\(recommendedSleepAmount)")
                        .font(.title)
                } header: {
                    Text("Stimated ideal bedtime")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
