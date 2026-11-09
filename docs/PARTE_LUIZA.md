# Parte de Luiza — Resumo do pedido em Haskell

## 1. O que fiz?

Minha responsabilidade no projeto **Carrinho Funcional** é implementar a função `resumoPedido`, no arquivo `Pedido.hs`. Ela reúne os cálculos de três etapas: soma dos itens, aplicação do cupom e cálculo do frete. No fim, devolve os valores que formam o pedido.

Não alterei o trabalho da Cecília, da Lívia ou do Victor. A função **reutiliza** os módulos dos colegas, em vez de duplicar as regras deles.

## 2. Contrato oficial e parâmetros

O pedido inicial mencionava `Double -> Double -> Double -> (Double, Double, Double)`, com percentual, subtotal original e frete. Mas o contrato do grupo, em `docs/CONTRATOS_INTEGRACAO.md`, define:

```haskell
resumoPedido :: [Item] -> Double -> (Double, Double, Double)
```

Por isso, segui **o contrato oficial**. A função recebe:

1. `itens`: lista de produtos. Cada `Item` é uma tupla `(nome, precoUnitario, quantidade)`, criada em `CarrinhoBase.hs`.
2. `percentual`: percentual do cupom, como `10` para 10%.

O resultado é a tupla `(subtotalOriginal, frete, totalFinal)`.

**Importante:** no contrato, a palavra *subtotal* do resultado significa **subtotal original, antes do desconto**. O frete e o total final usam o valor descontado.

## 3. Meu código explicado

```haskell
module Pedido (resumoPedido) where

import CarrinhoBase (Item, totalCarrinho)
import Cupom (aplicarCupom)
import Frete (calcularFrete)

resumoPedido :: [Item] -> Double -> (Double, Double, Double)
resumoPedido itens percentual = (subtotalOriginal, frete, totalFinal)
  where
    subtotalOriginal = totalCarrinho itens
    subtotalComDesconto = aplicarCupom percentual subtotalOriginal
    frete = calcularFrete subtotalComDesconto
    totalFinal = subtotalComDesconto + frete
```

- `module Pedido (resumoPedido) where`: declara o módulo e exporta a função.
- `import`: usa as funções dos colegas. **Não** reimplementa o cupom ou o frete.
- `::`: apresenta os tipos dos parâmetros e do retorno.
- `where`: dá nomes a valores intermediários, sem precisar alterar variáveis.
- `totalCarrinho itens`: soma preço × quantidade de cada produto.
- `aplicarCupom percentual subtotalOriginal`: aplica o desconto.
- `calcularFrete subtotalComDesconto`: calcula frete **depois do desconto**.
- `totalFinal = subtotalComDesconto + frete`: calcula o valor final.

## 4. O que é uma tupla?

Uma tupla é uma forma de agrupar valores em posições fixas. Aqui ela tem três números `Double`:

```haskell
(200.0, 15.0, 195.0)
```

Isso significa: **R$ 200 de subtotal original**, **R$ 15 de frete** e **R$ 195 de total final**. Podemos separar os valores assim:

```haskell
let (subtotal, frete, total) = resumoPedido [("Produto", 200, 1)] 10
```

Diferente de uma lista, a tupla pode reunir tipos diferentes, embora neste projeto os três valores sejam `Double`.

## 5. Por que é uma função pura?

Porque os resultados dependem somente dos argumentos e do comportamento das funções puras importadas. Ela não lê teclado, não imprime na tela e não modifica dados externos. Para os mesmos itens e o mesmo percentual, devolve sempre o mesmo resultado.

`Pedido.hs` **não usa** `IO`, `print` ou `putStrLn`. O arquivo de testes usa `IO` somente para mostrar o resultado das verificações; isso não torna a função `resumoPedido` impura.

## 6. Exemplos para executar no GHCi

Os módulos `CarrinhoBase.hs`, `Cupom.hs`, `Frete.hs` e `Pedido.hs` devem estar na mesma pasta, com as funções e assinaturas previstas no contrato.

```sh
ghci Pedido.hs
```

Dentro do GHCi:

```haskell
resumoPedido [("Livro", 100, 1)] 0
-- (100.0,15.0,115.0)

resumoPedido [("Produto", 200, 1)] 10
-- (200.0,15.0,195.0)

resumoPedido [("Produto", 250, 1)] 20
-- (250.0,0.0,200.0)

resumoPedido [] 0
-- (0.0,15.0,15.0)

resumoPedido [("Caderno", 25, 4), ("Mochila", 120, 1)] 10
-- (220.0,15.0,213.0)
```

Esses são **resultados esperados** pelas regras do contrato (a representação decimal de `Double` pode variar). O contrato define frete de R$ 15 **mesmo para valor zero**; esta regra pode parecer diferente de lojas reais, mas foi mantida para respeitar o projeto.

## 7. Atenção ao limite de R$ 200

O valor considerado pelo frete é **o valor depois do desconto**:

| Valor antes | Cupom | Depois do desconto | Frete | Final |
| ---: | ---: | ---: | ---: | ---: |
| R$ 199,99 | 0% | R$ 199,99 | R$ 15,00 | R$ 214,99 |
| R$ 200,00 | 0% | R$ 200,00 | R$ 0,00 | R$ 200,00 |
| R$ 200,00 | 10% | R$ 180,00 | R$ 15,00 | R$ 195,00 |
| R$ 250,00 | 20% | R$ 200,00 | R$ 0,00 | R$ 200,00 |

Ou seja: **um carrinho de R$ 200 pode perder o frete grátis depois de receber 10% de desconto**.

## 8. Roteiro de fala para o professor

> Minha função é `resumoPedido`. Ela recebe uma lista de itens e a porcentagem de desconto. Primeiro, utiliza a função da Cecília para calcular o subtotal original. Depois, usa a função da Lívia para aplicar o cupom. Com esse novo valor, chama a função do Victor para descobrir o frete, que é grátis a partir de duzentos reais. Por fim, soma o valor com desconto ao frete e retorna uma tupla com o subtotal original, o frete e o total final. É uma função pura porque não muda nenhuma variável externa e nem faz entrada e saída; os cálculos são feitos por meio de funções puras e valores imutáveis.

### Se o professor perguntar...

**Por que não recebo o frete pronto?** Porque o contrato de integração exige que minha função invoque `calcularFrete` depois do cupom. Receber o frete pronto poderia gerar um valor incoerente com o desconto.

**Por que usar `where`?** Para nomear etapas do cálculo e tornar o código mais fácil de entender, sem atribuições mutáveis.

**Por que importar os módulos?** Para reaproveitar o código dos integrantes e manter uma única definição de cada regra.

**E números decimais?** O tipo `Double` pode ter pequenas imprecisões; por isso, meus testes comparam resultados usando tolerância.

## 9. Testes e integração

O arquivo `TestesLuiza.hs` contém **13 cenários**: sem desconto, com desconto, com frete, frete grátis, carrinho vazio, subtotal zero, valores próximos de R$ 200, desconto que muda o frete, vários itens e conferência do total. Para executar com os módulos integrados:

```sh
runghc TestesLuiza.hs
```

Se algum caso falhar, o programa mostra o esperado e o obtido e encerra com código de erro. Os testes usam os módulos reais integrados. A correção de integração preserva o subtotal original na primeira posição, conforme o enunciado.
