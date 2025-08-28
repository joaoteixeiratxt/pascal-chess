# Pascal Chess

## Visão Geral

Pascal Chess é um estudo de caso de desenvolvimento de um jogo de xadrez em **Object Pascal**. O projeto une uma aplicação desktop (Delphi/Lazarus) a um pequeno servidor HTTP escrito em Node.js, permitindo partidas online e armazenamento do estado do jogo.

## Estrutura do Projeto

```text
pascal-chess/
├── src/
│   ├── Board/           # Modelo: estado do tabuleiro e regras
│   ├── Controllers/     # Lógica de controle e comunicação
│   ├── Pieces/          # Implementação das peças e estratégias
│   ├── Views/           # Telas (VCL) da aplicação
│   ├── Server/          # Serviço HTTP e fachada Indy
│   └── Utils/           # Utilidades diversas
├── package.json         # Script para iniciar o servidor Node
└── README.md
```

## Padrões de Projeto Utilizados

### Arquitetura MVC
O código está organizado em camadas de **Model**, **View** e **Controller**. As classes de tabuleiro e peças ficam em `src/Board` e `src/Pieces` (Model), as telas VCL em `src/Views` (View) e a coordenação entre elas em `src/Controllers` (Controller).

```mermaid
flowchart LR
    View[Views] --> Controller[Controllers]
    Controller --> Model[Board & Pieces]
    Controller --> Server
```

### Builder – Construção do Tabuleiro
O tabuleiro gráfico é montado passo a passo através do *builder* `TBoardBuilder` e auxiliares (`TRowBuilder`, `TSquareBuilder`).

```mermaid
classDiagram
    class IBoardBuilder
    class TBoardBuilder
    class TRowBuilder
    class TSquareBuilder
    IBoardBuilder <|.. TBoardBuilder
    TBoardBuilder o--> TRowBuilder
    TBoardBuilder o--> TSquareBuilder
```

### Factory – Criação de Peças
A criação das peças é centralizada em `TPieceFactory`, que decide qual classe instanciar de acordo com o tipo solicitado.

```mermaid
classDiagram
    class TPieceFactory
    class IPiece
    class TPawn
    class TRook
    IPiece <|.. TPawn
    IPiece <|.. TRook
    TPieceFactory ..> IPiece : new()
```

### Strategy – Movimentos das Peças
Cada peça utiliza uma estratégia diferente para calcular movimentos válidos. A classe `TPieceBase` delega o cálculo para objetos que implementam `IStrategy` (ex.: `TPawnStrategy`).

```mermaid
classDiagram
    class IPiece
    class IStrategy
    class TPieceBase
    class TPawnStrategy
    IPiece <|.. TPieceBase
    IStrategy <|.. TPawnStrategy
    TPieceBase o--> IStrategy
```

### Observer – Atualização de Estado
A sala de jogo (`TRoom`) notifica observadores sempre que seu estado é alterado, permitindo que as views atualizem a interface em tempo real.

```mermaid
sequenceDiagram
    participant Service as TServerService
    participant Room as TRoom
    participant View as TBoardView
    Service->>Room: carrega estado
    Room->>View: NotifyAll()
```

### Facade – Cliente HTTP Indy
A unidade `PC.Indy.Facade` encapsula o uso da biblioteca Indy, expondo uma interface simples `IHttpClient` para o restante da aplicação.

### Singleton – Controlador de Sala
`TRoomController` mantém uma única instância da sala e do jogador atual por meio de variáveis de classe, funcionando como um *singleton* para acesso global.

## Como Usar

1. **Servidor HTTP**
   ```bash
   npm start
   ```
   O comando acima executa `src/Server/server.js`, responsável por persistir e recuperar o estado das salas.

2. **Aplicação Pascal**
   - Abra o projeto `src/PascalChess.dpr` em Delphi ou Lazarus.
   - Compile e execute. A aplicação irá consumir o servidor acima para listar salas, criar partidas e jogar.

## Diagramas Extras

Diagrama simplificado do fluxo principal de uma partida:

```mermaid
sequenceDiagram
    Player->>Controller: cria ou entra na sala
    Controller->>Server: POST /rooms
    Controller->>Room: atualiza estado
    Room->>View: notifica alterações
    Player->>View: interage (movimentos)
    View->>Controller: solicita validação
    Controller->>Room: atualiza estado e sincroniza
```

## Licença
Distribuído sob a licença MIT. Consulte o arquivo `LICENSE` para mais detalhes.
