//
//  ViewModel.swift
//  Demo
//
//  Created by Александр Прайд on 19.09.2023.
//

import Foundation
import AVFoundation

class ViewModel: NSObject, ObservableObject, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    private var timer: Timer?

    @Published var audioURL: URL?

    @Published var isRecording: Bool = false
    @Published var isPlaying: Bool = false
    @Published var isPaused: Bool = false
    @Published var isDeleted: Bool = false
    @Published var isEnabled: Bool = false
    @Published var recordingProgress: Double = 0
    @Published var recordingStatus: String = "Not Recording"

    @Published var elapsedTime: TimeInterval = 0
    @Published var maxDuration: TimeInterval = 15.0

    override init() {
        super.init()
        let fileName = self.getDocumentsDirectory().appendingPathComponent("recording.m4a")
        audioURL = fileName
        print(audioURL)
    }

    func startRecording() {
        isRecording = true
        recordingProgress = 0 // Сброс прогресса записи

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else { return }

            self.recordingProgress += 0.1 / self.maxDuration

            if self.recordingProgress >= 1.0 {
                self.stopRecording()
            }
        }

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        guard let url = audioURL else { return }

//        if fileExist(path: url.path) {
//
//            do {
//                try FileManager.default.removeItem(atPath: url.path)
//            } catch {
//                print("error remove file \(url.path) - \(error.localizedDescription)")
//            }
//        }


        print("метод записи \(url.path)")
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            isRecording = true
            recordingStatus = "Recording..."

            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                guard let elapsedTime = self?.audioRecorder?.currentTime else { return }
                self?.elapsedTime = elapsedTime

                if elapsedTime >= self?.maxDuration ?? 0 {
                    self?.isRecording = false
                }
            }
        } catch {
            print("Error recording audio: \(error)")
        }
    }

    func stopRecording() {
        isRecording = false
        timer?.invalidate()
        audioRecorder?.stop()
        recordingStatus = "Recording Stopped"
    }

    func play() {
        isPlaying = true
        guard let url = audioURL else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true

            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                guard let elapsedTime = self?.audioPlayer?.currentTime else { return }
                self?.elapsedTime = elapsedTime

                if elapsedTime >= self?.audioPlayer?.duration ?? 0 {
                    self?.isPlaying = false
                }
            }
        } catch {
            print("Error playing audio: \(error)")
        }

    }

    func stopPlayback() {
        audioPlayer?.pause()
        isPlaying = false
        isPaused = true

        recordingStatus = "Recording is Paused"

        timer?.invalidate()
        timer = nil
    }

    func delete() {

        recordingStatus = "Recording is Deleted"

        guard let url = audioURL?.path else { return }
        print("первый \(url)")

        removeOldFile(path: url)

        if fileExist(path: url) {
            print("второй \(url)")
           // removeOldFile(path: url)

            do {
                try FileManager.default.removeItem(atPath: url)

                print("внутри if")
            } catch {
                print("error remove file \(url) - \(error.localizedDescription)")
            }
        }

        elapsedTime = 0
        timer?.invalidate()
        timer = nil
    }

    private func fileExist(path: String) -> Bool {
        var isDir = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        return exists && isDir.boolValue
    }

    private func removeOldFile(path: String) {
        var isDir:ObjCBool = false
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDir) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {
                print("error remove file \(path) - \(error.localizedDescription)")
            }
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        if flag {
//            let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
//
//            do {
//                let audioData = try Data(contentsOf: audioFilename)
//            } catch {
//                print("Failed to load recorded audio data")
//            }
//        }
    }

}
