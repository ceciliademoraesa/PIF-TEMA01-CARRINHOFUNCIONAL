module Cupom (aplicarCupom) where

-- Funcao de desconto desenvolvida por Livia.
-- Recebe o percentual e o valor original.
-- Retorna o valor apos aplicar o desconto.

aplicarCupom :: Double -> Double -> Double
aplicarCupom percentual valor =
  valor - valor * percentual / 100
