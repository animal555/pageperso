import java.util.*;
import java.util.function.*;
import java.io.*;


class Lab1{


  static int exp1(int n)
  {
    int r = 1;
    for(int i = 0; i < n; ++i)
      r *= 2;
    return r;
  }

  static int exp2(int n)
  {
    int r = 1;
    for(int i = 0; i < n; ++i)
    {
      int k = 0;
      for(int j = 0; j < r; ++j)
        k += 2;
      r = k;
    }
    return r;
  }

  static int exp3(int n)
  {
    if(n == 0)
      return 1;
    int r = exp3(n / 2);
    return (n % 2 == 0) ? r * r : r * r * 2;
  }

  static int f1(int n)
  {
    int r = 52;
    for(int i = 0; i < n; ++i)
      for(int j = 0; j < i; ++j)
        for(int k = 0; k < n; ++k)
          r = r * i + j - k % 42;
    return r;
  }


  static int f2(int n)
  {
    int r = 52;
    for(int i = 0; i < n; ++i)
      for(int j = 0; j < i; ++j)
          r = r * i + j % 42;

   for(int i = 0; i < n; ++i)
      for(int j = 0; j < i; ++j)
          r = r * i - j % 42;
    return r;
  }

  static int f3(int n)
  {
    int r = 52;
    for(int i = 0; i < 5 * n; ++i)
      r *= i + r - 2 % 85;
    return r;
  }


  static final int MAX_SIZE = 300;
  static final int TEST_STEP = 10;
  static final long TEST_TIME = 10000000; // 0.01s




  static int[] a = new int[MAX_SIZE];
  
  // A function that counts the number of duplicate entries in a prefix of the
  // array a, whose length is given in the argument
  static int countDup1(int n)
  {
    int count = 0;
    for(int i = 0; i < n; ++i)
      for(int j = i + 1; j < n; ++j)
        if(a[i] == a[j])
          count++;
    return count;
  }

  // Now we give several other implementations of the same functionality; the
  // goal of the lab exercise will be to benchmark them in order to compare
  // their efficiency

  static int countDup2(int n)
  {
    int count = 0;
    for(int i = 0; i < n; ++i)
    {
       int localCount = 0;
       for(int j = 0; j < i; ++j)
         if(a[i] == a[j])
           localCount++;
       if(localCount == 0)
         for(int j = i + 1; j < n; ++j)
           if(a[i] == a[j])
             localCount++;
       count = (localCount * (localCount + 1)) / 2;

    }
    return count;
  }

  static int countDup3(int n)
  {
    if(n == 0)
      return 0;
    ArrayList<Integer> myA = new ArrayList<Integer>();
    for(int i = 0; i < n; ++i)
      myA.add(a[i]);
    myA.sort(null);
    int count = 0;
    int cc = 1;
    int initE = a[0];
    for(int i = 1; i < n; ++i)
    {
      if(a[i] == initE)
        cc++;
      else
      {
        count += (cc * (cc - 1)) / 2;
        cc = 0;
      }
    }
    count += (cc * (cc - 1)) / 2;
    return count;
  }

  static int countDup4(int n)
  {
    int r = 0;
    for(int k = 1; k < n; ++k)
    {
      int c = 0;
      for(int i = 0; i < n; ++i)
      {
        int l = 0;
        for(int j = 0; j < n && l <= k; ++j)
         if(a[i] == a[j])
            l++;
        if(l == k)
          c++;
      }
      r += c / k;
    }
    return r;
  }


  static boolean timeOut(Function<Integer, Integer> f, int i)
  {
      final long startTime = System.nanoTime();
      f.apply(i);
      return System.nanoTime() - startTime > TEST_TIME / 10;
  }

  // takes an object f representing a int -> int function as argument and returns
  // an ArrayList containing timing information. The cell i should contain the
  // time of a single call of f on i * TEST_STEP in nanoseconds on average (or
  // rather a rough approximation thereof).
  static ArrayList<Integer> time(Function<Integer,Integer> f)
  {
    ArrayList<Integer> res = new ArrayList<Integer>();
    for(int testSize = 0; testSize <= MAX_SIZE; testSize += TEST_STEP)
    {
      if(timeOut(f, testSize))
        break;
      final long startTime = System.nanoTime();
      long currentTime = startTime;
      long count = 0;
      while(currentTime - startTime <= TEST_TIME)
      {
        f.apply(testSize);
        count++;
        currentTime = System.nanoTime();
      }
      res.add((int)((currentTime - startTime) / count));
    }
    return res;
  }

  static final ArrayList<String> ALL_NAMES = new ArrayList<String>();
  static final ArrayList<ArrayList<Integer>> ALL_VALUES = new ArrayList<ArrayList<Integer>>();

  static void setupTests()
  {
    ALL_NAMES.add("size");
    ALL_VALUES.add(new ArrayList<Integer>());
  }

  static void adjustFirstCol()
  {
    int sizeCol = 0;
    var indexCol = ALL_VALUES.get(0);
    for(var a : ALL_VALUES)
      sizeCol = Math.max(sizeCol, a.size());
    for(int i = indexCol.size(); i < sizeCol; ++i)
      indexCol.add(TEST_STEP * i);
  }

  static void addToTests(String name, Function<Integer, Integer> f)
  {
    var t = time(f);
    ALL_NAMES.add(name);
    ALL_VALUES.add(t);
  }

  static void outputCSV(String fileName) throws IOException
  {
    adjustFirstCol();
    FileWriter w = new FileWriter(fileName, false);
    final int n = ALL_NAMES.size();
    for(int i = 0; i < n; ++i)
    {
      w.write(ALL_NAMES.get(i) + ";");
      for(var z : ALL_VALUES.get(i))
        w.write(z.toString() + ";");
      w.write("\n");
    }
    w.close();
  }

  static void setup()
  {
    setupTests();
    for(int i = 0; i < MAX_SIZE; ++i)
      a[i] = (int)Math.random();
  }

  public static void main(String[] argc)
  {
    setup();
    addToTests("f1", n -> countDup1(n));
    addToTests("f2", n -> countDup2(n));
    addToTests("f3", n -> countDup3(n));
    addToTests("f4", n -> countDup4(n));
    try {
      outputCSV("Lab1.csv");
    }
    catch(IOException e) {
      System.out.println("Something went wrong when writing the csv file");
    }
 }
}
