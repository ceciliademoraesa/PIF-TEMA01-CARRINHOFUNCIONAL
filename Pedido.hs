module Pedido (resumoPedido) where

import CarrinhoBase (Item, totalCarrinho)
import Cupom (aplicarCupom)
import Frete (calcularFrete)

-- Recebe os itens do carrinho e o percentual de desconto.
-- Retorna (subtotal original, frete, total final).
resumoPedido :: [Item] -> Double -> (Double, Double, Double)
resumoPedido itens percentual = (subtotalOriginal, frete, totalFinal)
  where
    subtotalOriginal = totalCarrinho itens
    subtotalComDesconto = aplicarCupom percentual subtotalOriginal
    frete = calcularFrete subtotalComDesconto
    totalFinal = subtotalComDesconto + frete
