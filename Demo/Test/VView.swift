//
//  VView.swift
//  Demo
//
//  Created by Александр Прайд on 19.09.2023.
//

import SwiftUI

protocol RecordViewing {
    func recordButtonAction()
    func deleteButtonAction()
    func playButtonAction()
    func playButtonImage() -> Image
}

struct VView: View {

    @StateObject private var viewModel = ViewModel()

    var body: some View {

        VStack {
            Text("Recording Status: \(viewModel.recordingStatus)")
                .padding()

            Spacer()

            Text("\(Int(viewModel.elapsedTime))")
                .font(.largeTitle)
                .foregroundColor(.red)
                .opacity(viewModel.isRecording ? 1 : 0)
                .animation(.linear(duration: 0.1))

            Slider(value: $viewModel.elapsedTime, in: 0...viewModel.maxDuration)
                .disabled(viewModel.isRecording)
                .padding()

            HStack {
                //DtVoiceDeleteStateButton()
                
                deleteButton
                recordButton
                playButton
            }

        }

    }
}

struct VView_Previews: PreviewProvider {
    static var previews: some View {
        VView()
    }
}

// MARK: - UI Elements
extension VView {
    private var recordButton: some View {
        Button {
            Task {
                recordButtonAction()
            }
        } label: {

            Circle()
                .fill(Color.clear)
                .frame(width: 96, height: 96)
                .foregroundColor(Color.red)
                .overlay {
                    Image(viewModel.isRecording ? DtImage.stopRecording :  DtImage.voiceRecording
                    )
                    .resizable()
                    .frame(width: 48, height: 48)
                }
        }
        .background(
            RoundedRectangle(cornerRadius: 62)
                .stroke(Color.secondary, lineWidth: 1)
        )
    }

    private var deleteButton: some View {
        Button {
            Task {
                deleteButtonAction()
            }
        } label: {

            Circle()
                .fill(Color.clear)
                .frame(width: 48, height: 48)
                .foregroundColor(Color.red)
                .overlay {
                    Image(viewModel.audioURL != nil ? DtImage.deleteEnabledLight : DtImage.deleteDisabledLight)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .background(
                    RoundedRectangle(cornerRadius: 62)
                        .stroke(Color.secondary, lineWidth: 1)
                )
        }

    }

    private var playButton: some View {
        Button {
            Task {
                playButtonAction()
            }
        } label: {
            if viewModel.audioURL != nil {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 48, height: 48)
                    .foregroundColor(Color.red)
                    .overlay {
                        Image(viewModel.isPlaying ? DtImage.stopPlayingEnabledLight : DtImage.playEnabledLight)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }

            } else {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 48, height: 48)
                    .foregroundColor(Color.red)
                    .overlay {
                        Image(DtImage.playDisabledLight)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
            }


        }
        .background(
            RoundedRectangle(cornerRadius: 62)
                .stroke(Color.secondary, lineWidth: 1)
        )
    }
}

// MARK: - RecordViewing
extension VView: RecordViewing {
    func playButtonImage() -> Image {
        if viewModel.isPlaying {
            return Image(DtImage.stopPlayingEnabledLight)

        } else {
            if viewModel.audioURL != nil {
                return Image(DtImage.playEnabledLight)

            } else {
                return Image(DtImage.playEnabledLight)

            }
        }
    }

    func recordButtonAction() {
        if viewModel.isRecording {
            viewModel.stopRecording()

        } else {
            viewModel.startRecording()
        }
    }

    func deleteButtonAction() {
        viewModel.delete()
    }

    func playButtonAction() {

        if viewModel.isPlaying == true {
            viewModel.stopPlayback()
        } else if viewModel.audioURL != nil {
                viewModel.play()
        }
    }

}
