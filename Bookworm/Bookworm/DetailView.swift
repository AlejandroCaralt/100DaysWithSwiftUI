//
//  DetailView.swift
//  Bookworm
//
//  Created by Alejandro Caralt on 28/12/25.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false

    let book: Book
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(book.genre)
                        .resizable()
                        .scaledToFit()
                    
                    Text(book.genre.uppercased())
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundStyle(.white)
                        .background(.black.opacity(0.75))
                        .clipShape(.capsule)
                        .offset(x: -5, y: -5)
                }
                
                Text(book.author)
                    .font(.title)
                    .foregroundStyle(.secondary)
                
                Text(book.review)
                    .padding()
                
                RatingView(rating: .constant(book.rating))
                    .font(.largeTitle)
                
                Text(book.date.formatted(date: .numeric, time: .omitted))
                    .padding()
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 250)
            }
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Delete book", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure?")
        }
        .toolbar {
            Button("Delete this book", systemImage: "trash") {
                showingDeleteAlert = true
            }
        }
    }
    
    func deleteBook() {
        modelContext.delete(book)
        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Book.self, configurations: config)
    let example = Book(title: "Test Book", author: "Test Author", genre: "Fantasy", review: "This was a great book", rating: 4)

    DetailView(book: example)
        .modelContainer(container)
}
