{-# LANGUAGE TemplateHaskell, QuasiQuotes, FlexibleContexts #-}
module KropayaReader(code, number) where

import Text.Peggy
import Numeric
import Data.Text
import Data.Text.Read
import Data.Maybe

import KropayaTypes

[peggy|
code :: [Code] = (txt { KR0Type $ KAtomic $1 } / number { KR0Type $ KAtomic $1 } / nl) nl? !. { $1 : (maybeToList $2) }

sstring_escapes :: Char
  = ('\\' 'n'  { '\n' })
  / ('\\' 'r'  { '\r' })
  / ('\\' ']'  { ']'  })
  / ('\\' '\\' { '\\' })

txt :: Atomic
  = sstring

nl :: Code
  = ('\n' '\r' / '\n' / '.') { NL }

sstring :: Atomic
  = '#' '[' ([^\]\\] / sstring_escapes)* ']' { KStr $ pack $1 }

number :: Atomic
  = kdecimal
  / hinteger
  / dinteger

sign :: Maybe Char
  = [-+]?

kdecimal :: Atomic
  = sign [0-9]+ '.' [0-9]+ { KDec (sigrat $1 ($2 ++ "." ++ $3)) }

dinteger :: Atomic
  = sign [0-9]+ { KInt (sigdec $1 $2) }

hinteger :: Atomic
  = sign '0' 'x' [0-9a-fA-F]+ { KInt (sighex $1 $2) }
|]

sighex = sigthing hexadecimal
sigdec = sigthing decimal
sigrat = sigthing rational

sigthing :: Num n => Reader n -> Maybe Char -> String -> n
sigthing thing (Just sign) mag = case signed thing (pack (sign : mag)) of Right (number, _) -> number
                                                                          _                 -> 0 
sigthing thing _ mag = case thing (pack mag) of Right (number, _) -> number
                                                _                 -> 0 

