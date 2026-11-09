import CarrinhoBase (subtotalItem, totalCarrinho, cupomCondicional)
import Cupom (aplicarCupom)
import Frete (calcularFrete)
import Pedido (resumoPedido)

main :: IO ()
main = do
  let itens = [("Caderno", 25, 4), ("Mochila", 120, 1)]
  putStrLn "Itens: caderno de 25 x 4, mochila de 120 x 1"
  print itens
  putStrLn "Subtotal do caderno (esperado 100):"
  print (subtotalItem ("Caderno", 25, 4))
  putStrLn "Subtotal do carrinho (esperado 220):"
  print (totalCarrinho itens)
  putStrLn "Cupom de 10% (esperado 198):"
  print (aplicarCupom 10 (totalCarrinho itens))
  putStrLn "Frete apos desconto (esperado 15):"
  print (calcularFrete (aplicarCupom 10 (totalCarrinho itens)))
  putStrLn "Resumo: subtotal ORIGINAL, frete, total (esperado 220,15,213):"
  print (resumoPedido itens 10)
  putStrLn "Sem desconto (esperado 220,0,220):"
  print (resumoPedido itens 0)
  putStrLn "Carrinho vazio (regra literal: 0,15,15):"
  print (resumoPedido [] 0)
  putStrLn "Extensao separada: 10%, minimo 200, valores 199/200/220"
  putStrLn "Esperados: 199,180,198 (sem frete)"
  print (cupomCondicional 10 200 199, cupomCondicional 10 200 200,
         cupomCondicional 10 200 220)
