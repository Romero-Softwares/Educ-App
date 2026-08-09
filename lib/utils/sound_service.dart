import 'dart:math';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';

/// Generates and plays WAV audio entirely in memory — no asset files needed.
class SoundService {
  static final AudioPlayer _playerA = AudioPlayer();
  static final AudioPlayer _playerB = AudioPlayer();
  static bool _enabled = true;

  static void setEnabled(bool value) => _enabled = value;
  static bool get isEnabled => _enabled;

  // ---------------------------------------------------------------------------
  // WAV generator
  // ---------------------------------------------------------------------------
  static Uint8List _buildWav({
    required List<int> freqs,
    required List<int> durMs,
    double amplitude = 0.35,
    int sampleRate = 22050,
    String wave = 'sine', // 'sine' | 'square' | 'triangle'
  }) {
    int total = 0;
    for (final d in durMs) {
      total += (sampleRate * d / 1000).round();
    }

    final pcm = Int16List(total);
    int idx = 0;

    for (int i = 0; i < freqs.length; i++) {
      final freq = freqs[i];
      final n = (sampleRate * durMs[i] / 1000).round();
      final fade = (n * 0.08).round().clamp(1, n);

      for (int j = 0; j < n; j++) {
        double env = 1.0;
        if (j < fade) env = j / fade;
        if (j > n - fade) env = (n - j) / fade;

        final t = j / sampleRate;
        double s;
        if (wave == 'square') {
          s = sin(2 * pi * freq * t) >= 0 ? 1.0 : -1.0;
        } else if (wave == 'triangle') {
          s = 2 / pi * asin(sin(2 * pi * freq * t));
        } else {
          s = sin(2 * pi * freq * t);
        }
        pcm[idx++] = (s * amplitude * env * 32767).round().clamp(-32768, 32767);
      }
    }

    // Build WAV container
    final data = ByteData(44 + total * 2);
    // RIFF
    data.setUint8(0, 0x52); data.setUint8(1, 0x49);
    data.setUint8(2, 0x46); data.setUint8(3, 0x46);
    data.setUint32(4, 36 + total * 2, Endian.little);
    // WAVE
    data.setUint8(8, 0x57); data.setUint8(9, 0x41);
    data.setUint8(10, 0x56); data.setUint8(11, 0x45);
    // fmt
    data.setUint8(12, 0x66); data.setUint8(13, 0x6D);
    data.setUint8(14, 0x74); data.setUint8(15, 0x20);
    data.setUint32(16, 16, Endian.little);
    data.setUint16(20, 1, Endian.little);  // PCM
    data.setUint16(22, 1, Endian.little);  // Mono
    data.setUint32(24, sampleRate, Endian.little);
    data.setUint32(28, sampleRate * 2, Endian.little);
    data.setUint16(32, 2, Endian.little);
    data.setUint16(34, 16, Endian.little);
    // data chunk
    data.setUint8(36, 0x64); data.setUint8(37, 0x61);
    data.setUint8(38, 0x74); data.setUint8(39, 0x61);
    data.setUint32(40, total * 2, Endian.little);
    for (int i = 0; i < total; i++) {
      data.setInt16(44 + i * 2, pcm[i], Endian.little);
    }
    return data.buffer.asUint8List();
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Happy ascending arpeggio — acertou a palavra!
  static Future<void> playCorrect() async {
    if (!_enabled) return;
    final bytes = _buildWav(
      freqs:   [523, 659, 784, 1047],
      durMs:   [80,  80,  80,  280],
      amplitude: 0.38,
    );
    await _playerA.play(BytesSource(bytes));
  }

  /// Descending buzzer — letra errada.
  static Future<void> playWrong() async {
    if (!_enabled) return;
    final bytes = _buildWav(
      freqs:   [380, 280],
      durMs:   [120, 300],
      amplitude: 0.30,
      wave: 'square',
    );
    await _playerB.play(BytesSource(bytes));
  }

  /// Short click — feedback ao pressionar botão.
  static Future<void> playClick() async {
    if (!_enabled) return;
    final bytes = _buildWav(
      freqs:   [900],
      durMs:   [35],
      amplitude: 0.18,
    );
    await _playerA.play(BytesSource(bytes));
  }

  /// Fanfare — fim de sessão / level up!
  static Future<void> playLevelUp() async {
    if (!_enabled) return;
    final bytes = _buildWav(
      freqs:   [523, 659, 784, 659, 784, 1047],
      durMs:   [80,  80,  80,  80,  80,  500],
      amplitude: 0.42,
    );
    await _playerA.play(BytesSource(bytes));
  }

  /// Estrela ganha — som curto de celebração.
  static Future<void> playStar() async {
    if (!_enabled) return;
    final bytes = _buildWav(
      freqs:   [880, 1100, 1320],
      durMs:   [60,  60,   200],
      amplitude: 0.32,
    );
    await _playerA.play(BytesSource(bytes));
  }
}
