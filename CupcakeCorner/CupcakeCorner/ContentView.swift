//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Alejandro Caralt on 9/12/25.
//

import SwiftUI

struct ContentView: View {
    @State private var order = Order()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.type) {
                        
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                Section {
                    Toggle("Any special request?", isOn: $order.specialRequestEnable)
                    
                    if order.specialRequestEnable {
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                    }
                }
                Section {
                    NavigationLink("Delivery details") {
                        AddressView(order: order)
                    }
                }
            }
            .animation(.default, value: order.specialRequestEnable)
            .navigationTitle("Cupckae Corner")
        }
    }
}
#Preview {
    ContentView()
}
