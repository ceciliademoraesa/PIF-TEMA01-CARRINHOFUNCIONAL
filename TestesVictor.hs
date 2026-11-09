module Main (main) where

import Cupom (aplicarCupom)
import Frete (calcularFrete)
import System.Exit (exitFailure)

-- Descricao, resultado obtido e resultado esperado.
-- A igualdade exata e adequada: calcularFrete so retorna 0 ou 15.
testes :: [(String, Double, Double)]
testes =
  [ ("Exemplo do enunciado", calcularFrete 150, 15)
  , ("Compra de valor zero", calcularFrete 0, 15)
  , ("Valor negativo: sem validacao adicional", calcularFrete (-10), 15)
  , ("Compra de um centavo", calcularFrete 0.01, 15)
  , ("Abaixo do limite", calcularFrete 199, 15)
  , ("Um centavo abaixo do limite", calcularFrete 199.99, 15)
  , ("Exatamente no limite", calcularFrete 200, 0)
  , ("Um centavo acima do limite", calcularFrete 200.01, 0)
  , ("Acima do limite", calcularFrete 350, 0)
  , ("Cupom reduz 220 para 198: cobra frete", calcularFrete (aplicarCupom 10 220), 15)
  , ("Cupom reduz 250 para 200: frete gratis", calcularFrete (aplicarCupom 20 250), 0)
  , ("Cupom de 100%: valor zero ainda cobra frete", calcularFrete (aplicarCupom 100 300), 15)
  ]

formatarTeste :: (String, Double, Double) -> String
formatarTeste (nome, obtido, esperado) =
  (if obtido == esperado then "OK: " else "FALHOU: ") ++ nome
    ++ " | esperado: " ++ show esperado ++ " | obtido: " ++ show obtido

main :: IO ()
main = do
  putStrLn "== Testes de calcularFrete (Victor) =="
  mapM_ (putStrLn . formatarTeste) testes
  let resultados = [obtido == esperado | (_, obtido, esperado) <- testes]
      aprovados = length (filter id resultados)
  putStrLn (show aprovados ++ " de " ++ show (length testes) ++ " testes aprovados.")
  if and resultados then pure () else exitFailure
