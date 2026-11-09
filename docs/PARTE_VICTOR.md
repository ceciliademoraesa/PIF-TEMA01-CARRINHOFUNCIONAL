> Atualização de integração: a divergência histórica descrita abaixo foi corrigida em Pedido.hs e TestesLuiza.hs. O retorno atual é (220,15,213). Os relatos abaixo preservam o registro da revisão original de Victor.

# Parte de Victor: calcularFrete

## Regra e implementacao

`Frete.hs` exporta `calcularFrete :: Double -> Double`. A entrada e o valor
da compra **depois do desconto**; a saida e somente o valor do frete.
As guardas escolhem R$ 15 quando `valor < 200` e R$ 0 nos demais casos.
Assim, exatamente R$ 200 ja tem frete gratis.

A funcao e pura: depende apenas do argumento, nao modifica estado e nao
imprime nada. Os efeitos de impressao dos testes ficam somente no `main`.
Zero tambem paga R$ 15. Valores negativos estao fora do dominio usual de
compras, mas seguem a comparacao e retornam 15; nao foi inventada validacao.
O contrato pressupoe valores monetarios finitos. `Double` tem precisao
limitada; a funcao nao arredonda o valor antes de compara-lo com 200.

## Executar

Na raiz do repositorio, com GHC instalado:

```sh
runghc TestesVictor.hs
ghc -Wall -Werror TestesVictor.hs -o testes-victor
ghci Frete.hs
```

No Windows, use `-o testes-victor.exe` e execute `.\testes-victor.exe`.
No Linux/macOS, execute `./testes-victor`.
Os 12 testes cobrem o exemplo, zero, negativo, centavos, o limite e a
composicao com o cupom real de `Cupom.hs`. Uma falha termina com codigo
diferente de zero. Resultado esperado: `12 de 12 testes aprovados.`

No GHCi:

```haskell
:t calcularFrete
calcularFrete 150
calcularFrete 199.99
calcularFrete 200
calcularFrete 200.01
198 + calcularFrete 198 == 198 + 15
```

Saidas esperadas: `Double -> Double`, `15.0`, `15.0`, `0.0`, `0.0`, `True`.
A ultima expressao ilustra transparencia referencial: substituir a chamada
por seu resultado preserva o valor da expressao.

## Validacao realizada

Em 09/11/2026, com GHC 9.6.7: compilacao de `TestesVictor.hs` com
`-Wall -Werror` sem avisos e 12/12 testes aprovados. `TestesLuiza.hs` tambem
compilou com essas opcoes e passou nos 13 testes existentes. Esses testes
preservam a expectativa atual do subtotal com desconto; portanto, nao
resolvem a divergencia com o enunciado descrita abaixo.

## Fala sugerida

"Minha funcao recebe o valor da compra depois do desconto e calcula somente
o frete. Usei guardas para expressar as duas possibilidades: abaixo de 200,
o frete custa 15; a partir de 200, e gratis. Ela e pura porque nao altera
nenhuma variavel externa e nao faz entrada ou saida. Os testes conferem
principalmente 199,99, 200 e 200,01 para verificar a fronteira da regra.
Uma compra de 220 com desconto de 10% fica em 198 e passa a pagar frete."

## Observacao para a integracao

O `Pedido.hs` atual ja importa `Frete` e calcula o frete sobre o valor com
desconto. Esta contribuicao fornece esse modulo que estava faltando.
Ha uma divergencia anterior, fora da funcao de Victor: o primeiro elemento
retornado por `resumoPedido` atualmente e o subtotal com desconto. O PDF,
Tema 01, pagina 9, pede o subtotal original: no exemplo de 220 com 10%, a
tupla esperada e `(220, 15, 213)`, enquanto o codigo atual devolve
`(198, 15, 213)`. A equipe deve ajustar `Pedido.hs` e os testes correspondentes
na integracao final. A parte de Victor nao modifica esses arquivos.

## Referencia e apoio

Enunciado: Roni Maciel, *Seminario Tecnico: Programacao Funcional com Haskell*,
CESAR School, 2026.2, Tema 01, paginas 8 e 9.
Preparacao do codigo, dos testes e deste roteiro com apoio do OpenAI Codex.
Revisar e praticar os exemplos antes da apresentacao.
