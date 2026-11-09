import CarrinhoBase (subtotalItem, totalCarrinho, cupomCondicional)

main :: IO ()
main = do
  let itens = [("Caderno", 25, 4), ("Mochila", 120, 1)]
      subtotal = totalCarrinho itens
  putStrLn "Demonstracao da parte de Cecilia (sem frete nem resumo final)"
  putStrLn "Subtotal de um item:"
  print (subtotalItem ("Caneta", 3.5, 10))
  putStrLn "Total do carrinho:"
  print subtotal
  putStrLn "Cupom de 10% para compras a partir de R$ 200:"
  print (cupomCondicional 10 200 subtotal)
  putStrLn "Carrinho vazio:"
  print (totalCarrinho [])
