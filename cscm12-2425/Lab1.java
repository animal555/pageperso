import java.util.*;
import java.util.function.*;
import java.io.*;


/* This file is provided for you to play around with a few function and to show
 * you how you may make crude time measurements during the execution of a java
 * program.
 * For today, we will simply try to look at a few examples of functions that
 * return the same result, but do not have the same time complexity.
 *
 * Please note that this is a rather crude setup to make time measurements/test
 * functions. If you need to make precise benchmarking in the future, I would
 * encourage you to do your research on what pitfalls you may encounter and
 * use a dedicated external library (we don't here to minimize the issues you
 * may have running this on e.g. the lab machines).
 *
 * (among the pitfalls: over any given span of time, there are usually several
 * programs running concurrently on your computer. Therefore, should you include
 * or exclude the time your computer spend on other tasks? (if you use a UNIX
 * system, this is very apparent when you use the "time" program to measure
 * the time a given command takes to execute: you are given both the cpu time
 * and the real time of execution...))
*/

class Lab1{

  // Some global constants that are related to the function that will allow
  // us to measure the efficiency of other functions.
  // MAX_SIZE will be the maximal input size we shall consider for our measurements.
  static final int MAX_SIZE = 600;
  static final int TEST_STEP = 10;
  static final long TEST_TIME = 50000000; // 0.01s

  static int[] a = new int[MAX_SIZE];
  
  // A function that counts the number of duplicate entries in a prefix of the
  // array a, whose length is given in the argument. You should provide the code
  // for this
  static int countDup1(int n)
  {
    // your code goes here
    return -1;
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
      if(myA.get(i) == initE)
        cc++;
      else
      {
        count += (cc * (cc - 1)) / 2;
        cc = 0;
        initE = myA.get(i);
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

  // This is a function that essentially tests if f(i) takes a long time to
  // execute
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

  /* Now that we have defined the function to be tested, we set up some global
   * tables that will contain our time measurements, as well as helper functions
   * to set them up. The ALL_NAMES table contains names for tests, and
   * ALL_VALUES contains the measurements. */

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

  // A helper function that tests a function and add the results to the tables
  static void addToTests(String name, Function<Integer, Integer> f)
  {
    var t = time(f);
    ALL_NAMES.add(name);
    ALL_VALUES.add(t);
  }

  /* A function that outputs the current table to a spreadsheet in CSV format
   * (most spreadsheet software, including excel, can read those). The argument
   * is the filename that you want for the output.
   * WARNING: if the file already exists, it will overwrite it! */
  static void outputCSV(String fileName) throws IOException
  {
    adjustFirstCol();
    FileWriter w = new FileWriter(fileName, false);
    final int n = ALL_NAMES.size();
    for(int i = 0; i < n; ++i)
    {
      w.write(ALL_NAMES.get(i) + ",");
      for(var z : ALL_VALUES.get(i))
        w.write(z.toString() + ",");
      w.write("\n");
    }
    w.close();
  }

  /* A function that should be called in main that will both set up the global
   * array for tests and the tables for the measures. */
  static void setup()
  {
    setupTests();
    for(int i = 0; i < MAX_SIZE; ++i)
      a[i] = (int)Math.random();
  }

  public static void main(String[] argc)
  {
    setup();
    addToTests("CountDup2", n -> countDup2(n));
    addToTests("CountDup3", n -> countDup3(n));
    addToTests("CountDup4", n -> countDup4(n));
    try {
      outputCSV("Lab1.csv");
    }
    catch(IOException e) {
      System.out.println("Something went wrong when writing the csv file");
    }
 }
}
