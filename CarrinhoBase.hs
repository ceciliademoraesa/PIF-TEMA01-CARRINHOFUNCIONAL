module CarrinhoBase (Item, subtotalItem, totalCarrinho, cupomCondicional) where

type Item = (String, Double, Int)

-- Recebe (nome, preco unitario, quantidade).
subtotalItem :: Item -> Double
subtotalItem (_, preco, quantidade) = preco * fromIntegral quantidade

-- Soma os subtotais por recursao, sem estado mutavel.
totalCarrinho :: [Item] -> Double
totalCarrinho [] = 0
totalCarrinho (item : restantes) = subtotalItem item + totalCarrinho restantes

-- O minimo e verificado antes do desconto.
cupomCondicional :: Double -> Double -> Double -> Double
cupomCondicional percentual minimo subtotal
  | subtotal < minimo = subtotal
  | otherwise = subtotal * (1 - percentual / 100)
