

import Foundation
import AVFoundation

class SoundManager: ObservableObject {
    
    static let instance = SoundManager()
    
    private let audioEngine = AVAudioEngine()
    private var audioPlayers: [AVAudioPlayerNode] = []
    private var mixerNodes: [AVAudioMixerNode] = []
    
    // Громкость от 0.0 до 1.0
    @Published var volume: Float = 0.5 {
        didSet {
            updateVolume()
            // Сохраняем в UserDefaults
            UserDefaults.standard.set(volume, forKey: "sound_volume")
        }
    }
    
    private init() {
        // Загружаем сохраненную громкость
        volume = UserDefaults.standard.float(forKey: "sound_volume")
        if volume == 0 && (UserDefaults.standard.object(forKey: "sound_volume") == nil) {
            volume = 0.0 // Значение по умолчанию
        }
    }
    
    func playSound(sound: String, loop: Bool = false) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: ".mp3") else { return }
        
        do {
            let audioFile = try AVAudioFile(forReading: url)
            let audioPlayer = AVAudioPlayerNode()
            let mixerNode = AVAudioMixerNode()
            
            // Настраиваем аудио граф
            audioEngine.attach(audioPlayer)
            audioEngine.attach(mixerNode)
            
            // Подключаем: player -> mixer -> main mixer
            audioEngine.connect(audioPlayer, to: mixerNode, format: audioFile.processingFormat)
            audioEngine.connect(mixerNode, to: audioEngine.mainMixerNode, format: audioFile.processingFormat)
            
            // Устанавливаем громкость
            mixerNode.outputVolume = volume
            
            // Запускаем движок если нужно
            if !audioEngine.isRunning {
                try audioEngine.start()
            }
            
            if loop {
                // Для зацикленного звука
                audioPlayer.scheduleFile(audioFile, at: nil) {
                    // Перезапускаем файл для зацикливания
                    audioPlayer.scheduleFile(audioFile, at: nil, completionHandler: nil)
                }
                audioPlayer.play()
            } else {
                // Для обычного звука
                audioPlayer.scheduleFile(audioFile, at: nil) {
                    // Убираем проигрыватель после завершения
                    DispatchQueue.main.async {
                        self.removePlayer(audioPlayer, mixer: mixerNode)
                    }
                }
                audioPlayer.play()
            }
            
            // Сохраняем ссылки
            audioPlayers.append(audioPlayer)
            mixerNodes.append(mixerNode)
            
        } catch let error {
            print("Sound not found! \(error.localizedDescription)")
        }
    }
    
    private func removePlayer(_ player: AVAudioPlayerNode, mixer: AVAudioMixerNode) {
        player.stop()
        audioEngine.detach(player)
        audioEngine.detach(mixer)
        
        if let playerIndex = audioPlayers.firstIndex(of: player) {
            audioPlayers.remove(at: playerIndex)
        }
        if let mixerIndex = mixerNodes.firstIndex(of: mixer) {
            mixerNodes.remove(at: mixerIndex)
        }
    }
    
    private func updateVolume() {
        // Обновляем громкость для всех активных звуков
        for mixer in mixerNodes {
            mixer.outputVolume = volume
        }
    }
    
    func stopAllSounds() {
        for (player, mixer) in zip(audioPlayers, mixerNodes) {
            player.stop()
            audioEngine.detach(player)
            audioEngine.detach(mixer)
        }
        audioPlayers.removeAll()
        mixerNodes.removeAll()
    }
    
    // Удобные методы для изменения громкости
    func setVolume(_ newVolume: Float) {
        volume = max(0.0, min(1.0, newVolume))
    }
    
    func mute() {
        volume = 0.0
    }
    
    func unmute() {
        volume = 0.5
    }
}
