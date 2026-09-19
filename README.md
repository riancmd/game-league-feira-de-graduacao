# Feira de Grad — Liga de Jogos da UEFS

Jogo desenvolvido para apresentar a Liga de Jogos aos estudantes do ensino médio
durante a Feira de Graduação da Universidade Estadual de Feira de Santana (UEFS).

O jogador percorre ambientes inspirados nas diferentes etapas e áreas da criação de
jogos, conversa com personagens e enfrenta desafios.

## Requisitos

- Godot Engine **4.4.1**.
- Renderizador de compatibilidade OpenGL.
- Windows, Linux ou outro sistema suportado pelo Godot para executar pelo editor.

## Como executar

1. Abra o Godot 4.4.1.
2. Importe o arquivo `project.godot`.
3. Aguarde a importação dos recursos e a ativação do Dialogic.
4. Pressione **F6** para testar a cena atual ou **F5** para iniciar pelo menu.

## Controles

| Ação | Teclado e mouse | Controle |
| --- | --- | --- |
| Mover | `A`/`D` ou setas | Analógico esquerdo ou direcional |
| Pular | `W` ou `Espaço` | Botão inferior |
| Atacar | Botão esquerdo do mouse | `X`/quadrado |
| Interagir/avançar diálogo | `W`, `S`, setas ou `Espaço` | `A`/xis |
| Voltar ao menu | `Esc` | — |

## Percurso do jogo

1. Entrada e apresentação.
2. Creative Studio e o Bloqueio Criativo.
3. Pixelarium e o desafio de ritmo.
4. LabProg e os bugs.
5. Hall da Fama e encerramento.

## Organização do projeto

```text
assets/                  Recursos visuais
sounds/                  Música, vozes e efeitos sonoros
TimeLines/               Diálogos do Dialogic
resources/
  enemies/               Dados configuráveis dos inimigos
  student/               Configuração de movimento do jogador
scenes/
  components/            Componentes reutilizáveis
	combat/              Vida, hitbox, hurtbox e knockback
	input/               Buffers de ações
	movement/            Movimentação do jogador e inimigos
  rooms/components/      Fluxo e portões compartilhados pelas salas
  enemies/               Inimigos, chefes e projéteis
  student/StateMachine/  Estados do jogador
docs/                    Checklist de validação manual
```

### Arquitetura

- `RoomController` controla entrada, diálogo, conclusão e apresentação das salas.
- `RoomGate` abre e fecha somente a barreira associada à progressão.
- `EnemyBase` centraliza vida, dano e ciclo de morte dos inimigos.
- `EnemyDefinition` mantém atributos de inimigos fora dos scripts e cenas.
- Os movimentos terrestre e flutuante são componentes independentes.
- O jogador utiliza uma máquina de estados tipada e componentes para movimento,
  buffers de entrada e knockback.
- `SfxManager` centraliza os efeitos sonoros compartilhados.
