# GoodBuy

App fictício simulando um e-commerce para fins do teste técnico para a <b>Caveo</b>.

## Proposta

- Possui uma tela de Splash onde ocorre o carregamento de dados, via cache ou API em tempo real;
- Em seguida, exibe uma tela com listagem paginada e infinita de produtos;
- Implementado com foco em Clean Code e uso do Command Pattern;
- Gerenciamento de estado com Riverpod;
- Navegação com GoRouter (sem uso de rotas nomeadas);
- Estrutura organizada com comandos separados e poucas modificações estruturais;
- Mapeamento de DTOs e serialização de objetos com json_serializable;
- Testes implementados para repositórios, conversões DTO->Entity e comandos;
- Utiliza cache local e animações básicas.
---

## Estrutura 
<pre>
lib/
├── app/
│ └── app_widget.dart
├── application/
│ ├── <b>commands</b>/
│ ├── use-cases/
│ ├── repositories/
│ └── dtos/
├── domain/
│ ├── use-cases/
│ └── entities/
├── infrastructure/
│ ├── api/
│ └── repositories/
├── presentation/
│ ├── pages/
│ └── widgets/
├── shared/
│ ├── <b>clients</b>/
│ └── <b>constants</b>/
└── utils/
</pre>
<pre>
<b>
test/
├── application/
│ └── commands/
└── infrastructure/
  └── repositories/</b>
</pre>
---

## Tecnologias

- **Flutter e Dart null-safety**
- **Riverpod** – Gerenciamento de estado / injeção
- **Dio** – Requisições HTTP
- **GoRouter** – Navegação
- **Command Pattern** – Organização da lógica
- **JSON Serializable** – Serializar objetos
- **Flutter Test** - Testes
- **Shared Preferences** – Cache
- **flutter_animate** – Animacao
---

## Build & Teste

Foi utilizado Flutter SDK 3.32.7, testado em Windows, Linux e Android.

Rode o projeto com:
```shell
dart run build_runner build
flutter run
```

Para testes:
```shell
flutter test
```
---

## Melhorias
- Testes para widgets, golden tests;
- Error handling na UI mais robusto;
- Separar `providers.dart` e mover fora de `./lib/shared/`;
- Timer em SplashScreen por motivos de branding;
- Cache melhor (expirar, integrar em API client, etc).