import SwiftUI
import SwiftData
import UIKit

struct CameraCaptureView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var capturedImage: UIImage?
    @State private var showingCamera = false
    @State private var isProcessing = false
    @State private var processingStage = ProcessingStage.idle
    @State private var generatedCards: [GeneratedFlashcard] = []
    @State private var errorMessage: String?
    @State private var showingReview = false
    @State private var showSaveError = false
    @State private var saveErrorMessage = ""

    private let ocrService = OCRService()
    private let aiService = AIGenerationService()

    enum ProcessingStage {
        case idle
        case extractingText
        case generatingCards

        var description: String {
            switch self {
            case .idle: return ""
            case .extractingText: return "Reading text from image..."
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
                            capturedImage = nil
                        }
                    )
                } else {
                    VStack(spacing: 24) {
                        // Instructions
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Snap & Learn")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)

                            Text("Take a photo of notes or textbooks")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(Color(hex: "#8E8E93"))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 20)

                        Spacer()

                        // Preview or Instructions
                        if let image = capturedImage {
                            VStack(spacing: 16) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 400)
                                    .cornerRadius(20)
                                    .liquidGlass(cornerRadius: 20)

                                if !isProcessing {
                                    Button("Retake Photo") {
                                        capturedImage = nil
                                        showingCamera = true
                                    }
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "#0A84FF"))
                                }
                            }
                        } else {
                            VStack(spacing: 20) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 80))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color(hex: "#BF5AF2"), Color(hex: "#0A84FF")],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )

                                Text("No photo taken yet")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)

                                Text("Tap the button below to start")
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
                        if capturedImage != nil && !isProcessing {
                            Button {
                                Task {
                                    await processImage()
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
                                showingCamera = true
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 16, weight: .semibold))

                                    Text("Take Photo")
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
            .navigationTitle("Camera Capture")
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
            .sheet(isPresented: $showingCamera) {
                ImagePicker(image: $capturedImage)
            }
        }
        .alert("Error", isPresented: $showSaveError) {
            Button("OK") { }
        } message: {
            Text(saveErrorMessage)
        }
    }

    private func processImage() async {
        guard let image = capturedImage else { return }

        isProcessing = true
        errorMessage = nil

        do {
            // Step 1: Extract text with OCR
            processingStage = .extractingText
            let extractedText = try await ocrService.extractText(from: image)

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

        do {
            try modelContext.save()
            dismiss()
        } catch {
            showSaveError = true
            saveErrorMessage = "Failed to save deck: \(error.localizedDescription)"
        }
    }
}

// MARK: - Image Picker

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    CameraCaptureView()
}
