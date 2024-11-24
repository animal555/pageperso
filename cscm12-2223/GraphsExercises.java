import java.util.*;
import java.util.function.*;
import java.io.*;

class GraphsExercises {

  public static void main(String[] args)
  {
  }

  // Question 2
  public static int[][] allDistances(int[][] graph)
  {
    final int n = graph.length;
    final int[][] res = new int[n][n];

    // your code goes here

    return res;
  }
}

class Graph {

  ArrayList<LinkedList<Integer>> adjSucc;
  ArrayList<LinkedList<Integer>> adjPred;

  public Graph(boolean[][] adjM)
  {
    // Your code goes here
  }

  public boolean[][] toMatrix()
  {
    final int n = adjSucc.size();
    boolean[][] res = new boolean[n][n];
    // Your code goes here
    return res;
  }


  public LinkedList<Integer> toListDFS(int i)
  {
    LinkedList<Integer> res = new LinkedList<Integer>();
    // Your code goes here
    return res;
  }


  public int[] allDistancesFrom(int source)
  {
    final int n = size();
    final int dist[] = new int[n];
    for(int i = 0; i < n; ++i)
      dist[i] = -1;

    // Your code goes here

    return dist;
  }

  // From this point on, the methods are provided for your convenience/for you
  // to read if you wish
  public int size()
  {
    return adjSucc.size();
  }

  public void addVertex()
  {
    adjSucc.add(new LinkedList<Integer>());
    adjPred.add(new LinkedList<Integer>());
  }

  public void addEdge(int i, int j)
  {
    if(!adjSucc.get(i).contains(j))
    {
      adjSucc.get(i).add(j);
      adjPred.get(j).add(i);
    }
  }

  public boolean hasEdge(int i, int j)
  {
    return adjSucc.get(i).contains(j);
  }

  public LinkedList<Integer> successors(int i)
  {
    return new LinkedList<Integer>(adjSucc.get(i));
  }

  public LinkedList<Integer> predecessors(int i)
  {
    return new LinkedList<Integer>(adjPred.get(i));
  }

  // Outputs the nodes connected to i, using a BFS
  public LinkedList<Integer> toListBFS(int i)
  {
    final int n = size();
    final boolean marked[] = new boolean[n];
    final LinkedList<Integer> q = new LinkedList<Integer>();
    final LinkedList<Integer> res = new LinkedList<Integer>();
    q.add(i);
    while(!q.isEmpty())
    {
      final int curr = q.pollLast();
      if(!marked[curr])
      {
        marked[curr] = true;
        res.add(curr);
        for(final int j : adjSucc.get(curr))
          q.add(j);
      }
    }
    return res;
  }

  // This methods checks if adjSucc and adjPred are consistent, i.e., that
  // if adjSucc.get(i) contains j if and only if adjPred.get(j) contains i
  //
  // This should always return true; if you suspect you have a bug somewhere,
  // use that to double-check your graph is indeed a graph
  public boolean isConsistent()
  {
    final int n = adjSucc.size();
    for(int i = 0; i < n; ++i)
    {
      for(int j : adjSucc.get(i))
        if(!adjPred.get(j).contains(i))
          return false;
      for(int j : adjPred.get(i))
        if(!adjSucc.get(j).contains(i))
          return false;
    }
    return true;
  }


  // Writes the graph to a dot file, that can easily be pretty-printed by
  // graphviz
  public void toDotFile(String s) throws Exception
  {
    File dotFile = new File(s + ".dot");
    dotFile.delete();
    dotFile.createNewFile();
    FileWriter w = new FileWriter(dotFile);
    w.write("digraph {\n");
    final int n = adjSucc.size();
    for(int i = 0; i < n; ++i)
      for(int j : adjSucc.get(i))
        w.write("  " + i + " -> " + j + ";\n");
    w.write("}");
    w.close();
  }

  // A useful constructor that converts a predicate to a graph; the first
  // parameter is the number of vertices, the predicates says if there is an
  // edge or not (it is handy to do e.g. random generation of graphs to test
  // examples :))
  public Graph(int size, Function<Integer,Function<Integer, Boolean>> gen)
  {
    final int n = size;
    adjSucc = new ArrayList<LinkedList<Integer>>(n);
    for(int i = 0; i < n; ++i)
      adjSucc.add(new LinkedList<Integer>());
    adjPred = new ArrayList<LinkedList<Integer>>(n);
    for(int i = 0; i < n; ++i)
      adjPred.add(new LinkedList<Integer>());
    for(int i = 0; i < n; ++i)
       for(int j = 0; j < n; ++j)
         if(gen.apply(i).apply(j))
         {
           adjSucc.get(i).add(j);
           adjPred.get(j).add(i);
         }
  }
}
