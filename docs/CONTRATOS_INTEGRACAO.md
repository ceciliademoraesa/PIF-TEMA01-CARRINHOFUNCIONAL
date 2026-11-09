# Contratos para a integracao

Todos os modulos ficam na raiz do repositorio. Nao usar `main` dentro dos modulos de calculo.

```haskell
-- ja existe em CarrinhoBase.hs
type Item = (String, Double, Int)
subtotalItem :: Item -> Double
totalCarrinho :: [Item] -> Double
cupomCondicional :: Double -> Double -> Double -> Double

-- Livia: Cupom.hs, modulo Cupom
aplicarCupom :: Double -> Double -> Double
-- aplicarCupom percentual valor

-- Victor: Frete.hs, modulo Frete
calcularFrete :: Double -> Double
-- R$ 15 se valor < 200; R$ 0 caso contrario

-- Luiza: Pedido.hs, modulo Pedido
resumoPedido :: [Item] -> Double -> (Double, Double, Double)
-- recebe itens e percentual de cupom, devolve (subtotal original, frete, total)
-- integra totalCarrinho, aplicarCupom e calcularFrete.
```

Exemplos: aplicarCupom 10 100 = 90; calcularFrete 199 = 15; calcularFrete 200 = 0. No resumo, o frete considera o subtotal apos desconto. Os colegas podem adaptar os contratos juntos antes da integracao, mas devem atualizar este documento e imports em conjunto.

Exemplo obrigatório integrado: resumoPedido [("Caderno",25,4),("Mochila",120,1)] 10 = (220,15,213). O subtotal retornado não perde o desconto; apenas permanece como o valor original para consulta.
