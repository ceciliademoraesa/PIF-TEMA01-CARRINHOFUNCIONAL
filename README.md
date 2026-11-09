# Carrinho Funcional em Haskell

**Tema 01 — Funções puras em um carrinho de compras**  
Programação Imperativa e Funcional — CESAR School, 2026.2  
Equipe: **Carrinho Funcional**

O projeto usa um carrinho de compras para estudar funções puras, transparência referencial, tuplas, recursão e separação entre cálculos e entrada/saída.

## Estado atual

### Contribuição de Victor nesta branch

`Frete.hs` implementa `calcularFrete`, conforme o contrato de integração.
Execute `runghc TestesVictor.hs` para conferir os 12 testes, incluindo os
limites de R$ 200 e a composição com `Cupom.hs`. O roteiro e os comandos de
compilação estão em [docs/PARTE_VICTOR.md](docs/PARTE_VICTOR.md), que também
registra uma divergência preexistente em `resumoPedido` para a integração.
As seções abaixo preservam o planejamento original da equipe.

A parte de Cecília foi reconstruída, com testes preparados para execução: `subtotalItem`, `totalCarrinho`, extensão `cupomCondicional`, exemplo conceitual, demonstração parcial, testes e comparação em C. As outras três funções obrigatórias ainda serão implementadas pelos responsáveis abaixo. Portanto, a aplicação completa e a síntese final da equipe ainda não estão concluídas.

Este pacote foi organizado para envio manual em uma branch. As contribuições dos colegas ainda não estão incluídas.

## Equipe e nova divisão

| Integrante | Código sob responsabilidade | Outras tarefas |
|---|---|---|
| Cecília de Moraes Andrade Oliveira | `subtotalItem`, `totalCarrinho`, `cupomCondicional`, `Exemplo1.hs`, demonstração, testes da base e integração final do `main` | README, comparação em C, coordenação e entrega |
| Lívia — nome completo a confirmar | `aplicarCupom` em `Cupom.hs`, com testes próprios | Desafio investigativo, fontes e organização da síntese |
| Victor — nome completo a confirmar | `calcularFrete` em `Frete.hs`, com testes próprios | Consolidação dos slides e quadro de contribuições efetivas |
| Luiza — nome completo a confirmar | `resumoPedido` em `Pedido.hs`, com testes próprios | Duas perguntas, atividade de interação e conferência dos cenários completos |

Cada integrante deve implementar e testar sua função, apresentar uma parte e fazer commits com a própria conta antes do prazo. As atribuições são planejamento, não comprovação de trabalho já realizado. Atualizar os nomes e o quadro de contribuições antes da entrega.

## Arquivos já disponíveis

| Arquivo | Finalidade |
|---|---|
| `CarrinhoBase.hs` | Módulo puro com as três funções de Cecília |
| `Exemplo1.hs` | Exemplo conceitual executável de pureza e transparência referencial |
| `Cecilia.hs` | Demonstração executável da parte de Cecília, ainda sem frete nem resumo final |
| `TestesCecilia.hs` | Dezenove testes automáticos das funções da base |
| `ComparacaoC.c` | Comparação com uma função dependente de estado global |
| `docs/DIVISAO_TAREFAS.md` | Tarefas por pessoa, roteiro e sequência sugerida de commits |
| `docs/PARTE_CECILIA.md` | Explicação do código, fala e contribuição para a síntese |
| `docs/CONTRATOS_INTEGRACAO.md` | Assinaturas, módulos e comportamentos a seguir |
| `docs/Aplicacao_planejada.hs.txt` | `main` final preparado para quando os módulos dos colegas estiverem prontos |

## Requisitos e execução

É necessário ter GHC/GHCi instalado. O código Haskell utiliza somente Prelude e os módulos locais do projeto, sem bibliotecas externas. GCC é necessário apenas para executar a comparação em C.

Execute os comandos na pasta que contém este README.

### Sem gerar executáveis

```sh
runghc Exemplo1.hs
runghc Cecilia.hs
runghc TestesCecilia.hs
```

### No GHCi

```sh
ghci CarrinhoBase.hs
```

```haskell
:t totalCarrinho
subtotalItem ("Caneta", 3.5, 10)
totalCarrinho []
totalCarrinho [("Caderno", 25, 4), ("Mochila", 120, 1)]
cupomCondicional 10 200 220
:q
```

Resultados numéricos esperados: `35.0`, `0.0`, `220.0` e `198.0`.

### Compilar cada programa separadamente

```sh
ghc -Wall -Werror Exemplo1.hs -o exemplo1
ghc -Wall -Werror Cecilia.hs -o cecilia
ghc -Wall -Werror TestesCecilia.hs -o testes
```

Linux/macOS: `./exemplo1`, `./cecilia` e `./testes`.  
Windows/PowerShell: usar nomes de saída com `.exe`, por exemplo `-o cecilia.exe`, e executar `.\cecilia.exe`.

Não compilar os três arquivos executáveis juntos: cada um tem seu próprio `main`. `CarrinhoBase.hs` é o módulo compartilhado e deve permanecer junto deles.

### Comparação com C

```sh
gcc -std=c11 -Wall -Wextra -Werror -pedantic ComparacaoC.c -o comparacao
./comparacao
```

No Windows, gerar `comparacao.exe` e executar `.\comparacao.exe`.

A primeira chamada da função que acumula em variável global retorna `220.00`; a segunda, com os mesmos argumentos, retorna `440.00`. O exemplo também contém uma função pura em C. O objetivo é comparar o uso de estado, não afirmar que toda função em C é impura.

## Regras e extensão

- `subtotalItem` calcula preço unitário × quantidade.
- `totalCarrinho` usa recursão, com `[]` como caso base, sem `sum`, `map` ou `fold` na implementação.
- `aplicarCupom` será implementada por Lívia: percentual e valor, nessa ordem.
- `calcularFrete` será implementada por Victor: R$ 15 para valor abaixo de R$ 200; zero a partir de R$ 200.
- `resumoPedido` será implementada por Luiza: devolve `(subtotal, frete, total)`; o frete considera o valor depois do desconto.
- As funções de cálculo são puras. Somente `main` imprime resultados em cada programa.

Extensão de Cecília:

```haskell
cupomCondicional :: Double -> Double -> Double -> Double
```

Recebe **percentual, mínimo de compra e subtotal**. O mínimo é verificado antes do desconto. Com 10% e mínimo de R$ 200: subtotal 199 continua 199; subtotal 200 passa a 180; subtotal 220 passa a 198. O resultado ainda não inclui frete. A extensão é uma demonstração separada e não altera o comportamento obrigatório de `resumoPedido`.

## Verificação

`TestesCecilia.hs` contém 19 verificações automáticas. Este pacote foi reconstruído a partir do planejamento e do README recuperado; os arquivos Haskell precisam ser executados novamente em um computador com GHC antes da apresentação. O programa C foi recompilado nesta preparação. As funções dos colegas e a integração final não foram testadas.

## Integração final

Depois dos commits dos colegas, devem existir `Cupom.hs`, `Frete.hs` e `Pedido.hs`, conforme `docs/CONTRATOS_INTEGRACAO.md`. Cecília então transforma `docs/Aplicacao_planejada.hs.txt` em `Aplicacao.hs`, confere os imports, executa os testes integrados e registra a integração em seu próprio commit.

Somente nessa etapa os comandos abaixo ficam disponíveis:

```sh
ghc -Wall Aplicacao.hs -o carrinho
runghc Aplicacao.hs
```

Manter os módulos `.hs` juntos no repositório. `Aplicacao.hs` os importa; todos os arquivos envolvidos fazem parte da aplicação entregue.

## Limitações

O exercício usa `Double`, que representa números com precisão limitada. Os testes com decimais usam tolerância. Preços e quantidades devem ser não negativos; percentuais devem estar entre 0 e 100. O código não valida entradas fora desse domínio. A regra de frete do tema também cobra R$ 15 quando o valor é zero. Não alterar essas regras silenciosamente durante a integração.

## Entrega da equipe

Ainda faltam as funções e testes dos colegas, a integração, a síntese de 2 a 4 páginas com referências e contribuições reais e os slides completos com nomes completos. O representante entrega slides e link do repositório; todos também concluem a atividade no Classroom e identificam o representante. Confirmar as datas no Classroom. Commits depois do prazo não entram na correção.

## Referências e ferramentas de apoio

- MACIEL, Roni. *Seminário Técnico: Programação Funcional com Haskell*. CESAR School, 2026.2. Tema 01 e regras da atividade.
- [Haskell 2010 Language Report — tipos e classes](https://www.haskell.org/onlinereport/haskell2010/haskellch6.html).
- OpenAI, ChatGPT: apoio à preparação dos exemplos, documentação e testes. Revisar e adaptar o material e registrar o uso na síntese; todos devem conseguir explicar e modificar o código.
