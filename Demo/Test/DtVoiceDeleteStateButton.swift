//
//  DtVoiceDeleteStateButton.swift
//  Demo
//
//  Created by Александр Прайд on 26.09.2023.
//

import SwiftUI

//protocol DtButtonState: CaseIterable {
//    var stringImage: String { get }
//}
//
//extension DtButtonState where Self: RawRepresentable, RawValue == String {
//    var stringImage: String {
//        self.rawValue
//    }
//}
//
//enum OvenState: String, ButtonState {
//    case disabled = "delete.disabled.light"
//    case enabled = "delete.enabled.light"
//}
//
//struct StateButton<T: ButtonState>: View {
//
//    let states: [T]
//    @State var currentIndex = 0
//    @Binding var selectedState: T
//
//    var body: some View {
//        Button {
//            Task {
//              //  deleteButtonAction()
//            }
//        } label: {
//            Circle()
//                .fill(Color.clear)
//                .frame(width: 48, height: 48)
//                .foregroundColor(Color.red)
//                .overlay {
//                    Image(states[currentIndex].image)
//                        .resizable()
//                        .frame(width: 24, height: 24)
//                }
//        }

//
//    }
//}

private enum DeleteButtonState {
    case enabled
    case disabled
}

struct DtVoiceDeleteStateButton: View {

    @ObservedObject private var viewModel = ViewModel()
    @State private var buttonState = DeleteButtonState.enabled

    var body: some View {
        Button {
            if (viewModel.audioURL != nil) {
                Task {
                    //  deleteButtonAction()
                }
            }
        } label: {

            switch buttonState {
            case .enabled:
                Circle()
                    .fill(Color.clear)
                    .frame(width: 48, height: 48)
                    .foregroundColor(Color.red)
                    .overlay {
                        Image((viewModel.audioURL != nil) ? DtImage.deleteEnabledLight : DtImage.deleteEnabledDark)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
            case .disabled:
                Circle()
                    .fill(Color.clear)
                    .frame(width: 48, height: 48)
                    .foregroundColor(Color.red)
                    .overlay {
                        Image(DtImage.deleteDisabledLight)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
            }

        }
    }
}

struct DtVoiceDeleteStateButton_Previews: PreviewProvider {
    static var previews: some View {
        DtVoiceDeleteStateButton()
    }
}
