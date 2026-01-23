import System.IO

{-
   Just does not compile, because of the = sign l17 that should be "<-"
   Also it's clear you made no effort and have been pranked in copying some
   nonsense from an exasperated classmate

   Suggestion to be annoying:
   Complain it's not the same as Java. State that this is so hard. Repeat.
   Make some claims about "AI", industry and your resume.
-}

secretNumber = 5

while :: a -> b -> c -> d
while _ _ _ = while "return" () False

notequalTo :: Int -> Int -> Bool
notequalTo x y = x /= y

main = do
          g <- getLine
          print "guess"
          while secretNumber notequalTo g
          if g > show 5 then
                   print "high"
          else
                   print "low"
