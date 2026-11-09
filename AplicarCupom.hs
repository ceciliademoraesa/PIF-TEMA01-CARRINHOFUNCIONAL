-- AplicarCupom.hs
-- Parte da Livia: funcao aplicarCupom e seus testes.
-- Tema 01: Funcoes puras em um carrinho de compras (equipe Carrinho Funcional)
--
-- Como rodar:
--   runghc AplicarCupom.hs
--   ghci AplicarCupom.hs   (depois: aplicarCupom 10 100)

-- | Aplica um cupom de desconto percentual sobre um valor.
--   Primeiro argumento: percentual do desconto (10 significa 10%).
--   Segundo argumento: valor sobre o qual o desconto e aplicado.
--   Funcao pura: o resultado depende so das entradas e nada fora dela muda.
--
--   Hipotese documentada: a funcao espera percentual entre 0 e 100.
--   Ela nao corrige valores fora dessa faixa, para nao mudar a regra do tema
--   em silencio (ver casos de limite nos testes).
aplicarCupom :: Double -> Double -> Double
aplicarCupom percentual valor = valor - valor * percentual / 100

-- | Um caso de teste: descricao, valor obtido e valor esperado.
type Teste = (String, Double, Double)

-- | Casos obrigatorios do plano do grupo e casos extras.
testes :: [Teste]
testes =
  [ ("10% de 100",                     aplicarCupom 10 100,  90)
  , ("0% de 100 (valor original)",     aplicarCupom 0 100,   100)
  , ("100% de 100 (zero)",             aplicarCupom 100 100, 0)
  , ("10% do carrinho de 220",         aplicarCupom 10 220,  198)
  , ("25% de 80",                      aplicarCupom 25 80,   60)
  , ("10% de 0 (carrinho vazio)",      aplicarCupom 10 0,    0)
  ]

-- | Compara dois Double com tolerancia, porque contas com ponto flutuante
--   podem ter diferencas minimas na ultima casa decimal.
quaseIgual :: Double -> Double -> Bool
quaseIgual a b = abs (a - b) < 1e-9

-- | Monta a linha de resultado de um teste. Tambem e pura: so devolve texto.
verificar :: Teste -> String
verificar (descricao, obtido, esperado)
  | quaseIgual obtido esperado = "OK    " ++ descricao ++ " -> " ++ show obtido
  | otherwise = "FALHA " ++ descricao ++ " -> obtido " ++ show obtido
                ++ ", esperado " ++ show esperado

-- | Conta quantos testes passaram.
quantosPassaram :: [Teste] -> Int
quantosPassaram ts = length [t | t@(_, obtido, esperado) <- ts, quaseIgual obtido esperado]

main :: IO ()
main = do
  putStrLn "== Testes de aplicarCupom =="
  mapM_ (putStrLn . verificar) testes
  putStrLn ("Passaram " ++ show (quantosPassaram testes) ++ " de " ++ show (length testes))
  putStrLn ""
  putStrLn "== Limites documentados (fora da faixa 0 a 100) =="
  putStrLn ("aplicarCupom 150 100 = " ++ show (aplicarCupom 150 100) ++ "  (valor negativo)")
  putStrLn ("aplicarCupom (-10) 100 = " ++ show (aplicarCupom (-10) 100) ++ "  (vira acrescimo)")
  putStrLn ""
  putStrLn "== Transparencia referencial =="
  let a = aplicarCupom 10 220 + 15
      b = 198 + 15
  putStrLn ("aplicarCupom 10 220 + 15 = " ++ show a)
  putStrLn ("198 + 15                 = " ++ show b)
  putStrLn ("Iguais? " ++ show (a == b))
