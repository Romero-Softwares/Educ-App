import 'dart:convert';

import 'package:educapp/main.dart';
import 'package:educapp/models/player_model.dart';
import 'package:educapp/providers/game_provider.dart';
import 'package:educapp/providers/player_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PlayerProvider()),
          ChangeNotifierProvider(create: (_) => GameProvider()),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }

  testWidgets('mostra tela inicial de cadastro quando não existe jogador',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await pumpApp(tester);

    expect(find.textContaining('Bem-vindo'), findsOneWidget);
    expect(find.text('SALVAR'), findsOneWidget);
  });

  testWidgets('mostra home quando jogador já foi salvo',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'player_info': jsonEncode(Player(name: 'Ana', score: 7).toJson()),
      'sound_enabled': false,
    });

    await pumpApp(tester);

    expect(find.text('Palavra Viva 🌟'), findsOneWidget);
    expect(find.text('Olá, Ana! 👋'), findsOneWidget);
    expect(find.text('7 pontos no total'), findsOneWidget);
  });
}
