import 'package:flutter/material.dart';
import '../models/word_model.dart';

class ModuleInfo {
  final String name;
  final String emoji;
  final Color color;
  final Color darkColor;

  const ModuleInfo({
    required this.name,
    required this.emoji,
    required this.color,
    required this.darkColor,
  });
}

class Dictionary {
  static const List<ModuleInfo> modules = [
    ModuleInfo(name: 'Animais',   emoji: '🦁', color: Color(0xFFFF6B35), darkColor: Color(0xFFBF3D0A)),
    ModuleInfo(name: 'Frutas',    emoji: '🍎', color: Color(0xFF43A047), darkColor: Color(0xFF1B5E20)),
    ModuleInfo(name: 'Objetos',   emoji: '🏠', color: Color(0xFF1E88E5), darkColor: Color(0xFF0D47A1)),
    ModuleInfo(name: 'Cores',     emoji: '🌈', color: Color(0xFF8E24AA), darkColor: Color(0xFF4A148C)),
    ModuleInfo(name: 'Natureza',  emoji: '🌿', color: Color(0xFF00ACC1), darkColor: Color(0xFF006064)),
    ModuleInfo(name: 'Corpo',     emoji: '🫀', color: Color(0xFFE53935), darkColor: Color(0xFF7F0000)),
    ModuleInfo(name: 'Veículos',  emoji: '🚗', color: Color(0xFF546E7A), darkColor: Color(0xFF263238)),
    ModuleInfo(name: 'Comida',    emoji: '🍕', color: Color(0xFFFB8C00), darkColor: Color(0xFFBF360C)),
  ];

  static List<Word> words = [
    // ── Animais ──────────────────────────────────────────────────────────────
    Word(text: 'BODE',     category: 'Animais', difficulty: 1),
    Word(text: 'GATO',     category: 'Animais', difficulty: 1),
    Word(text: 'PATO',     category: 'Animais', difficulty: 1),
    Word(text: 'VACA',     category: 'Animais', difficulty: 1),
    Word(text: 'URSO',     category: 'Animais', difficulty: 1),
    Word(text: 'LOBO',     category: 'Animais', difficulty: 1),
    Word(text: 'PEIXE',    category: 'Animais', difficulty: 2),
    Word(text: 'TIGRE',    category: 'Animais', difficulty: 2),
    Word(text: 'COELHO',   category: 'Animais', difficulty: 2),
    Word(text: 'CAVALO',   category: 'Animais', difficulty: 2),
    Word(text: 'MACACO',   category: 'Animais', difficulty: 2),
    Word(text: 'GIRAFA',   category: 'Animais', difficulty: 2),
    Word(text: 'ELEFANTE', category: 'Animais', difficulty: 3),
    Word(text: 'JACARÉ',   category: 'Animais', difficulty: 3),
    Word(text: 'PAPAGAIO', category: 'Animais', difficulty: 3),
    Word(text: 'TARTARUGA',category: 'Animais', difficulty: 3),
    Word(text: 'BORBOLETA',category: 'Animais', difficulty: 3),

    // ── Frutas ───────────────────────────────────────────────────────────────
    Word(text: 'UVA',      category: 'Frutas', difficulty: 1),
    Word(text: 'PERA',     category: 'Frutas', difficulty: 1),
    Word(text: 'KIWI',     category: 'Frutas', difficulty: 1),
    Word(text: 'FIGO',     category: 'Frutas', difficulty: 1),
    Word(text: 'COCO',     category: 'Frutas', difficulty: 1),
    Word(text: 'MANGA',    category: 'Frutas', difficulty: 2),
    Word(text: 'LIMÃO',    category: 'Frutas', difficulty: 2),
    Word(text: 'BANANA',   category: 'Frutas', difficulty: 2),
    Word(text: 'LARANJA',  category: 'Frutas', difficulty: 2),
    Word(text: 'CEREJA',   category: 'Frutas', difficulty: 2),
    Word(text: 'MORANGO',  category: 'Frutas', difficulty: 3),
    Word(text: 'ABACAXI',  category: 'Frutas', difficulty: 3),
    Word(text: 'MELANCIA', category: 'Frutas', difficulty: 3),
    Word(text: 'MARACUJÁ', category: 'Frutas', difficulty: 3),
    Word(text: 'PITANGA',  category: 'Frutas', difficulty: 3),
    Word(text: 'AMORA',    category: 'Frutas', difficulty: 3),
    Word(text: 'ACEROLA',  category: 'Frutas', difficulty: 3),
    Word(text: 'CAJU',     category: 'Frutas', difficulty: 3),
    Word(text: 'MELÃO',    category: 'Frutas', difficulty: 3),
    Word(text: 'GOIABA',   category: 'Frutas', difficulty: 3),
    Word(text: 'MAÇÃ',     category: 'Frutas', difficulty: 3),

    // ── Objetos ──────────────────────────────────────────────────────────────
    Word(text: 'BOLA',     category: 'Objetos', difficulty: 1),
    Word(text: 'CASA',     category: 'Objetos', difficulty: 1),
    Word(text: 'MESA',     category: 'Objetos', difficulty: 1),
    Word(text: 'CAMA',     category: 'Objetos', difficulty: 1),
    Word(text: 'FACA',     category: 'Objetos', difficulty: 1),
    Word(text: 'LÁPIS',    category: 'Objetos', difficulty: 2),
    Word(text: 'CARRO',    category: 'Objetos', difficulty: 2),
    Word(text: 'LIVRO',    category: 'Objetos', difficulty: 2),
    Word(text: 'CANETA',   category: 'Objetos', difficulty: 2),
    Word(text: 'TESOURA',  category: 'Objetos', difficulty: 2),
    Word(text: 'CADERNO',  category: 'Objetos', difficulty: 3),
    Word(text: 'TELEFONE', category: 'Objetos', difficulty: 3),
    Word(text: 'MOCHILA',  category: 'Objetos', difficulty: 3),
    Word(text: 'BICICLETA',category: 'Objetos', difficulty: 3),
    Word(text: 'SAPATO',   category: 'Objetos', difficulty: 3),
    Word(text: 'CHAVE',   category: 'Objetos', difficulty: 3),
    Word(text: 'CELULAR',   category: 'Objetos', difficulty: 3),
    Word(text: 'GARFO',   category: 'Objetos', difficulty: 3),
    Word(text: 'COLHER',   category: 'Objetos', difficulty: 3),
    Word(text: 'PRATO',   category: 'Objetos', difficulty: 3),

    // ── Cores ─────────────────────────────────────────────────────────────────
    Word(text: 'AZUL',     category: 'Cores', difficulty: 1),
    Word(text: 'ROSA',     category: 'Cores', difficulty: 1),
    Word(text: 'ROXO',     category: 'Cores', difficulty: 1),
    Word(text: 'CINZA',    category: 'Cores', difficulty: 2),
    Word(text: 'VERDE',    category: 'Cores', difficulty: 2),
    Word(text: 'PRETO',    category: 'Cores', difficulty: 2),
    Word(text: 'BRANCO',   category: 'Cores', difficulty: 2),
    Word(text: 'AMARELO',  category: 'Cores', difficulty: 3),
    Word(text: 'LARANJA',  category: 'Cores', difficulty: 3),
    Word(text: 'VERMELHO', category: 'Cores', difficulty: 3),
    Word(text: 'MARROM',   category: 'Cores', difficulty: 3),
    Word(text: 'VIOLETA',  category: 'Cores', difficulty: 3),

    // ── Natureza ──────────────────────────────────────────────────────────────
    Word(text: 'SOL',      category: 'Natureza', difficulty: 1),
    Word(text: 'LUA',      category: 'Natureza', difficulty: 1),
    Word(text: 'MAR',      category: 'Natureza', difficulty: 1),
    Word(text: 'RIO',      category: 'Natureza', difficulty: 1),
    Word(text: 'LAGO',     category: 'Natureza', difficulty: 2),
    Word(text: 'FLOR',     category: 'Natureza', difficulty: 2),
    Word(text: 'CHUVA',    category: 'Natureza', difficulty: 2),
    Word(text: 'PEDRA',    category: 'Natureza', difficulty: 2),
    Word(text: 'VENTO',    category: 'Natureza', difficulty: 2),
    Word(text: 'NUVEM',    category: 'Natureza', difficulty: 2),
    Word(text: 'ÁRVORE',   category: 'Natureza', difficulty: 3),
    Word(text: 'FLORESTA', category: 'Natureza', difficulty: 3),
    Word(text: 'MONTANHA', category: 'Natureza', difficulty: 3),
    Word(text: 'CACHOEIRA',category: 'Natureza', difficulty: 3),

    // ── Corpo ─────────────────────────────────────────────────────────────────
    Word(text: 'MÃO',      category: 'Corpo', difficulty: 1),
    Word(text: 'PÉ',       category: 'Corpo', difficulty: 1),
    Word(text: 'BOCA',     category: 'Corpo', difficulty: 1),
    Word(text: 'NARIZ',    category: 'Corpo', difficulty: 2),
    Word(text: 'OLHOS',    category: 'Corpo', difficulty: 2),
    Word(text: 'BRAÇO',    category: 'Corpo', difficulty: 2),
    Word(text: 'JOELHO',   category: 'Corpo', difficulty: 2),
    Word(text: 'CABELO',   category: 'Corpo', difficulty: 2),
    Word(text: 'OMBRO',    category: 'Corpo', difficulty: 2),
    Word(text: 'OUVIDO',   category: 'Corpo', difficulty: 3),
    Word(text: 'COTOVELO', category: 'Corpo', difficulty: 3),
    Word(text: 'ESTÔMAGO', category: 'Corpo', difficulty: 3),

    // ── Veículos ──────────────────────────────────────────────────────────────
    Word(text: 'MOTO',     category: 'Veículos', difficulty: 1),
    Word(text: 'TREM',     category: 'Veículos', difficulty: 1),
    Word(text: 'NAVIO',    category: 'Veículos', difficulty: 2),
    Word(text: 'AVIÃO',    category: 'Veículos', difficulty: 2),
    Word(text: 'ÔNIBUS',   category: 'Veículos', difficulty: 2),
    Word(text: 'BARCO',    category: 'Veículos', difficulty: 2),
    Word(text: 'FOGUETE',  category: 'Veículos', difficulty: 3),
    Word(text: 'HELICÓPTERO', category: 'Veículos', difficulty: 3),
    Word(text: 'SUBMARINO',category: 'Veículos', difficulty: 3),

    // ── Comida ────────────────────────────────────────────────────────────────
    Word(text: 'PÃO',      category: 'Comida', difficulty: 1),
    Word(text: 'OVO',      category: 'Comida', difficulty: 1),
    Word(text: 'BOLO',     category: 'Comida', difficulty: 1),
    Word(text: 'SOPA',     category: 'Comida', difficulty: 1),
    Word(text: 'PIZZA',    category: 'Comida', difficulty: 2),
    Word(text: 'ARROZ',    category: 'Comida', difficulty: 2),
    Word(text: 'QUEIJO',   category: 'Comida', difficulty: 2),
    Word(text: 'BISCOITO', category: 'Comida', difficulty: 3),
    Word(text: 'MACARRÃO', category: 'Comida', difficulty: 3),
    Word(text: 'CHOCOLATE',category: 'Comida', difficulty: 3),
    Word(text: 'SANDUÍCHE',category: 'Comida', difficulty: 3),
  ];

  static List<String> get categories =>
      words.map((w) => w.category).toSet().toList();

  static List<Word> getWordsByCategory(String category) =>
      words.where((w) => w.category == category).toList();

  static List<Word> getWordsByDifficulty(int difficulty) =>
      words.where((w) => w.difficulty == difficulty).toList();

  static List<Word> getWordsByCategoryAndDifficulty(
          String category, int difficulty) =>
      words
          .where((w) => w.category == category && w.difficulty == difficulty)
          .toList();

  static ModuleInfo? getModuleInfo(String categoryName) {
    try {
      return modules.firstWhere((m) => m.name == categoryName);
    } catch (_) {
      return null;
    }
  }
}
