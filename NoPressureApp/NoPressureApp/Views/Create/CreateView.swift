import SwiftUI

struct CreateView: View {
    @State private var showingManualCreate = false
    @State private var showingCameraCapture = false
    @State private var showingPDFImport = false
    @State private var showingTextImport = false

    var body: some View {
        NavigationStack {
            ZStack {
                MeshBackground()

                VStack(spacing: 24) {
                    Text("Create Flashcards")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 60)

                    Spacer()

                    // Three input options
                    VStack(spacing: 16) {
                        CreateOptionCard(
                            icon: "camera.fill",
                            emoji: "📷",
                            title: "Camera",
                            subtitle: "Snap notes or textbook"
                        ) {
                            showingCameraCapture = true
                        }

                        CreateOptionCard(
                            icon: "doc.fill",
                            emoji: "📄",
                            title: "PDF",
                            subtitle: "Import documents"
                        ) {
                            showingPDFImport = true
                        }

                        CreateOptionCard(
                            icon: "text.alignleft",
                            emoji: "✍️",
                            title: "Text",
                            subtitle: "Paste or type"
                        ) {
                            showingTextImport = true
                        }
                    }
                    .padding(.horizontal, 24)

                    Spacer()

                    Button {
                        showingManualCreate = true
                    } label: {
                        Text("Create Manually")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(hex: "#0A84FF"))
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingManualCreate) {
                ManualCreateView()
            }
            .sheet(isPresented: $showingCameraCapture) {
                CameraCaptureView()
            }
            .sheet(isPresented: $showingPDFImport) {
                PDFImportView()
            }
            .sheet(isPresented: $showingTextImport) {
                TextImportView()
            }
        }
    }
}

struct CreateOptionCard: View {
    let icon: String
    let emoji: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(emoji)
                    .font(.system(size: 40))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)

                    Text(subtitle)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(hex: "#8E8E93"))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(Color(hex: "#8E8E93"))
            }
            .padding(24)
            .glassCard()
        }
    }
}
