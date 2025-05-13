public class MinAndMax
{
   // Input: an array in of Comparables of length ≥ 1
   // Output: a pair of Comparables
   static Pair<Comparable,Comparable> minAndMax(Comparable[] in)
   {
     // Put here your code; you can assume that the input array in
     // has length ≥ 1
     return null;
   }
   
   public static void main(String[] args)
   {
     int[] exVals = {4,86,42,6,4,7,8,9};
     Comparable[] ex = new Comparable[exVals.length];

     for(int i = 0; i < exVals.length; ++i)
       ex[i] = new Comparable(exVals[i]);

     Pair<Comparable,Comparable> res = minAndMax(ex);
 
     System.out.printf("The minimum of %s is %s and the maximum %s.\n",
                       ex.toString(), res.fst.toString(), res.snd.toString());
     System.out.printf("This was computed using %d comparisons.\n",
                       Comparable.nComparisons());
   }
}

// Class of comparable elements; the idea is that you should avoid manipulating
// elements of this class directly as integers, but only use the provided
// compare method; that way the total number of comparisons ran during the
// program will be tallied up in nComparisons, and we will be able to use that
// to compare the efficiency of various algorithms.
//
// (we will have a similar methodology to compare sorting algorithms later on)
class Comparable
{
  static private int nComparisons = 0; // the total number of comparisons made
                                       // in the program
  final private int val;

  Comparable(int x)
  {
    val = x;
  }

  static boolean compare(Comparable x, Comparable y)
  {
    nComparisons++;
    return x.val <= y.val;
  }

  // Please do not use this function to bypass compare!
  public String toString()
  {
    return Integer.toString(val);
  }

  static int nComparisons()
  {
    return nComparisons;
  }
}

// A (family of) classes for objects that can hold pairs of elements,
// parameterized by two classes T and U which are the type of the first and
// second component respectively.
//
// (if you want to look up the java concept for this notion of class
// parameterized by other classes, these are called generics)
class Pair<T,U>
{
  public T fst;
  public U snd;

  Pair(T x, U y)
  {
    fst = x;
    snd = y;
  }
}
