module Frete (calcularFrete) where

-- Parte de Victor: recebe o valor da compra ja com desconto.
-- Funcao pura: devolve apenas o frete, sem alterar o valor recebido.
-- Zero e valores negativos seguem literalmente a regra de valor < 200.
calcularFrete :: Double -> Double
calcularFrete valor
  | valor < 200 = 15
  | otherwise = 0
