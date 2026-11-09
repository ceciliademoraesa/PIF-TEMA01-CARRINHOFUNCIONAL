# Parte da Cecilia — explicacao para a apresentacao

- `subtotalItem (nome, preco, quantidade)` calcula preco multiplicado pela quantidade. O nome e informativo, nao muda o resultado.
- `totalCarrinho` percorre uma lista recursivamente. Caso base: lista vazia devolve 0. Caso recursivo: subtotal do primeiro item + total dos restantes.
- `cupomCondicional percentual minimo subtotal` usa guardas: se o subtotal nao alcancar o minimo, nao aplica desconto; caso contrario aplica o percentual.
- Sao funcoes puras: nao usam entrada/saida nem estado mutavel. A exibicao dos resultados fica em `main :: IO ()`.
- `Exemplo1.hs` executa as mesmas entradas mais de uma vez para ilustrar transparencia referencial.
- `ComparacaoC.c` contrasta uma funcao que acumula em variavel global com outra sem estado. A linguagem C tambem permite funcoes puras.

## Fala curta
"Nossa parte calcula o subtotal e o total usando funcoes puras. Com recursao, o carrinho vazio vale zero; com itens, somamos o primeiro ao restante. O cupom adicional so e aplicado quando o minimo e atingido. Em C, mostramos que depender de estado global pode produzir respostas diferentes para a mesma entrada."

## Como testar
`runghc TestesCecilia.hs`, depois `runghc Cecilia.hs` e `runghc Exemplo1.hs`.
