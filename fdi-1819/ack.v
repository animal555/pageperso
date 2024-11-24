(* Testé avec Coq 8.8.2 *)

Require Import Lia.

(* On formalise les fonctions primitives récursives. *)

(* Pour ne pas avoir à aplanir des tuples tout le temps, on définit un petit
système de types. Ici, tous les types seront, à associativité du produit près,
isomorphes à des ℕ puissance quelque chose. *)
Inductive ty :=
  ty_unit : ty
| ty_N : ty
| ty_prod : ty -> ty -> ty.

Notation "'𝟙'" := ty_unit.
Notation "τ × σ" := (ty_prod τ σ) (at level 62).
Notation "'ℕ'" := ty_N.

(* Les types ont une interprétation ensembliste directe.
   La classe des fonctions récursive sera incluse dans l'union des
     interp_ty τ -> interp_ty σ
   pour τ, σ types.
*)
Fixpoint interp_ty (τ : ty) : Type :=
  match τ with
  | 𝟙 => unit
  | ℕ => nat
  | τ × σ => prod (interp_ty τ) (interp_ty σ)
  end.

(* Pour illustrer la chose, quelque fonctions.
   - "zerotuple : interp_ty τ" construit l'élement de interp_ty τ correspondant à un
     tuple de 0.
   - "sumtuple : interp_ty τ -> nat" calcule la somme des éléments du tuple
*)

Fixpoint zero_tuple (τ : ty) : interp_ty τ :=
  match τ with
    𝟙 => tt
  | ℕ => 0
  | σ × κ => (zero_tuple σ, zero_tuple κ)
  end.

Fixpoint sumtuple {τ} :=
  match τ return interp_ty τ -> nat with
    𝟙 => fun _ => 0
  | τ × σ => fun x => let (a,b) := x in
                      (@sumtuple τ a) + (@sumtuple σ b)
  | ℕ => fun n => n
  end.

(* Les fonctions primitives récursives sont générées par une syntaxe assez naturelle,
indexée par les types.

On commente les différents éléments de syntaxe introduits, et histoire d'être un peu
plus clair, des équations qui doivent être satisfaites dans la sémantique. Histoire de
coller au formalisme, ces dernières sont toutes donnés en termes de composition de
fonctions, un énoncé du type "f ≡ g" voulant dire "pour tout x du bon type
'⟦ f ⟧ x = ⟦ g ⟧ x'" où ⟦.⟧ est une fonction d'interprétation.  *)

Inductive primrec : ty -> ty -> Type :=
  pr_comp : forall τ σ κ, primrec τ σ -> primrec κ τ -> primrec κ σ
| pr_id : forall τ, primrec τ τ
  (* Ces deux premières closes nous assurent que l'on a la clôture par composition
     et les éléments neutres. On requièrera notamment les équations
      (f ∘ g) ∘ h ≡ f ∘ (g ∘ h)       [associativité]
      f ∘ pr_id ≡ f                   [neutre droit]
      pr_id ∘ f ≡ f                   [neutre gauche]
   *)
| pr_unit : forall τ, primrec τ 𝟙
| pr_pairing : forall τ σ κ, primrec τ σ -> primrec τ κ -> primrec τ (σ × κ)
| pr_proj1 : forall τ σ, primrec (τ × σ) τ
| pr_proj2 : forall τ σ, primrec (τ × σ) σ
   (* Ici on demande assez de structure pour gérer les produits cartésiens. 
      En notant "⟨ f, g ⟩" pour "pr_pairing f g", on demande à avoir
        pr_unit ∘ f ≡ pr_unit             [𝟙 terminal]
        pr_proj1 ∘ ⟨f, g⟩ ≡ f             [première projection]
        pr_proj2 ∘ ⟨f, g⟩ ≡ g             [seconde projection]
        ⟨ pr_proj1 , pr_proj2 ⟩ ≡ pr_id   [surjective pairing]
      
   *)
| pr_zero : primrec 𝟙 ℕ
| pr_succ : primrec ℕ ℕ
| pr_rec : forall τ σ, primrec τ σ -> primrec (τ × σ) σ -> primrec (τ × ℕ) σ
   (* Enfin, la structure minimale pour gérer les entiers naturels. Les équations
      attendues pour le récurseur sont:
        pr_rec z r ∘ ⟨ pr_id , pr_zero ⟩ ≡ z                           [cas n = 0]
        pr_rec z r ∘ (pr_id × pr_succ) ≡ r ∘ ⟨ pr_proj1 , pr_rec z r ⟩ [cas n = k + 1]
    *)
.

Notation "f ∘ g" := (pr_comp _ _ _ f g) (at level 62).
Arguments pr_id [_].
Arguments pr_unit [_].
Notation "⟨ f , g ⟩" := (pr_pairing _ _ _ f g).
Arguments pr_proj1 [_ _].
Arguments pr_proj2 [_ _].
Arguments pr_rec [_ _] _ _.

(* On va maintenant définir la fonction d'interprétation ⟦.⟧. Pour se faire, on code
d'abord des fonctions auxiliaires qui serviront à interpréter le récurseur.

L'idée de base du récurseur est qu'il sert à itérer une fonction donnée sur un argument,
comme la fonction iter ci-dessous. *)
Fixpoint iter {B : Type} (r : B -> B) (z : B) (n : nat) :=
  match n with
    0 => z
  | S k => r (iter r z k)
  end.

(* Dans les fait, la fonction iter ci-dessus correspond au récurseur à paramètre 𝟙. Si le
paramètre est non-trivial, iter doit être adapté pour l'accomoder comme ci-dessous. *)
Definition iter_param {A B : Type} (z : A -> B) (r : (A * B) -> B) :=
  fun (x : A * nat) => let (a,n) := x in iter (fun y => r (a, y)) (z a) n.

Arguments iter_param [_ _] _ _ : simpl never.


(* On est donc prêt à interpréter les fonctions primitives récursives par induction sur
leur syntaxe. *)
Reserved Notation "⟦ f ⟧".
Fixpoint interp_primrec {τ σ : ty} (t : primrec τ σ) : interp_ty τ -> interp_ty σ :=
  match t with
    f ∘ g => fun x => ⟦f⟧ (⟦g⟧ x)
  | pr_id => fun x => x
  | pr_unit => fun _ => tt
  | ⟨ f , g ⟩ => fun x => (⟦f⟧ x, ⟦g⟧ x)
  | pr_proj1 => fst
  | pr_proj2 => snd
  | pr_zero => fun _ => 0
  | pr_succ => S
  | pr_rec z r => iter_param ⟦z⟧ ⟦r⟧
  end
where "⟦ t ⟧" := (@interp_primrec _ _ t).

(* Cette interprétation satisfait bien les équations données en commentaire lors de la
définition de la syntaxe. On pourrait le vérifier formellement, mais ici on ne se contente
que de donner des lemmes capturant les équations essentielles pour l'interprétation du récurseur.

(En réalité on pourrait même montrer un résultat plus fort que la correction de l'interprétation
vis-à-vis de la théorie équationelle: l'interprétation est canonique (initiale) parmis celles qui
satisfont cette théorie équationnelle)
 *)

Lemma pr_rec_0 : forall τ σ (z : primrec τ σ) r a, ⟦pr_rec z r⟧ (a,0) = ⟦ z ⟧ a.
  trivial.
Qed.

Lemma pr_rec_1 : forall τ σ (z : primrec τ σ) r a n, ⟦pr_rec z r⟧ (a, S n) = ⟦ r ⟧ (a, ⟦pr_rec z r⟧ (a, n)).
  trivial.
Qed.



(* La fonction d'Ackerman. Noter que la définition est pas forcément intuitive en première lecture
à cause d'un passage par l'ordre supérieur. *)
Fixpoint ack (n : nat) : nat -> nat :=
  match n with
    0 => S
  | S k => fix ack_aux (m : nat) :=
            match m with
              0 => ack k 1
            | S k' => ack k (ack_aux k')
            end
  end.

(* On vérifie que la définition satisfait bien les mêmes équations que sur le papier. *)
Lemma ack0m : forall m, ack 0 m = S m.
  trivial.
Qed.

Lemma ackn0 : forall n, ack (S n) 0 = ack n 1.
  trivial.
Qed.

Lemma acknm : forall n m, ack (S n) (S m) = ack n (ack (S n) m).
  trivial.
Qed.

(* Calcul explicite de λ k. ack n k pour n = 1, 2. *)
Lemma ack1m : forall k, ack 1 k = 2 + k.
  induction k; [simpl; lia|].
  rewrite acknm, ack0m; lia.
Qed.

Lemma ack2m : forall k, ack 2 k = 3 + 2 * k.
  induction k; [simpl;lia|].
  rewrite acknm, ack1m; lia.
Qed.

(* On prouve quelques propriétés élémentaires de la fonction d'Ackerman, dont la croissance.
On commence donc par poser quelque définitions. *)

(* SC f ≡ f est strictement croissante *)
Definition SC (f : nat -> nat) := forall n m, n < m -> f n < f m.

(* SC' f ≡ définition alternative de la croissance stricte pour f *)
Definition SC' (f : nat -> nat) := forall n, f n < f (S n).

(* C f ≡ f est croissante *)
Definition C (f : nat -> nat) := forall n m, n <= m -> f n <= f m.

(* Les implications triviales SC' -> SC -> C. *)
Lemma SC'SC : forall f, SC' f -> SC f.
  intros ? ? ? ? p; induction p; intros; unfold SC' in *; eauto.
  eapply PeanoNat.Nat.lt_trans; eauto.  
Qed.

Lemma SCC : forall f,  SC f -> C f.
  intros ? ? ? ? p; induction p; intros; unfold SC in *; auto.  
  specialize (H m (S m)); lia.
Qed.

(* La fonction d'ackerman est quasiment toujours > 1. *)
Lemma ack_1 : forall p n, p > 0 \/ n > 0 -> ack p n > 1.
  induction p; induction n; try (simpl; lia).
  + intros _.
    simpl. auto.
  + intros _.
    rewrite acknm.     
    apply IHp.
    lia.
Qed.

(* Croissance stricte dans la seconde composante. *)
Lemma ack_sc'_m : forall n, SC' (ack n).
  induction n; intros m; induction m; try (simpl; lia).    
  + simpl.
    apply SC'SC in IHn.
    apply IHn, ack_1; lia.
  + do 2 rewrite acknm.
    apply SC'SC in IHn. apply IHn; assumption.
Qed.

Lemma ack_sc_m : forall n, SC (ack n).
   intros; apply SC'SC, ack_sc'_m.
Qed.

Lemma ack_c_m : forall n, C (ack n).
  intros; apply SCC, ack_sc_m.
Qed.

(* Croissance stricte en la première composante. *)
Lemma ack_sc'_n : forall m, SC' (fun n => ack n m).
  intros m n; revert m; induction n; induction m; try (simpl; lia).
  + rewrite acknm.
    apply ack_sc_m, IHm.
  + simpl.
    apply ack_sc_m, ack_1; lia.
  + rewrite acknm.
    eapply PeanoNat.Nat.lt_trans; [apply IHn|].
    change (ack (S (S n)) (S m)) with (ack (S n) (ack (S (S n)) m)).
    apply ack_sc_m, IHm.
Qed.

Lemma ack_sc_n : forall m, SC (fun n => ack n m).
  intros; apply SC'SC, ack_sc'_n.
Qed.

Lemma ack_c_n : forall m, C (fun n => ack n m).
  intros; apply SCC, ack_sc_n.
Qed.


(* Propriétés importante demandées en question 1 *)
Lemma ack_c : forall n m, ack n (S m) <= ack (S n) m.
  assert (Hcm := ack_c_m); assert (Hcn := ack_c_n).
  induction n; induction m; try (simpl; lia).
  + rewrite acknm.
    apply Hcm, IHm.
  + rewrite acknm.
    change (ack (S (S n)) (S m)) with (ack (S n) (ack (S (S n)) m)).
    eapply PeanoNat.Nat.le_trans.
    - apply Hcm, IHm.
    - apply Hcn; lia.
Qed.

Lemma ack2plus : forall k n, 2 * ack k n <= ack (2 + k) n.
  induction k.
  - intros; simpl plus; rewrite ack2m, (ack0m n); lia.
  - destruct n.
    + rewrite ackn0.
      rewrite IHk; apply ack_c.
    + simpl plus; do 2 rewrite acknm.
      rewrite IHk.
      apply ack_c_m, ack_c_n; lia.
Qed.

(* En combinant ack2plus avec la croissance, on obtient le corollaire suivant, utile
   pour raisonner sur les sommes. *)
Lemma ack2plusplus : forall p q k n, p <= ack k n -> q <= ack k n -> p + q <= ack (2 + k) n.
  intros.
  apply PeanoNat.Nat.le_trans with (2 * ack k n); [lia|apply ack2plus].
Qed.

Lemma ack_le_r : forall n m p, n <= m -> n <= ack p m.
   intros.
   apply PeanoNat.Nat.le_trans with (ack 0 n); [simpl;lia|].
   eapply PeanoNat.Nat.le_trans; [eapply ack_c_n|eapply ack_c_m]; lia.
Qed.

(* On prouve par induction la propriété cruciale qui couvre plusieurs questions du DM.
   La conséquence utile est l'énoncé suivant: pour toute fonction primitive récursive
   (f : nat -> nat), il existe (x : nat) tel que pour tout n : nat, f n ≤ ack x n.

   On peut noter en particulier les constantes qui apparaissent lors des différents
   sous-case, dont notamment la composition, le pairing (2 + max k1 k2) et
   le récurseur (3 + max k1 k2). 

   NB: la notation { x : A | P x } en Coq correspond à un type renforçant l'existentielle
   "exists x : A, P x" afin de permettre l'extraction de fonction.
*)

Lemma ack_pr : forall {τ σ} (f : primrec τ σ),
    { k | forall x : interp_ty τ, sumtuple (⟦f⟧ x) <= ack k (sumtuple x)}.
  induction f; try (exists 0; simpl in *; intros;  lia).
  + destruct IHf1 as [k1 IHf1], IHf2 as [k2 IHf2].
    exists (2 + (max k1 k2)).
    intros x.
    specialize (IHf1 (⟦f2⟧ x)).
    rewrite IHf1.
    specialize (IHf2 x).
    etransitivity;[ apply ack_c_m, IHf2|].
    transitivity (ack (max k1 k2) (ack (S (max k1 k2)) (sumtuple x))).
    * eapply PeanoNat.Nat.le_trans; [ apply ack_c_m |]; apply ack_c_n; lia.
    * rewrite <-acknm, ack_c; simpl; lia.
  + destruct IHf1 as [k1 IHf1], IHf2 as [k2 IHf2].
    exists (2 + max k1 k2).
    intros x; specialize (IHf1 x); specialize (IHf2 x).
    assert (IHf1' : sumtuple (⟦f1⟧ x) <= ack (max k1 k2) (sumtuple x)) by
        (eapply PeanoNat.Nat.le_trans; [apply IHf1|]; apply ack_c_n; lia).
    assert (IHf2' : sumtuple (⟦f2⟧ x) <= ack (max k1 k2) (sumtuple x)) by
        (eapply PeanoNat.Nat.le_trans; [apply IHf2|]; apply ack_c_n; lia).
    simpl sumtuple.
    eapply PeanoNat.Nat.le_trans;[|apply ack2plus]; simpl; lia.
  + exists 0; intros [? ?]; simpl in *; lia.
  + exists 0; intros [? ?]; simpl in *; lia.
  + destruct IHf1 as [k1 IHf1], IHf2 as [k2 IHf2].
    exists (3 + max k1 k2).
    intros [a n]; specialize (IHf1 a).
    assert (IHf1' : sumtuple (⟦f1⟧ a) <= ack (max k1 k2) (sumtuple a)) by
        (eapply PeanoNat.Nat.le_trans; [apply IHf1|]; apply ack_c_n; lia).
    assert (IHf2' : forall (c : interp_ty σ), sumtuple (⟦f2⟧ (a, c)) <= ack (max k1 k2) ((sumtuple a) + (sumtuple c))) by
        (intros c; eapply PeanoNat.Nat.le_trans; [apply IHf2|]; apply ack_c_n; lia).
    remember (max k1 k2) as k;
    clear IHf1 IHf2 Heqk k1 k2.
    cut (sumtuple a + sumtuple (⟦ pr_rec f1 f2 ⟧ (a, n)) <= ack (3 + k) (sumtuple a + n)); [simpl; lia|].
    induction n.
    - rewrite pr_rec_0.
      replace (sumtuple a + 0) with (sumtuple a) by lia.
      apply ack2plusplus.
      * apply PeanoNat.Nat.le_trans with (S (sumtuple a));[lia|].
        rewrite <-(ack0m (sumtuple a)).
        apply ack_c_n; lia.
      * rewrite IHf1'; apply ack_c_n; lia.
    - rewrite pr_rec_1.
      apply PeanoNat.Nat.le_trans with
          (ack (2 + k) ((sumtuple a) + (sumtuple (⟦ pr_rec f1 f2 ⟧ (a, n))))).
      * {
          apply ack2plusplus.
          + apply ack_le_r; lia.
          + rewrite IHf2'; fold interp_ty; lia.
        }
      * { apply PeanoNat.Nat.le_trans with
              (ack (2 + k) (ack (3 + k) (sumtuple a + n))).
          + apply ack_c_m, IHn.
          + rewrite <-acknm.
            apply PeanoNat.Nat.eq_le_incl, f_equal2; lia.
        }
Defined.

(* Si cela vous amuse, vous pouvez regarder la tête de la constante correspondant à
une fonction primitive récursive f en la substituant à pr_succ ci-dessous. *)
Eval vm_compute in (let (a, _) := ack_pr pr_succ in a).


(* On conclut donc qu'Ackerman n'est pas primitive récursive. *)
Lemma ackdiag_not_pr : forall f : primrec ℕ ℕ, ~ forall n, ⟦f⟧ n = ack n n.
  intros f H.
  destruct (ack_pr f) as [k ?].
  simpl in *.
  specialize (l (S k)).  
  rewrite H in l.
  assert (ack k (S k) < ack (S k) (S k)) by (apply ack_sc_n; lia).
  lia.
Qed.

Lemma ack_not_pr : forall f : primrec (ℕ × ℕ) ℕ, ~ forall n m, ⟦f⟧ (n,m) = ack n m.
  intros ? ?.
  apply (ackdiag_not_pr (f ∘ ⟨ pr_id , pr_id ⟩)).
  intros; apply H.
Qed.
