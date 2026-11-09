import CarrinhoBase (subtotalItem, totalCarrinho, cupomCondicional)
import Control.Monad (forM_)
import System.Exit (exitFailure)

aproximado :: Double -> Double -> Bool
aproximado esperado obtido = abs (esperado - obtido) < 1e-8

testes :: [(String, Double, Double)]
testes =
  [ ("subtotal dez canetas", 35, subtotalItem ("Caneta", 3.5, 10))
  , ("subtotal quantidade zero", 0, subtotalItem ("Caneta", 3.5, 0))
  , ("subtotal preco zero", 0, subtotalItem ("Brinde", 0, 3))
  , ("subtotal unitario", 12, subtotalItem ("Livro", 12, 1))
  , ("subtotal decimal", 7.5, subtotalItem ("Item", 2.5, 3))
  , ("carrinho vazio", 0, totalCarrinho [])
  , ("carrinho com um item", 35, totalCarrinho [("Caneta", 3.5, 10)])
  , ("carrinho com dois itens", 220, totalCarrinho [("Caderno", 25, 4), ("Mochila", 120, 1)])
  , ("carrinho com item zerado", 20, totalCarrinho [("Brinde", 0, 1), ("Livro", 20, 1)])
  , ("carrinho decimal", 9.6, totalCarrinho [("A", 1.2, 3), ("B", 2.0, 3)])
  , ("cupom abaixo do minimo", 199, cupomCondicional 10 200 199)
  , ("cupom no minimo", 180, cupomCondicional 10 200 200)
  , ("cupom acima do minimo", 198, cupomCondicional 10 200 220)
  , ("cupom zero porcento", 220, cupomCondicional 0 200 220)
  , ("cupom cem porcento", 0, cupomCondicional 100 200 220)
  , ("cupom minimo zero", 90, cupomCondicional 10 0 100)
  , ("cupom subtotal zero", 0, cupomCondicional 10 200 0)
  , ("transparencia subtotal", subtotalItem ("A", 2, 3), subtotalItem ("A", 2, 3))
  , ("transparencia total", totalCarrinho [("A", 2, 3)], totalCarrinho [("A", 2, 3)])
  ]

main :: IO ()
main = do
  forM_ testes $ \(nome, esperado, obtido) ->
    putStrLn ((if aproximado esperado obtido then "OK: " else "FALHOU: ") ++ nome)
  let falhas = [nome | (nome, esperado, obtido) <- testes, not (aproximado esperado obtido)]
  if null falhas
    then putStrLn ("Aprovados: " ++ show (length testes) ++ "/" ++ show (length testes))
    else do
      putStrLn ("Falhas: " ++ show falhas)
      exitFailure
