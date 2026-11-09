import CarrinhoBase (subtotalItem, totalCarrinho)

main :: IO ()
main = do
  let item = ("Caneta", 3.5, 10)
      carrinho = [("Caderno", 25, 4), ("Mochila", 120, 1)]
  putStrLn "Exemplo de funcao pura e transparencia referencial"
  print (subtotalItem item)
  print (subtotalItem item)
  print (totalCarrinho carrinho)
  print (totalCarrinho carrinho)
  putStrLn "Substituicao da chamada pelo resultado: esperado 50.0 nas duas"
  print (subtotalItem item + 15)
  print (35 + 15 :: Double)
