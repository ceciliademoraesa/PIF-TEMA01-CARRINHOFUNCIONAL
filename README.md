# Carrinho Funcional em Haskell

**Tema 01 — Funções puras em um carrinho de compras**  
Programação Imperativa e Funcional — CESAR School, 2026.2.

## Estado do projeto

As cinco funções obrigatórias e a extensão estão integradas. `Aplicacao.hs` executa o carrinho completo; `Exemplo1.hs` mostra pureza e substituição de uma chamada pelo seu valor. As funções de cálculo são puras e apenas o `main` de cada executável realiza impressão.

O resumo retorna **(subtotal original, frete, total final)**. O frete é calculado depois do desconto. No exemplo de R$ 220 com cupom de 10%, o resultado correto é **(220,15,213)**.

## Equipe e contribuições

| Integrante | Implementação | Materiais e apresentação planejada |
|---|---|---|
| Cecília de Moraes Andrade Oliveira | `subtotalItem`, `totalCarrinho`, `cupomCondicional`, exemplos e integração | Comparação com C, introdução e coordenação |
| Lívia (completar nome) | `aplicarCupom` e testes | Investigação, referências e síntese |
| Victor Bacelar Palazzin | `calcularFrete` e testes | Frete, limitações e consolidação dos slides |
| Luiza (completar nome) | `resumoPedido` e testes | Demonstração do pedido e interação |

A revisão de integração corrige o subtotal devolvido por `resumoPedido` e atualiza os testes, preservando os módulos e o histórico das contribuições. Cada integrante deve fazer commits com a própria conta, compreender o código e apresentar. Confirmar nomes completos e participação efetiva antes da entrega.

## Arquivos

- `CarrinhoBase.hs`: item, subtotal, soma recursiva e extensão.
- `Cupom.hs`, `Frete.hs`, `Pedido.hs`: desconto, frete e resumo integrado.
- `Exemplo1.hs`: primeiro exemplo executável, conceitual.
- `Aplicacao.hs`: segundo exemplo executável, aplicação completa.
- `Cecilia.hs`: demonstração complementar da base.
- `AplicarCupom.hs`: seis testes da função importada de `Cupom.hs`.
- `TestesCecilia.hs`, `TestesVictor.hs`, `TestesLuiza.hs`: 19, 12 e 13 testes.
- `ComparacaoC.c`: comparação entre estado global e cálculo puro.
- `SINTESE.md`, `docs/` e `experimentos/`: pesquisa, roteiros e evidências.

## Executar

Requisitos: GHC/GHCi e, para a comparação em C, GCC. Não há dependências externas Haskell. Os testes usam também módulos da biblioteca padrão (`Control.Monad` e `System.Exit`). Execute os comandos na raiz do repositório, mantendo os módulos juntos.

```sh
runghc Exemplo1.hs
runghc Aplicacao.hs
```

Para compilar os dois programas principais, separadamente:

```sh
ghc -Wall -Werror Exemplo1.hs -o exemplo1
ghc -Wall -Werror Aplicacao.hs -o carrinho
./exemplo1
./carrinho
```

No Windows/PowerShell, usar `-o exemplo1.exe` e `-o carrinho.exe`, executando `.\exemplo1.exe` e `.\carrinho.exe`. Não compilar vários arquivos que possuem `main` no mesmo comando.

## Rodar os testes

```sh
runghc TestesCecilia.hs
runghc AplicarCupom.hs
runghc TestesVictor.hs
runghc TestesLuiza.hs
```

As quatro suítes verificam **50 casos** e retornam erro se um teste falhar. Cobrem lista vazia, vários itens, descontos de 0% e 100%, limites do frete e da extensão e a preservação do subtotal original. Os resultados da revisão estão em `experimentos/verificacao-integracao.txt`.

No GHCi:

```sh
ghci Pedido.hs
```

```haskell
resumoPedido [("Caderno",25,4),("Mochila",120,1)] 10
-- (220.0,15.0,213.0)
resumoPedido [("Produto",250,1)] 20
-- (250.0,0.0,200.0)
resumoPedido [] 0
-- (0.0,15.0,15.0)
:q
```

## Comparação com C

```sh
gcc -std=c11 -Wall -Wextra -Werror -pedantic ComparacaoC.c -o comparacao
./comparacao
```

No PowerShell, gerar `comparacao.exe` e executar `.\comparacao.exe`. O acumulador global retorna 220 e depois 440 com os mesmos itens; a função pura retorna 220. C também permite funções puras: o contraste é o uso de estado externo.

## Regras e extensão

`totalCarrinho` usa recursão, sem `sum` ou `map`. O frete custa R$ 15 abaixo de R$ 200, considerando o valor já descontado, e zero a partir desse limite.

`cupomCondicional percentual minimo subtotal` verifica o mínimo **antes** de aplicar o desconto e retorna o valor sem frete. Exemplos com 10% e mínimo 200: 199 permanece 199; 200 vira 180; 220 vira 198. A extensão é demonstrada separadamente e não altera a regra obrigatória de `resumoPedido`.

## Limitações e entrega

Double tem precisão limitada; testes decimais usam tolerância. O domínio esperado tem preços e quantidades não negativos e percentual de 0 a 100. Não há validação adicional. Pela regra literal, um carrinho vazio paga R$ 15 de frete.

A compilação e os testes verificam o código, não garantem a nota. Antes da entrega, completar os nomes, revisar a síntese para 2 a 4 páginas, finalizar slides com contribuições, ensaiar de 15 a 20 minutos e preparar duas perguntas e uma atividade. Todos devem conseguir explicar e modificar o código. Conferir prazos e registros individuais de commits. O representante anexa slides e link no Classroom; os demais também entregam e identificam o representante.

## Referências e apoio

- MACIEL, Roni. *Seminário Técnico: Programação Funcional com Haskell*. CESAR School, 2026.2, Tema 01.
- [Haskell 2010 Language Report](https://www.haskell.org/onlinereport/haskell2010/haskellch6.html).
- Demais fontes em `SINTESE.md`.
- Apoio do ChatGPT na preparação e revisão de código, testes e documentação. A equipe deve revisar, repetir os experimentos e declarar esse apoio na síntese.
