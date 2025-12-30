//
//  ContentView.swift
//  Animations
//
//  Created by Alejandro Caralt on 20/11/25.
//

import SwiftUI

struct CircleContentView: View {
    @State private var animationAmount = 1.0

    var body: some View {
        Button("Tap me") {
            //animationAmount += 1
        }
        .padding(50)
        .background(Color.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
        .overlay(
            Circle()
                .stroke(.red)
                .scaleEffect(animationAmount)
                .opacity(2 - animationAmount)
                .animation(
                    .easeOut(duration: 2)
                    .repeatForever(autoreverses: false)
                    , value: animationAmount)
        )
        .onAppear {
            animationAmount = 2
        }
    }
}

struct New2ContentView: View {
    @State private var animationAmount = 1.0
    
    var body: some View {
        print(animationAmount)

        return VStack {
            Stepper("Scale amount", value: $animationAmount.animation(
                .easeInOut(duration: 1)
                .repeatCount(3, autoreverses: true)
            ), in: 1...10)
            
            Spacer()
            
            Button("Tap Me") {
                animationAmount += 1
            }
            .padding(40)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(.circle)
            .scaleEffect(animationAmount)
        }
    }
}

struct DContentView: View {
    @State private var animationAmount = 0.0

    var body: some View {
        print(animationAmount)
        return Button("Tape me") {
            withAnimation(.spring(duration: 1, bounce: 0.5)) {
                animationAmount += 360
            }
        }
        .padding(50)
        .background(Color.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
        .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
    }
}

struct NContentView: View {
    @State private var enable = false
    var body: some View {
        Button("Tap me") {
            enable.toggle()
        }
        .frame(width: 200, height: 200)
        .background(enable ? Color.green : Color.red)
        .foregroundStyle(.white)
        .animation(.easeInOut, value: enable)
        .clipShape(.rect(cornerRadius: enable ? 60 : 0))
        .animation(.spring(duration: 1, bounce: 0.9), value: enable)
    }
}

struct LContentView: View {
    @State private var offSet = CGSize.zero
    
    var body: some View {
        LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 200, height: 200)
            .clipShape(.rect(cornerRadius: 10))
            .offset(offSet)
            .gesture(
                DragGesture()
                    .onChanged { offSet = $0.translation }
                    .onEnded { _ in
                        withAnimation(.bouncy) {
                            offSet = .zero
                        }
                    }
            )
    }
}

struct ContentView: View {
    let letters = Array("DJ Killer")
    
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count, id: \.self) { index in
                Text(String(letters[index]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(.linear.delay(Double(index) / 20), value: dragAmount)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { dragAmount = $0.translation }
                .onEnded { _ in
                    dragAmount = .zero
                    enabled.toggle()
                }
        )
    }
}

#Preview {
    LContentView()
}
