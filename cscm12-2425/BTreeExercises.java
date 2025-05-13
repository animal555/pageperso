import java.util.*;
import java.util.function.*;


class BTreeExercises {

  public static void main(String[] args)
  {
    BTree<Integer> example1 =
      new BTree<Integer>(
       new BTree<Integer>(
        new BTree<Integer>(15),
        -2,
        new BTree<Integer>(7)
        ),
       5,
       null
      );
    System.out.println("First example: " + example1.toString());
    BTree<Integer> example2 =
      new BTree<Integer>(
         example1, 55,
         new BTree<Integer>(
         example1,
         7,
         null
         )
      );
    System.out.println("Second example: " + example2.toString());
  }
}


class BTree<T> {

  public T label;
  public BTree<T> left;
  public BTree<T> right;

  public BTree(BTree<T> l, T x, BTree<T> r)
  {
    label = x;
    left  = l;
    right = r;
  }

  public BTree(T x)
  {
    label = x;
    left = null;
    right = null;
  }

  // count the number of nodes
  public int size()
  {
    int res = 1;
    if(left != null)
      res += left.size();
    if(right != null)
      res += right.size();
    return res;
  }

  // compute the depth of the tree, i.e., the maximal distance from the root to
  // the leaf
  public int depth()
  {
    // remove the next line, write your code here
    return 0;
  }

  public String toString()
  {
    String res = "";
    if(left != null)
      res += "(" + left.toString() + ") ";

    res += label.toString();

    if(right != null)
      res += " (" + right.toString() + ")";

    return res;
  }

  // Check if two structures without cycles unfold to the same tree
  //   (this is needed for a reason similar as for String; even if two
  //    String objects are equal, they may be stored in different spots in
  //    memory, so we can't use ==)
  public boolean equals(BTree<T> otherTree)
  {
    // remove the next line and put your code there
    return false;
  }

  // collect the labels in the tree in the prefix order
  //
  public ArrayList<T> prefixTraversal()
  {
     // remove the next line, write your code here
     return new ArrayList<T>();
  }

  // Convert an array to a tree; in particular, we should have that
  //   5, 2, 2, null, 4
  // gets converted to the tree represented by
  //   (2 (4)) 5 (2)
  static public <T> BTree<T> of(ArrayList<T> arr)
  {
    // remove the next line, write your code here
    return null;
  }

  // Challenge task: write a function that takes as input a function object,
  // and outputs a tree with the same tree-life structures but where all labels
  // are relabelled by x
  //
  // For instance, example1.map(x -> Integer(x + 2).toString() + "X").toString()
  // should yield
  //
  // "((17X) 0X (7X)) 5X"
  public <U> BTree<U> map(Function<T, U> f)
  {
    // remove the next line, write your code here
    return null;
  }


  // Challenge task: write a function that converts a string to a tree, with
  // the intent that 
  static public BTree<Integer> of(String s)
  {
    // remove the next line, write your code here
    return null;
  }


  // This function checks if the structure has a cycle
  public boolean hasCycle()
  {
    ArrayList<BTree<T>> above = new ArrayList<BTree<T>>();
    ArrayList<BTree<T>> onTheLeft = new ArrayList<BTree<T>>();
    return checkCycleSharingInner(above, onTheLeft) % 2 == 1;
  }

  // This function checks if there is some sharing in the tree but no cycles
  public boolean hasSharingButNoCycles()
  {
    ArrayList<BTree<T>> above = new ArrayList<BTree<T>>();
    ArrayList<BTree<T>> onTheLeft = new ArrayList<BTree<T>>();
    int m = checkCycleSharingInner(above, onTheLeft);
    return m == 2;
  }

  // Auxiliary functions for the two functions above
  // The first argument lists all of the trees above the tree in the structure
  // under scrutiny, the other the trees at the same level or below on the left,
  // but are not descendants.
  //
  // The output is an integer <= 2; the first bit is 1 iff if a cyle has
  // been detected, and the second is one iff if some horizontal sharing has
  // been detected
  protected int checkCycleSharingInner(ArrayList<BTree<T>> above,
      ArrayList<BTree<T>> onTheLeft)
  {
    int res = above.contains(this) ? 1 : 0;
    if(onTheLeft.contains(this))
      res |= 2;
    if(res % 2 == 1)
      return res;

    above.add(this);
    if(left != null)
      res |= left.checkCycleSharingInner(above, onTheLeft);
    if(right != null)
      res |= right.checkCycleSharingInner(above, onTheLeft);

    above.remove(this);
    onTheLeft.add(this);

    return res;
  }

  // Challenge task: change the structure to remove sharing while representing
  // the same underlying tree
  public void unshareSubtrees()
  {
    // Your code goes there
  }
}

class BST {

  // Here we work under the assumption we have a binary search tree
  //
  // That is, we have a binary with nodes labels by integers, and at every
  // node n, then all the labels in n.left are smaller than n.label and
  // all the labels in n.right are in n.right
  protected BTree<Integer> tree;

  public BST(int x)
  {
    tree = new BTree<Integer>(x);
  }

  // Check if the key is somewhere in tree
  public boolean lookup(int k)
  {
    BTree<Integer> curr = tree;
    while(curr != null)
    {
      if(k == curr.label)
        return true;
      else if(k < curr.label)
        curr = curr.left;
      else
        curr = curr.right;
    }
    return false;
  }

  public String toString()
  {
     return tree.toString();
  }

  // Insert a new key, preserving the BST invariant
  public void insert(int k)
  {
    // Put your code here
  }

  // Delete one occurence of k, preserving the BST invariant
  public void delete(int k)
  {
    // Put your code here
  }
}
