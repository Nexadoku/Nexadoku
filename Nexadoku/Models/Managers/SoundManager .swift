
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?
    
    func playSound(named name: String, withExtension ext: String = "wav") {
        let isSoundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
        guard isSoundEnabled else { return }
        
        if let url = Bundle.main.url(forResource: name, withExtension: ext) {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            } catch {
                print("Ошибка при воспроизведдение звука: \(error.localizedDescription)")
            }
        } else {
            print("Файл \(name).\(ext) не найден")
        }
    }
}
