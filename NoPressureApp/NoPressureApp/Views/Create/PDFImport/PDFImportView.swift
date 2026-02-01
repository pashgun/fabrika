import SwiftUI
import SwiftData
import PDFKit
import UniformTypeIdentifiers

struct PDFImportView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var selectedPDF: URL?
    @State private var showingDocumentPicker = false
    @State private var isProcessing = false
    @State private var processingStage = ProcessingStage.idle
    @State private var generatedCards: [GeneratedFlashcard] = []
    @State private var errorMessage: String?
    @State private var showingReview = false

    private let aiService = AIGenerationService()

    enum ProcessingStage {
        case idle
        case extractingText
        case generatingCards

        var description: String {
            switch self {
            case .idle: return ""
            case .extractingText: return "Reading PDF content..."
            case .generatingCards: return "Generating flashcards..."
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                MeshBackground()

                if showingReview {
                    ReviewGeneratedCardsView(
                        cards: $generatedCards,
                        onSave: { deckName, deckDescription, colorHex, icon in
                            saveDeck(name: deckName, description: deckDescription, color: colorHex, icon: icon)
                        },
                        onCancel: {
                            showingReview = false
                            generatedCards = []
                            selectedPDF = nil
                        }
                    )
                } else {
                    VStack(spacing: 24) {
                        // Instructions
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Import PDF")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)

                            Text("Select a PDF document to convert")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(Color(hex: "#8E8E93"))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 20)

                        Spacer()

                        // Preview or Instructions
                        if let pdfURL = selectedPDF {
                            VStack(spacing: 16) {
                                // PDF Icon and Name
                                VStack(spacing: 12) {
                                    Image(systemName: "doc.fill")
                                        .font(.system(size: 80))
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [Color(hex: "#FF453A"), Color(hex: "#FF9F0A")],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )

                                    Text(pdfURL.lastPathComponent)
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                }
                                .padding(40)
                                .liquidGlass(cornerRadius: 20)

                                if !isProcessing {
                                    Button("Choose Different PDF") {
                                        selectedPDF = nil
                                        showingDocumentPicker = true
                                    }
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "#0A84FF"))
                                }
                            }
                        } else {
                            VStack(spacing: 20) {
                                Image(systemName: "doc.badge.plus")
                                    .font(.system(size: 80))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color(hex: "#FF453A"), Color(hex: "#FF9F0A")],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )

                                Text("No PDF selected")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)

                                Text("Tap the button below to choose a PDF")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(Color(hex: "#8E8E93"))
                            }
                        }

                        Spacer()

                        // Processing Status
                        if isProcessing {
                            VStack(spacing: 12) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.5)

                                Text(processingStage.description)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 30)
                        }

                        // Error Message
                        if let error = errorMessage {
                            Text(error)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color(hex: "#FF453A"))
                                .padding(.horizontal, 24)
                                .multilineTextAlignment(.center)
                        }

                        // Action Button
                        if selectedPDF != nil && !isProcessing {
                            Button {
                                Task {
                                    await processPDF()
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 16, weight: .semibold))

                                    Text("Generate Flashcards")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                            }
                            .liquidButton()
                            .padding(.horizontal, 24)
                        } else if !isProcessing {
                            Button {
                                showingDocumentPicker = true
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "doc.badge.plus")
                                        .font(.system(size: 16, weight: .semibold))

                                    Text("Choose PDF")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                            }
                            .liquidButton()
                            .padding(.horizontal, 24)
                        }

                        Spacer().frame(height: 60)
                    }
                }
            }
            .navigationTitle("PDF Import")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !showingReview && !isProcessing {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(Color(hex: "#0A84FF"))
                    }
                }
            }
            .sheet(isPresented: $showingDocumentPicker) {
                DocumentPicker(selectedURL: $selectedPDF)
            }
        }
    }

    private func processPDF() async {
        guard let pdfURL = selectedPDF else { return }

        isProcessing = true
        errorMessage = nil

        do {
            // Step 1: Extract text from PDF
            processingStage = .extractingText
            let extractedText = try await extractTextFromPDF(url: pdfURL)

            // Step 2: Generate flashcards
            processingStage = .generatingCards
            let cards = try await aiService.generateFlashcards(from: extractedText)

            await MainActor.run {
                generatedCards = cards
                showingReview = true
                isProcessing = false
                processingStage = .idle
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isProcessing = false
                processingStage = .idle
            }
        }
    }

    private func extractTextFromPDF(url: URL) async throws -> String {
        guard let document = PDFDocument(url: url) else {
            throw NSError(domain: "PDFImport", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to load PDF"])
        }

        var allText = ""
        let pageCount = document.pageCount

        for pageIndex in 0..<min(pageCount, 20) { // Limit to first 20 pages
            if let page = document.page(at: pageIndex),
               let pageContent = page.string {
                allText += pageContent + "\n\n"
            }
        }

        guard !allText.isEmpty else {
            throw NSError(domain: "PDFImport", code: 2, userInfo: [NSLocalizedDescriptionKey: "No text found in PDF"])
        }

        return allText
    }

    private func saveDeck(name: String, description: String?, color: String, icon: String) {
        let deck = Deck(
            name: name,
            description: description,
            colorHex: color,
            icon: icon
        )
        modelContext.insert(deck)

        for card in generatedCards {
            let flashcard = Flashcard(
                front: card.front,
                back: card.back,
                deck: deck
            )
            modelContext.insert(flashcard)
        }

        try? modelContext.save()
        dismiss()
    }
}

// MARK: - Document Picker

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedURL: URL?
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                parent.selectedURL = url
            }
            parent.dismiss()
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.dismiss()
        }
    }
}

#Preview {
    PDFImportView()
}
