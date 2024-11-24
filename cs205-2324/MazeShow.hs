
data Orientation = H | V deriving Eq

type Wall = (Int,Int,Orientation)

type Maze = ((Int,Int), (Int, Int), [Wall])

showMaze :: Maze -> String
showMaze ((w,h), (sX, sY), ws) = showmazeH h
  where  ows o = filter (\ (_,_,o') -> o == o') ws
         filterByHeight h z = map (\(x,_,y) -> (x,y)) $ filter (\(_,x,_) -> x == h) z 
         hws h = map fst (filterByHeight h $ ows H)
         vws h = map fst (filterByHeight h $ ows V)
         pwsV = [0..w]
         pwsH = [0..w-1]
         boolHwall True = "━━━"
         boolHwall False = "   "
         showmazeH (-1) = ""
         showmazeH h =
           concatMap (\x -> inter x h ++ boolHwall (x `elem` hws h)) [0..w-1] ++
           inter w h ++ "\n" ++ showmazeV (h - 1)
         inter x y =
            case wallsAround x y of
              [True, True, True, True] -> "╋"
              [True, True, True, False] -> "┻"
              [True, True, False, True] -> "┣"
              [True, True, False, False] -> "┗"
              [True, False, True, True] -> "┳"
              [True, False, True, False] -> "━"
              [True, False, False, True] -> "┏"
              [True, False, False, False] -> "╺"
              [False, True, True, True] -> "┫"
              [False, True, True, False] -> "┛"
              [False, True, False, True] -> "┃"
              [False, True, False, False] -> "╹"
              [False, False, True, True] -> "┓"
              [False, False, True, False] -> "╸"
              [False, False, False, True] -> "╻"
              [False, False, False, False] -> " "           
         wallsAround x y = [hasWall H x y, hasWall V x y,
                            hasWall H (x-1) y, hasWall V x (y-1)]
         hasWall o x y = (x,y,o) `elem` ws
         boolVwall True = "┃"
         boolVwall False = " "
         showmazeV (-1) = ""
         showmazeV h = concat (zipWith (++) 
                                            (map (boolVwall . (`elem` vws h)) pwsV)
                                            (map (`popsq` h) pwsV))
                       ++ "\n" ++ showmazeH h
                         where popsq x y | x == sX && y == sY = " @ "
                                         | otherwise = "   "
exampleMaze :: Maze
exampleMaze = ((4,4), (2,2), hWalls ++ vWalls)
   where vWalls = map (\ (i,j) -> (i,j,V))
                  [
                    (0,0),(0,1),(0,2),(0,3),
                          (1,1),(1,2),
                          (2,1),(2,2),
                                (3,2),(3,3),
                    (4,0),(4,1),(4,2),(4,3)
                  ]
         hWalls = map (\ (i,j) -> (i,j,H))
                  [
                    (0,0),(1,0),(2,0),(3,0),
                    (0,1),      (2,1),
                                (2,2),
                    (0,4),(1,4),(2,4),(3,4)
                  ]

main :: IO ()
main = putStrLn $ showMaze exampleMaze
