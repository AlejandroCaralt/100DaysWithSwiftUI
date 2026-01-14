//
//  ContentView.swift
//  BucketList
//
//  Created by Alejandro Caralt on 8/1/26.
//

import SwiftUI
import MapKit
import LocalAuthentication


struct ContentView: View {
    
    // Start position for the map view of UK
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    @State private var viewModel = ViewModel()

    var body: some View {
        if viewModel.iSUnlocked {
            ZStack {
                MapReader { proxy  in
                    Map(initialPosition: startPosition) {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                            }
                        }
                    }
                    .mapStyle(viewModel.mapHybrid ? .hybrid : .standard)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local)
                        {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) { newLocation in
                            viewModel.update(location: newLocation)
                        }
                    }
                    .alert("Error authenticating", isPresented: $viewModel.authenticationError) {
                        Text(viewModel.authenticationErrorMessage)
                    }
                }
                Button(viewModel.mapHybrid ? "Standard" : "Hybrid", systemImage: viewModel.mapHybrid ? "map.fill" : "globe.europe.africa.fill") {
                    viewModel.mapHybrid.toggle()
                }
                    .padding()
                    .font(.headline)
                    .background(.white.opacity(0.15))
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
                    .padding(.leading, 250)
                    .padding(.bottom, 750)
            }
        } else {
            VStack {
                Button("Unlock Places", action: viewModel.authenticate)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
            }
            .alert("Error authenticating", isPresented: $viewModel.authenticationError) {
                Text(viewModel.authenticationErrorMessage)
            }
        }
    }
}


struct ContentViewL: View {
    @State private var isUnlocked = false
    
    var body: some View {
        VStack {
            if isUnlocked {
                Text("Unlocked")
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    isUnlocked = true
                } else {
                    // There was a problem
                }
            }
        } else {
            // no biometrics
        }
    }
}


struct LocationN: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct ContentViewMaps: View {
    let locations = [
        LocationN(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
        LocationN(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275))
    ]
    @State private var position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
    
    var body: some View {
        
        VStack {
            MapReader { proxy in
                Map()
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .global) {
                            print("Tapped at: \(coordinate)")
                        }
                    }
            }
        }
        //        Map(position: $position)
        //            .mapStyle(.hybrid(elevation: .realistic))
        //            .onMapCameraChange(frequency: .continuous) { context in
        //                print(context.region)
        //            }
        //
        //        HStack {
        //            Button("Paris") {
        //                position = MapCameraPosition.region(MKCoordinateRegion(
        //                    center: CLLocationCoordinate2D(latitude: 48.856613, longitude: 2.352222),
        //                    span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        //                )
        //                )
        //            }
        //            Button("Tokyo") {
        //                position = MapCameraPosition.region(MKCoordinateRegion(
        //                    center: CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917),
        //                    span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        //                )
        //                )
        //            }
        //        }
    }
}









struct LoadingView: View {
    var body: some View {
        Text("Loading...")
    }
}

struct SuccessView: View {
    var body: some View {
        Text("Success!")
    }
}

struct FailedView: View {
    var body: some View {
        Text("Failed.")
    }
}

struct ContentView2: View {
    
    enum LoadingStates {
        case loading, success, failed
    }
    
    @State private var loadingState = LoadingStates.loading
    
    var body: some View {
        switch loadingState {
        case .loading:
            LoadingView()
        case .success:
            SuccessView()
        case .failed:
            FailedView()
        }
        Button("Read and write") {
            let data = Data("Text Message".utf8)
            let url = URL.documentsDirectory.appending(path: "message.txt")
            
            do {
                try data.write(to: url, options: [.atomic, .completeFileProtection])
                let input = try String(contentsOf: url, encoding: .utf8)
                print(input)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView()
}
