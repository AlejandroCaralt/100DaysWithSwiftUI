//
//  ContentView.swift
//  Instafilter
//
//  Created by Alejandro Caralt on 3/1/26.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit

struct ContentView: View {
    @State private var processedImage: Image?
    @State private var filterIntesity: Float = 0.5
    @State private var filterRadius: Float = 0.5
    @State private var filterScale: Float = 0.5
    @State private var filterCount: Float = 0.5
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingFilters = false
    
    @State private var intensityFilerDisabled: Bool = false
    @State private var radiusFilterDisabled: Bool = false
    @State private var scaleFilterDisabled: Bool = false
    @State private var countFilterDisabled: Bool = false
    
    @AppStorage("filterCounter") var filterCounter = 0
    @Environment(\.requestReview) var requestReview
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()

    let context = CIContext()

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Filter: \(currentFilter.name)")
                        .font(.title2)
                    Spacer()
                }

                Spacer()

                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedItem, loadImage)

                Spacer()
                
                VStack {
                    HStack {
                        Text("Intensity")
                            .frame(maxWidth: 75, alignment: .leading)
                        Slider(value: $filterIntesity)
                            .onChange(of: filterIntesity) {
                                applyProcessing()
                            }
                            .disabled(selectedItem == nil || intensityFilerDisabled)
                    }
                    HStack {
                        Text("Radius")
                            .frame(maxWidth: 75, alignment: .leading)
                        Slider(value: $filterRadius)
                            .onChange(of: filterRadius) {
                                applyProcessing()
                            }
                            .disabled(selectedItem == nil || radiusFilterDisabled)
                    }
                    HStack {
                        Text("Scale")
                            .frame(maxWidth: 75, alignment: .leading)
                        Slider(value: $filterScale)
                            .onChange(of: filterScale) {
                                applyProcessing()
                            }
                            .disabled(selectedItem == nil || scaleFilterDisabled)
                    }
                    HStack {
                        Text("Count")
                            .frame(maxWidth: 75, alignment: .leading)
                        Slider(value: $filterCount)
                            .onChange(of: filterCount) {
                                applyProcessing()
                            }
                            .disabled(selectedItem == nil || countFilterDisabled)
                    }
                }
                
                HStack {
                    Button("Change Filter", action: changeFilter)
                        .disabled(selectedItem == nil)
                    Spacer()
                    
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
                    }
                }
                
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("Instafilter")
            .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                Button("Cristallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Affine Tile") { setFilter(CIFilter.affineTile()) }
                Button("AreaHistrogram") { setFilter(CIFilter.areaHistogram()) }
                Button("Fold") { setFilter(CIFilter.accordionFoldTransition()) }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    func changeFilter() {
        showingFilters = true
    }

    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            
            if currentFilter.inputKeys.contains(kCIInputExtentKey) {
                currentFilter.setValue(beginImage?.extent, forKey: kCIInputExtentKey)
            }
            applyProcessing()
        }
    }
    

    func applyProcessing(_ inputImage: CIImage? = nil) {
        let inputKeys = currentFilter.inputKeys
        
        
        intensityFilerDisabled = !inputKeys.contains(kCIInputIntensityKey)
        if !intensityFilerDisabled {
            currentFilter.setValue(filterIntesity, forKey: kCIInputIntensityKey)
        }

        radiusFilterDisabled = !inputKeys.contains(kCIInputRadiusKey)
        if !radiusFilterDisabled {
            currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)
        }

        scaleFilterDisabled = !inputKeys.contains(kCIInputScaleKey)
        if !scaleFilterDisabled {
            currentFilter.setValue(filterScale * 10, forKey: kCIInputScaleKey)
        }
        countFilterDisabled = !inputKeys.contains(kCIInputCountKey)
        if !countFilterDisabled {
            currentFilter.setValue((filterCount * 200 + 1), forKey: kCIInputCountKey)
        }
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }

    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
        
        filterCounter += 1
        
        if filterCounter >= 20 {
            requestReview()
        }
    }
}

struct ContentViewRequestReview: View {
    @Environment(\.requestReview) var requestReview

    var body: some View {
        Button("Leave a review") {
            requestReview()
        }
    }
}
struct ContentViewShareLink: View {
    var body: some View {
        ShareLink(item: URL(string: "https://www.hackingwithswift.com")!, subject: Text("Learn Swift here"), message: Text("Check out this awesome Swift tutorial!"))
        ShareLink(item: URL(string: "https://www.hackingwithswift.com")!) {
            Label("Spread the word about Swift", systemImage: "swift")
        }
        let example = Image(.example)
        ShareLink(item: example, preview: SharePreview("Singapour airport", image: example)) {
            Label("Click to share", systemImage: "airplane")
        }
    }
}

struct ContentViewPhotos: View {
    @State private var pickerItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()

    var body: some View {
        VStack {
            Spacer()
            PhotosPicker( selection: $pickerItems, maxSelectionCount: 3, matching: .any(of: [.images, .not(.screenshots)])) {
                Label("Select a picture", systemImage: "photo")
            }

            ScrollView {
                ForEach(0..<selectedImages.count, id: \.self) { i in
                        selectedImages[i]
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .onChange(of: pickerItems) {
            Task {
                selectedImages.removeAll()
                for item in pickerItems {
                    if let loadedImage = try await item.loadTransferable(type: Image.self) {
                        selectedImages.append(loadedImage)
                    }
                }
            }
        }
    }
}
struct ContentViewPSnippet: View {
    var body: some View {
        VStack {
            ContentUnavailableView("No snippets", systemImage: "swift", description: Text("You don't have any saved snippets yet"))
            
            ContentUnavailableView {
                Label("No snippets", systemImage: "swift")
            } description: {
                Text("You don't have any saved snippets yet")
            } actions: {
                Button("Create a snippet") {
                    // create a snippet
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

struct ContentViewCoreImage: View {
    @State private var image: Image?
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }
    
    func loadImage() {
        let inputImage = UIImage(resource: .example)
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.pixellate()
        
        currentFilter.inputImage = beginImage
        let amount = 1.0
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        image = Image(uiImage: uiImage)
    }
}

#Preview {
    ContentView()
}
