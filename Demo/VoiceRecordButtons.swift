//
//  VoiceRecordButtons.swift
//  Demo
//
//  Created by Александр Прайд on 12.09.2023.
//

import SwiftUI

protocol ButtonState: CaseIterable {
    var image: String { get }
}

extension ButtonState where Self: RawRepresentable, RawValue == String {
    var image: String {
        self.rawValue
    }
}

//enum OvenState: String, ButtonState {
//    case playIsDisabled = "\(DtImage.playDisabledLight)"
//    case playIsEnabled = "\(DtImage.playEnabledLight)"
//    case stopPlaying = DtImage.stopPlayingEnabledLight
//}

struct VoiceRecordButtons: View {

    @State var record: Bool = false
    @State var isPlaying: Bool = false

    private let action: () async -> Void


    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        HStack(spacing: 20) {
            deleteButton()
            recordButton(isRecording: true)
            playButton(isEnabled: false)
        }
    }
}

struct VoiceRecordButtons_Previews: PreviewProvider {
    static var previews: some View {
        VoiceRecordButtons(action: {})
    }
}

extension VoiceRecordButtons {
    @ViewBuilder
    func deleteButton(isEnabled: Bool = false) -> some View {
        Button {
            Task {
                await action()
            }
        } label: {
            ZStack {

                if isEnabled {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 48, height: 48)
                        .foregroundColor(Color.red)
                        .overlay {
                            Image(DtImage.deleteEnabledLight)
                                .resizable()
                                .frame(width: 24, height: 24)

                        }
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 48, height: 48)
                        .overlay {
                            Image(DtImage.deleteDisabledLight)
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                }

                if self.record {
//                    Circle()
//                        .stroke(Color.white, lineWidth: 6)
//                        .frame(width: 85, height: 85)
                }
            }

        }
        .background(
            RoundedRectangle(cornerRadius: 62)
                .stroke(Color.secondary, lineWidth: 1)
        )
    }

    @ViewBuilder
    func playButton(isEnabled: Bool = false) -> some View {
        Button {
            Task {
                await action()
            }
        } label: {
            ZStack {
                if isEnabled {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 48, height: 48)
                        .foregroundColor(Color.red)
                        .overlay {
                            Image(DtImage.playEnabledLight)
                                .resizable()
                                .frame(width: 24, height: 24)

                        }
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 48, height: 48)
                        .overlay {
                            Image(DtImage.stopPlayingEnabledLight)
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                }

                if self.record {
//                    Circle()
//                        .stroke(Color.white, lineWidth: 6)
//                        .frame(width: 85, height: 85)
                }
            }

        }
        .background(
            RoundedRectangle(cornerRadius: 62)
                .stroke(Color.secondary, lineWidth: 1)
        )
    }

    @ViewBuilder
    func recordButton(isRecording: Bool = false) -> some View {
        Button {
            Task {
                self.record.toggle()
            }
        } label: {
            ZStack {

                if isRecording {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 96, height: 96)
                        .foregroundColor(Color.red)
                        .overlay {
                            Image(DtImage.voiceRecording)
                                .resizable()
                                .frame(width: 48, height: 48)

                        }
//                } else {
//                    Circle()
//                        .fill(Color.clear)
//                        .frame(width: 96, height: 96)
//                        .overlay {
//                            Image(DtImage.stopRecording)
//                                .resizable()
//                                .frame(width: 48, height: 48)
//                        }
                }

                if self.record {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 96, height: 96)
                        .overlay {
                            Image(DtImage.stopRecording)
                                .resizable()
                                .frame(width: 48, height: 48)
                        }
                }
            }

        }
        .background(
            RoundedRectangle(cornerRadius: 62)
                .stroke(Color.secondary, lineWidth: 1)
        )
    }
}
