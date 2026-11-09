# Síntese das descobertas

**Tema 01: Funções puras em um carrinho de compras**
**Equipe:** Carrinho Funcional (Cecília, Lívia, Victor e Luiza)

> Organização desta síntese: Lívia. As seções 1, 2, 3 e 7 foram montadas por ela, com os experimentos e as descobertas enviados pelo grupo. Os trechos marcados com **[a preencher]** são das outras pessoas, conforme a divisão do grupo.

---

## 1. Conceito

Uma **função pura** é aquela cujo resultado depende só dos argumentos que recebe e que não muda nada fora dela: não altera variáveis globais, não lê o teclado, não imprime na tela. Chamar `aplicarCupom 10 220` sempre devolve `198.0`, hoje, amanhã ou dentro de qualquer expressão. Essa garantia se chama **transparência referencial**: qualquer chamada pode ser trocada pelo valor que ela calcula sem mudar o resultado do programa. Em Haskell, a pureza aparece no tipo. `aplicarCupom :: Double -> Double -> Double` promete só um cálculo. Já `getLine :: IO String` avisa que aquilo é uma **ação** que conversa com o mundo de fora, e o compilador não deixa misturar as duas coisas sem dizer. No carrinho, todas as regras de negócio (subtotal, cupom, frete, resumo) são puras, e só o `main` executa ações de entrada e saída.

---

## 2. Desafio investigativo

**Pergunta:** por que `getLine` tem tipo `IO String`, e o que acontece quando tentamos fazer entrada ou saída dentro de uma função declarada pura?

Todos os comandos foram executados no GHC 9.4.7. O registro completo está em `experimentos/desafio-ghci.txt`.

### 2.1 O tipo de `getLine`

```
ghci> :t getLine
getLine :: IO String
ghci> :t putStrLn
putStrLn :: String -> IO ()
ghci> :t aplicarCupom
aplicarCupom :: Double -> Double -> Double
```

`getLine` não é um texto. É uma ação que, quando executada, lê uma linha do teclado e produz uma `String`. Cada execução pode trazer um texto diferente, porque depende do que a pessoa digitar. Se o tipo fosse só `String`, uma chamada não poderia ser trocada pelo seu valor, e a transparência referencial quebraria. O `IO` marca essa diferença no próprio tipo. `aplicarCupom` não tem `IO` em lugar nenhum, então sabemos, só olhando o tipo, que ela não faz efeito colateral.

### 2.2 Tentando imprimir dentro de uma função pura

Experimento que falha de propósito (fica fora dos arquivos `.hs` finais, que precisam compilar):

```haskell
saudacao :: String -> String
saudacao nome = putStrLn ("Ola, " ++ nome)
```

Erro real do compilador:

```
ErroIO.hs:3:17: error:
    * Couldn't match type: IO ()
                     with: [Char]
      Expected: String
        Actual: IO ()
    * In the expression: putStrLn ("Ola, " ++ nome)
      In an equation for `saudacao':
          saudacao nome = putStrLn ("Ola, " ++ nome)
```

**Interpretação:** a assinatura promete devolver uma `String` (`[Char]`), mas `putStrLn` devolve `IO ()`, que é uma ação de imprimir e não um texto. O GHC recusa o programa **antes de rodar**. No código seguro e nos recursos utilizados neste trabalho, uma impressão é representada por `IO`; a assinatura pura apresentada não aceita essa ação.

O mesmo vale no sentido contrário, quando tentamos usar a entrada como se fosse um valor comum:

```
ghci> length getLine
<interactive>:1:1: error:
    * No instance for (Foldable IO) arising from a use of `length'
```

`length` espera uma lista, e `getLine` é uma ação, não o texto já lido.

### 2.3 A mesma ideia em C

O arquivo `ComparacaoC.c` acumula os subtotais em uma variável global. Na verificação de integração, a saída foi `Funcao com estado: 220.00 e 440.00` e `Funcao pura: 220.00`. A segunda chamada soma novamente ao valor anterior. Em Haskell, `totalCarrinho` devolve 220 nas duas avaliações do mesmo carrinho, sem atualizar um acumulador global. O código completo está no arquivo C e o registro em `experimentos/verificacao-integracao.txt`.

### 2.4 Conclusão do desafio

`getLine` tem tipo `IO String` porque o resultado vem de fora do programa e muda a cada execução. O `IO` separa no tipo o que é ação do que é cálculo. Por isso o compilador consegue garantir que funções como `aplicarCupom`, `subtotalItem` e `calcularFrete` são puras: quando tentamos colocar uma impressão dentro de uma delas, o programa nem compila. Em C, nada no tipo impede uma função de mexer em uma variável global, e o erro só aparece em execução (seção 2.3).

---

## 3. Descobertas com evidências

### Descoberta 1 (Lívia): trocar a chamada pelo valor não muda nada

```
ghci> aplicarCupom 10 220
198.0
ghci> aplicarCupom 10 220
198.0
ghci> aplicarCupom 10 220 + 15 == 198 + 15
True
ghci> let x = aplicarCupom 10 100 in x + x
180.0
ghci> aplicarCupom 10 100 + aplicarCupom 10 100
180.0
```

A mesma chamada sempre devolve o mesmo valor, e guardar o resultado num nome ou repetir a chamada dá o mesmo resultado. Isso é a transparência referencial na prática. É por isso que o grupo pode testar cada função sozinha e depois juntar tudo no `resumoPedido` com segurança.

### Descoberta 2 (Lívia): `Double` erra na última casa decimal

```
ghci> aplicarCupom 10 19.9
17.91
ghci> aplicarCupom 10 0.7
0.6299999999999999
```

O resultado certo seria 0,63. `Double` é ponto flutuante binário e não representa alguns decimais com exatidão. Por isso os testes de `aplicarCupom` comparam os valores com uma tolerância (`abs (a - b) < 1e-9`) em vez de `==`. Isso não tem a ver com pureza: a função continua devolvendo sempre o mesmo `0.6299999999999999`.

### Descoberta 3 (Lívia): um cupom aplicado pela metade já é uma função

```
ghci> :t aplicarCupom 10
aplicarCupom 10 :: Double -> Double
```

Passando só o percentual, sobra uma função que espera o valor. `aplicarCupom 10` é, literalmente, "o cupom de 10%", e pode ser guardado num nome e reaproveitado em vários carrinhos. Isso se chama aplicação parcial e explica por que a ordem dos parâmetros (percentual primeiro, valor depois) foi escolhida assim.

### Descoberta 4 (Victor): **[a preencher]**

Sugestão: o que aconteceu ao implementar `calcularFrete` exatamente no limite de R$ 200 (comando e saída real).

### Descoberta 5 (Luiza): **[a preencher]**

Sugestão: o caso do carrinho vazio em `resumoPedido`, que paga R$ 15 de frete seguindo a regra do tema (comando e saída real).

---

## 4. Comparação com a abordagem imperativa

A versão com estado global depende do histórico de chamadas, além dos argumentos. A versão pura calcula o total a partir da lista recebida, o que facilita testes isolados e reutilização. Isso não significa que toda função em C seja impura: a comparação inclui uma função em C sem atualização de estado externo.

---

## 5. Dificuldades e limitações

**[a preencher: Luiza reúne os relatos de todos]**

Contribuição da Lívia para esta seção:

- `aplicarCupom` aceita qualquer `Double` como percentual. Com valores fora de 0 a 100 o resultado perde o sentido: `aplicarCupom 150 100` devolve `-50.0` e `aplicarCupom (-10) 100` devolve `110.0`. O grupo decidiu documentar essa limitação em vez de mudar a regra obrigatória do tema em silêncio. Uma melhoria possível seria limitar o percentual com `max 0 (min 100 percentual)`.
- Os valores em `Double` podem ter erro de arredondamento (descoberta 2). Num sistema real de pagamento, o mais seguro seria trabalhar com centavos inteiros (`Int`) ou com um tipo decimal.

---

## 6. Quadro de contribuições

**[a preencher: Cecília]**

Linha da Lívia:

| Integrante | Código | Pesquisa e documentação | Apresentação |
| --- | --- | --- | --- |
| Lívia | `aplicarCupom` e seus testes (`AplicarCupom.hs`) | Desafio investigativo no GHCi, seções 1, 2, 3 e 7 da síntese, organização das descobertas e referências | Parte 2: investigação técnica (tipos, transparência referencial, IO e evidências do desafio) |

---

## 7. Referências

1. LIPOVAČA, Miran. *Learn You a Haskell for Great Good!*. Capítulo "Input and Output". Disponível em: https://learnyouahaskell.com/input-and-output.
2. HASKELLWIKI. *Referential transparency*. Disponível em: https://wiki.haskell.org/Referential_transparency.
3. HASKELLWIKI. *IO at work*. Disponível em: https://wiki.haskell.org/IO_at_work.
4. HUDAK, Paul; PETERSON, John; FASEL, Joseph. *A Gentle Introduction to Haskell*, seção "Input/Output". Disponível em: https://www.haskell.org/tutorial/io.html.
5. HACKAGE. *Prelude* (pacote `base`), documentação de `getLine` e `putStrLn`. Disponível em: https://hackage.haskell.org/package/base/docs/Prelude.html.
6. O'SULLIVAN, Bryan; GOERZEN, John; STEWART, Don. *Real World Haskell*, capítulo 7 "I/O". Disponível em: https://book.realworldhaskell.org/read/io.html.
7. Ferramenta: GHC 9.4.7 e GHCi, conforme registro original de Lívia; revisão de integração executada com GHC 9.0.2, identificada separadamente em `experimentos/verificacao-integracao.txt`.
8. ChatGPT: apoio à preparação e revisão de código, testes e documentação. A equipe deve revisar e reproduzir os experimentos antes da apresentação.

**[a preencher]** Fontes enviadas pelos outros integrantes, no mesmo formato.
