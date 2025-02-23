import java.lang.Comparable;
import java.util.*;


enum Op { Plus, Minus, Times, Div}

class ArithmeticExpression implements Comparable<ArithmeticExpression> {


  private final ArithmeticExpression subLeft;  // the left subexpression
  private final ArithmeticExpression subRight; // the right subexpression
  private final Op op; // the top-level operator

  private final int val; // the integer value; only useful if this is a leaf

  private final int hashCode; // the hash of the object

  private ArithmeticExpression(int i)
  {
    subLeft = subRight = null;
    op = null;
    val = i;
    hashCode = scramble(i);
  }

  private ArithmeticExpression(ArithmeticExpression l, Op iop, ArithmeticExpression r)
  {
    subLeft = l;
    subRight = r;
    op = iop;
    val = 0;
    int opint = 8392;
    switch(op)
    {
      case Plus:
        opint = 0;
        break;
      case Minus:
        opint = 1;
        break;
      case Times:
        opint = 2;
        break;
      case Div:
        opint = 3;
        break;
    }
    hashCode = pair(l.hashCode, pair(opint, r.hashCode));
  }

  private int pair(int x, int y)
  {
    return scramble((y + (x + y) * (x + y + 1))/2);
  }

  private int scramble(int x)
  {
    //taken from https://stackoverflow.com/questions/664014/what-integer-hash-function-are-good-that-accepts-an-integer-hash-key
    x = ((x >> 16) ^ x) * 0x45d9f3b;
    x = ((x >> 16) ^ x) * 0x45d9f3b;
    x = (x >> 16) ^ x;
    return x;
  }

  public boolean equals(ArithmeticExpression e)
  {
    if(hashCode() != e.hashCode())
      return false;
    if(op == null)
      return e.op == null && val == e.val;
    else
      return e.op == op && subLeft.equals(e.subLeft) && subRight.equals(e.subRight);
  }

  private static int compareOp(Op o, Op oo)
  {
    switch(o)
    {
      case Plus:
        return (oo == Op.Plus) ? 0 : 1;
      case Times:
        switch(oo)
        {
          case Plus:
            return -1;
          case Times:
            return 0;
          default:
            return 1;
        }
      case Minus:
        switch(oo)
        {
          case Minus:
            return 0;
          case Div:
            return 1;
          default:
            return -1;
        }
      case Div:
        return (oo == Op.Div) ? 0 : -1;
    }
    return 111;
  }

  public int compareTo(ArithmeticExpression e)
  {
    if(hashCode() != e.hashCode())
      return (hashCode() < e.hashCode()) ? 1 : -1;
    if(op == null)
      return (e.op == null) ? 0 : 1; 
    if(e.op == null)
      return -1;
    int os = compareOp(op, e.op);
    if(os != 0)
      return os;
    int ls = subLeft.compareTo(e.subLeft);
    if(ls != 0)
      return ls;
    return subRight.compareTo(e.subRight);
  }

  public int hashCode()
  {
    return hashCode;
  }

  private static String paren(String s)
  {
    return "(" + s + ")";
  }

  public String toString()
  {
    if(op == null)
      return "" + val;
    String res = "";
    res += paren(subLeft.toString());
    switch(op)
    {
      case Plus:
        res += " + ";
        break;
      case Minus:
        res += " - ";
        break;
      case Times:
        res += " * ";
        break;
      case Div:
        res += " / ";
        break;
    }
    res += paren(subRight.toString());
    return res;
  }

}

class CountdownSol {

  // A hash table meant to map a list of numbers to all possible arithmetic
  // expressions that can be generated from it
  static Hashtable<LinkedList<Integer>,TreeSet<ArithmeticExpression>>
      memoAllExpressions = new Hashtable<LinkedList<Integer>,TreeSet<ArithmeticExpression>>();


  public static ArithmeticExpression countdown(LinkedList<Integer> numbers, int goal)
  { 
    // your code goes here
    return null;
  }

  public static LinkedList<LinkedList<Integer>> allSplits(LinkedList<Integer> xs)
  {
    LinkedList<LinkedList<Integer>> res = new LinkedList<LinkedList<Integer>>();
    if(xs.size() == 2)
    {
      LinkedList<Integer> xsc = new LinkedList<Integer>(xs);
      LinkedList<Integer> e0 = new LinkedList<Integer>();
      LinkedList<Integer> e1 = new LinkedList<Integer>();
      e0.push(xsc.pop());
      e1.push(xsc.pop());
      res.push(e0);
      res.push(e1);
    } 
    else if(xs.size() > 2)
    {
      int k = xs.pop();
      LinkedList<LinkedList<Integer>> yss = allSplits(xs);
      while(!yss.isEmpty())
      {
        LinkedList<Integer> ys0 = yss.pop();
        LinkedList<Integer> ys1 = yss.pop();
        LinkedList<Integer> ys0copy = new LinkedList<Integer>(ys0);
        LinkedList<Integer> ys1copy = new LinkedList<Integer>(ys1);
        ys0.push(k);
        ys1copy.push(k);
        res.push(ys0);
        res.push(ys1);
        res.push(ys0copy);
        res.push(ys1copy);
      }
      xs.push(k);
    }
    return res;
  }

  public static void playCountdown(LinkedList<Integer> countdowninstance, int goal)
  {
    ArithmeticExpression sol = countdown(countdowninstance, goal);
    if(sol == null)
      System.out.println("it is not possible to reach " + goal + " using " + countdowninstance);
    else
    {
      System.out.println(goal + " can be reached using " + countdowninstance);
      System.out.println("Here is the an arithmetic expression witnessing that\n");
      System.out.println(sol);   
    }
  }

  public static void main(String[] arr)
  {
    LinkedList<Integer> xs = new LinkedList<Integer>();
    for(int i = 0; i < 6; ++i)
      xs.push(i);
    System.out.println(xs);
    System.out.println(allSplits(xs));

    LinkedList<Integer> countdowninstance = new LinkedList<Integer>();
    countdowninstance.push(5);
    countdowninstance.push(5);
    countdowninstance.push(4);
    countdowninstance.push(3);
    countdowninstance.push(2);

    playCountdown(countdowninstance, 6);

    playCountdown(xs, 876);
  }
}
