# Palavra Viva

Aplicativo Flutter educativo para crianças praticarem formação de palavras por módulos temáticos.

## O que o app faz

- Permite cadastrar o nome do jogador.
- Mostra módulos como Animais, Frutas, Objetos, Cores, Natureza, Corpo, Veículos e Comida.
- Oferece dois modos de jogo:
  - **Desafio**: letras embaralhadas para montar a palavra.
  - **Aprendizado**: palavra visível para copiar.
- Salva pontuação e preferência de som localmente com `shared_preferences`.
- Usa feedback visual, animações e sons gerados em memória.

## Melhorias aplicadas

- Corrigida a inicialização assíncrona do jogador para evitar mostrar cadastro antes dos dados salvos carregarem.
- Adicionada proteção contra dados corrompidos em `SharedPreferences`.
- Corrigido o teste padrão do Flutter, que ainda esperava um contador inexistente.
- Adicionados testes de widget para o fluxo inicial com e sem jogador salvo.

## Como rodar

```bash
flutter pub get
flutter run
```

## Como testar

```bash
flutter test
```

## Próximas melhorias recomendadas

- Persistir o modo de jogo escolhido.
- Adicionar conquistas por módulo.
- Criar tela de progresso por categoria.
- Adicionar acessibilidade com tamanhos maiores e leitura de palavras.
- Revisar responsividade para telas pequenas.
