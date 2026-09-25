# O Explorador de Ecos

> **Projeto de Iniciação Científica — UFF (GPINFEE)** > **Aluno:** Samuel Taichi  
> **Orientadora:** Georgia Regina  

Desenvolvimento de um ambiente RPG imersivo para estimulação da consciência fonológica em crianças com distúrbios de aprendizagem (como TDAH e DEPAQ), utilizando o motor gráfico **Godot Engine 4**.

---

## 📋 Sobre o Projeto

Este artefato tecnológico adota a metodologia de **Game-Based Learning (GBL)**. O objetivo principal é transformar o treino fonoaudiológico tradicional em uma experiência lúdica e imersiva. A mecânica core baseia-se na **decodificação de grafemas e fonemas**, integrando desafios linguísticos diretamente na exploração e combate do jogo (abordagem *Zelda-like*).

### 🛠️ Arquitetura do Software

O software foi concebido sob princípios rigorosos de Engenharia de Software para garantir modularidade e escalabilidade:
- **Design Modular:** Cada elemento (Player, Inimigos, Puzzles) funciona como uma cena autocontida e encapsulada.
- **Instanciamento Dinâmico:** O cenário utiliza o sistema de `TileMapLayer` funcionando como um "tabuleiro" onde os elementos pedagógicos são posicionados dinamicamente.
- **Otimização:** Uso de manipulação de dados em grade (*Grids*) em tempo real via script (`set_cell`) para economizar memória em computadores mais simples.
- **Game Juice:** Implementação de feedbacks sensoriais rápidos (*Screen Shake*, partículas e iluminação dinâmica) calibrados para manter o foco atencional do público-alvo.

---

## 🚀 Como Executar o Projeto

Para abrir, testar ou expandir este projeto de pesquisa, siga as instruções abaixo:

1. Faça o download e instale a **Godot Engine v4.x** (disponível em [godotengine.org](https://godotengine.org)).
2. Faça o clone deste repositório:
   ```bash
   git clone [https://github.com/Taichi-Hatano-code/O-Explorador-de-Ecos.git](https://github.com/Taichi-Hatano-code/O-Explorador-de-Ecos.git)
