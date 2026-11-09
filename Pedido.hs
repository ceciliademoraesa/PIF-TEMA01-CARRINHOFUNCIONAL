module Pedido (resumoPedido) where

import CarrinhoBase (Item, totalCarrinho)
import Cupom (aplicarCupom)
import Frete (calcularFrete)

-- Recebe os itens do carrinho e o percentual de desconto.
-- Retorna (subtotal apos desconto, frete, total final).
resumoPedido :: [Item] -> Double -> (Double, Double, Double)
resumoPedido itens percentual = (subtotalComDesconto, frete, totalFinal)
  where
    subtotalOriginal = totalCarrinho itens
    subtotalComDesconto = aplicarCupom percentual subtotalOriginal
    frete = calcularFrete subtotalComDesconto
    totalFinal = subtotalComDesconto + frete
