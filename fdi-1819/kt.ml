(* On ne va pas s'amuser à encoder des machines de Turing; pour aller plus
vite, on va utiliser les combinateurs S K. C'est moralement du λ-calcul un
peu obfusqué.
https://en.wikipedia.org/wiki/SKI_combinator_calculus
*)
type sk =
  App of sk * sk | S | K

(* On implémente une stratégie de réduction call-by-name. Noter qu'on
   donne explicitement un nombre d'étapes de réductions (ce nombre d'étape
   est un poil fantaisiste vu le 3ème sous-cas, mais ce n'est pas très
   important). *)
let rec eval (n : int) (t : sk) =
  if n = 0 then
    t
  else
   match t with
   App (App (K, x), y) -> eval (n-1) y
 | App (App (App (S, x), y), z) -> eval (n-1) (App(App(x, z), App(y, z)))
 | App (x, y) -> eval (n-1) (App (eval n x, eval n y))
 | t -> t

let normal (t : sk) = t = eval 1 t

(* On construit une énumération exhaustive des termes SK en commençant par
   S. (Exercice: prouver que le programme ci-dessous termine et est correct...) *)
let rec succ_sk = function
   S -> K
 | K -> App (S, S)
 | App (S, x) -> App(succ_sk x, S)
 | App (x, y) -> App(pred_sk x, succ_sk y)
and pred_sk = function
 | S -> raise (Invalid_argument "pred_sk undefined on S")
 | K -> S
 | App (S, S) -> K
 | App (x, S) -> App (S, pred_sk x)
 | App (x, y) -> App (succ_sk x, pred_sk y)


(* Avec ce petit bout de formalisme des fonctions calculables, on est prêt!

On définit le type des arbres, et l'arbre de Kleene dans la foulée. *)

type path = bool list
type tree = path -> bool

(* slow est une fonction arbitraire int -> int qui tend vers l'infini.
Je l'ai mise là comme paramètre additionel, car plus on prend quelque chose avec
un taux de croissance faible, plus l'arbre obtenu est feuillu. Pour faire
tourner des exemples, mieux vaut un arbre feuillu!
*)

let slow (n : int) : int =
  let slow_aux n = n+1 |> float_of_int |> log |> int_of_float in
  slow_aux @@ slow_aux @@ slow_aux n

let kleene_tree : tree =
  let rec check n tm =
    function [] -> true
           | h :: t -> let ntm = eval (slow n) tm in
                       ((h && normal ntm) = (ntm = K)) && check n (succ_sk tm) t
  in
  fun l -> check (List.length l) S l

(* Avec cet arbre, on peut donc coder une bijection entre les espaces de Cantor
   et Baire effectif. Pour se faire, on définit d'abord quelque combinateurs sur les
   arbres. *)

let nexttree (b : bool) (t : tree) : tree =
  fun l -> t (b :: l) 

(* Prédicat qui nos donne les chemins minimaux qui sortent d'un arbre. *)
let rec frontier (t : tree) : path -> bool = function
   [] -> not (t [])
 | b :: p' -> t [] && frontier (nexttree b t) p'

(* Énumération naïve des chemins de l'arbre binaire complet. *)
let nextpath (p : path) : path =
   let rec aux acc = function
    [] -> List.rev_map not (true :: acc)
  | true :: p' -> aux (true :: acc) p'
  | false :: p' -> List.rev_append (List.map (fun _ -> false) acc) (true :: p')
   in aux [] p

(* Bijection des chemins sortant minimaux dans ℕ. *)
let kt_of_nat =
  let rec aux c n =
   if frontier kleene_tree c then
     match n with
      0 -> c
    | k -> aux (nextpath c) (n-1)
   else 
    aux (nextpath c) n
  in aux []

let nat_of_kt p =
  let rec aux n =
    if kt_of_nat n = p then n else aux (n + 1)
  in
  aux 0

type cantor = int -> bool
type baire = int -> int

(* D'abord, on construit la fonction Cantor → Baire.

Pour commencer, étant donné f dans Cantor, on cherche le préfixe
minimal sortant de l'arbre de Kleene. *)
let nextoutgoing (f : cantor) : path =
  let rec aux acc t' f =
    if not (t' []) then List.rev acc
    else aux (f 0 :: acc) (nexttree (f 0) t') (fun n -> f (n + 1))
  in aux [] kleene_tree f

(* On itère. *)
let rec outgoingseq (f : cantor) : int -> path = function
   n -> nextoutgoing (fun k -> f (k + outgoingseqlen f (n-1)))
and outgoingseqlen (f : cantor) = function
   -1 -> 0
 | n -> List.length (outgoingseq f n) + outgoingseqlen f (n - 1)

(* Et paf. *)
let baire_of_cantor (f : cantor) : baire =
  fun n -> nat_of_kt (outgoingseq f n)

(* Pour Baire → Cantor, on définit d'abord la concaténation infinie. *)
let rec concat (f : int -> 'a list) (n : int) : 'a =
  let l = f 0 in
  let k = List.length l in
  if n < k then List.nth l n
  else concat (fun m -> f @@ 1 + m) (n - k)

(* Et ensuite on applique point à point kt_of_nat auparavant. *) 
let cantor_of_baire (f : baire) : cantor =
  concat (fun k -> kt_of_nat (f k))

