module Main (main) where

import CarrinhoBase (Item)
import Pedido (resumoPedido)
import System.Exit (exitFailure)

-- Evita falhas por pequenas imprecisoes de numeros Double.
aproximadamenteIgual :: Double -> Double -> Bool
aproximadamenteIgual esperado obtido = abs (esperado - obtido) < 0.000001

verificarResumo :: String -> [Item] -> Double -> (Double, Double, Double) -> (String, Bool)
verificarResumo nome itens percentual (subtotalEsperado, freteEsperado, totalEsperado) =
  let (subtotalObtido, freteObtido, totalObtido) = resumoPedido itens percentual
  in (nome, aproximadamenteIgual subtotalEsperado subtotalObtido
     && aproximadamenteIgual freteEsperado freteObtido
     && aproximadamenteIgual totalEsperado totalObtido
     && aproximadamenteIgual totalObtido
          (subtotalObtido * (1 - percentual / 100) + freteObtido))

main :: IO ()
main = do
  let resultados =
        [ verificarResumo "Sem desconto e com frete" [("Livro", 100, 1)] 0 (100, 15, 115)
        , verificarResumo "Com desconto de 10%" [("Livro", 100, 1)] 10 (100, 15, 105)
        , verificarResumo "Pedido com frete" [("Caneta", 20, 2)] 0 (40, 15, 55)
        , verificarResumo "Frete gratis acima de R$ 200" [("Mochila", 250, 1)] 0 (250, 0, 250)
        , verificarResumo "Carrinho vazio (frete de R$ 15 pelo contrato)" [] 0 (0, 15, 15)
        , verificarResumo "Subtotal zero por quantidade zero" [("Livro", 100, 0)] 0 (0, 15, 15)
        , verificarResumo "R$ 199,99 apos desconto: paga frete" [("Produto", 199.99, 1)] 0 (199.99, 15, 214.99)
        , verificarResumo "R$ 200 apos desconto: frete gratis" [("Produto", 200, 1)] 0 (200, 0, 200)
        , verificarResumo "R$ 200,01 apos desconto: frete gratis" [("Produto", 200.01, 1)] 0 (200.01, 0, 200.01)
        , verificarResumo "Cupom reduz R$ 200 para R$ 180 e gera frete" [("Produto", 200, 1)] 10 (200, 15, 195)
        , verificarResumo "Cupom reduz R$ 250 para R$ 200: frete gratis" [("Produto", 250, 1)] 20 (250, 0, 200)
        , verificarResumo "Soma de varios itens e total final" [("Caderno", 25, 4), ("Mochila", 120, 1)] 10 (220, 15, 213)
        , verificarResumo "Desconto de 100%: frete continua R$ 15" [("Produto", 300, 1)] 100 (300, 15, 15)
        ]
  let aprovados = length (filter snd resultados)
      quantidade = length resultados
  mapM_ (\(nome, ok) -> putStrLn ((if ok then "OK: " else "FALHOU: ") ++ nome)) resultados
  putStrLn (show aprovados ++ " de " ++ show quantidade ++ " testes aprovados.")
  if all snd resultados then pure () else exitFailure
