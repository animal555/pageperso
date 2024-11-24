import java.util.*;
import java.lang.reflect.*;

class Pair<T, U> {
  public T fst;
  public U snd;
  
  static <T, U> Pair<T,U> of(T t, U u)
  {
    Pair<T,U> res =  new Pair<T,U>();
    res.fst = t;
    res.snd = u;
    return res;
  }

  static <T> Pair<T,T> of(T t)
  {
    return of(t,t);
  }
}

interface PriorityQueue<T> {

  void enqueue(T element, int priority);
    // Add an element T with a given priority in the queue
  T dequeue();
    // Remove an element of lowest priority from the queue
  boolean isEmpty();
}

class ListPriorityQueue<T> implements PriorityQueue<T> {
  DLList<Pair<T, Integer>> queue;

  ListPriorityQueue()
  {
    queue = new DLList<Pair<T,Integer>>();
  }

  public void enqueue(T element, int priority)
  {
    // Your code goes here
  }

  public T dequeue()
  {
    // Your code goes here (delete the next line!)
    return null;
  }

  public boolean isEmpty()
  {
    // Your code goes here (delete the next line!)
    return true;
  }
}

class HeapPriorityQueue<T> implements PriorityQueue<T>
{
  private ArrayList<Pair<T,Integer>> heap;
  // This ArrayList is meant to represent implicitly a tree-like structure;
  // we say that a cell i might have two children, 2*i+1 and 2*i+2. The
  // ancestor of a cell j is then obtained by (j-1)/2 (where / is the
  // integer division)
  //
  // This representation is convenient for binary tree structures which are
  // almost complete, such as presented in the handout

  public HeapPriorityQueue(int capacity)
  {
    heap = new ArrayList<Pair<T,Integer>>(capacity);
  }

  public void enqueue(T e, int p)
  {
    heap.add(Pair.of(e,p));
    bubbleUp(heap.size()-1);
  }

  public T dequeue()
  {
    final int n = heap.size();
    // Your code goes here (delete the next line!)
    final T e = heap.get(0).fst;
    final int hole = bubbleDown(0);
    final Pair<T,Integer> node = heap.remove(n-1);
    if(n != 0)
    {
      heap.set(hole, node);
      bubbleUp(hole);
    }
    return e;
  }

  // this is a helper function that is meant to restore the stack structure
  // after an insertion of a fresh element
  //
  // The situation is the following: if we might have a quasi-correct stack
  //
  //          (m, e)
  //        /        \
  //   (ml, el)    (mr, er)
  //    /    \      /    \
  //   ...   ...   ...   ...
  //
  // where we might have that mr > m or ml > m, but where otherwise the stack
  // structure is respected. Here idx is meant to be either the position of
  // (ml, el) or (mr, er) (depending of where the stack structure is disrupted)
  //
  // Re-establishing the stack structure is possible by permuting the values
  // in the nodes; for instance, if mr > m, by going to
  //          (mr, er)
  //        /        \
  //   (ml, el)     (m, e)
  //    /    \      /    \
  //   ...   ...   ...   ...
  //
  //  This is a "local fix"
  //
  //  The idea of the function bubbleUp is to start repairing the disruption
  //  where the fresh element might have been inserted, and then, if a swap
  //  occured, check if we have creating a new disruption by swapping; if we
  //  did, we should call bubbleUp recursively at the site of the new disruption
  //  This will terminate in O(log(n)) steps because each recursive calls
  //  goes up in the tree

  private void bubbleUp(int idx)
  {
    // Your code goes here
  }

  // Here the rationale is not too different from bubbleUp, but it is more
  // concerned with deleting a node from a heap
  //
  // Assume we want to delete the topmost element of
  //
  //          [     ]
  //        /        \
  //   (ml, el)    (mr, er)
  //    /    \      /    \
  //   hll   hlr  hrl    hrr
  //
  //  Depending on whether ml or mr, the heap where we delete the root might
  //  be different. Assuming that ml < mr, we might want to have a new heap
  //
  //          (ml, el)
  //        /        \
  //   (mr, er)    [      ]
  //    /    \      /   \
  //  hll    hlr  hrl   hrr
  //
  //  so this suggests making a swap, and then call recursively the function
  //  bubbleDown on a subHeap until you get a hole at a leaf position.
  //  Once again, this will be log(n) since we go down in the heap
  private int bubbleDown(int idx)
  {
    // Your code goes here (delete the next line!)
    return -1;
  }

  public boolean isEmpty()
  {
    // Your code goes here (delete the next line!)
    return true;
  }
}

class PriorityQueuesExercises {


  // The implementation of the generic sorting algorithm based on priority queues
  // (if you want to know how the last argument works, the keyword to look up
  // in java documentation tutorials is "Reflection")
  static <T extends PriorityQueue<Integer>> void sort(int[] arr, Class<T> cls) throws Exception
  {
    final int n = arr.length;
    PriorityQueue<Integer> queue = cls.getDeclaredConstructor().newInstance();
    for(int i = 0; i < n; ++i)
      queue.enqueue(arr[i],arr[i]);
    for(int i = 0; i < n; ++i)
      arr[i] = queue.dequeue();
  }

  static void testRandomStuff(PriorityQueue<Integer> q, int nbOp)
  {
    System.out.println("Testing a priority queue implementation with " + nbOp +
                       " random operations");
    Random rng = new Random();
    for(int i = 0; i < nbOp; ++i)
    {
      final String msg = "Op #" + i + ": ";
      if(q.isEmpty() || rng.nextInt()%2 == 0)
      {
        int priority = rng.nextInt()%10;
        int elt = rng.nextInt()%100;
        System.out.println(msg + "enqueuing " + elt + " with priority " + priority);
        q.enqueue(elt, priority);
      }
      else
      {
        int elt = q.dequeue();
        System.out.println(msg + "dequeuing " + elt);
      }
    }
  }

  static void main(String[] args) throws Exception
  {
    var queue = new ListPriorityQueue<Integer>();
      // change the line above to test your different implementations
    testRandomStuff(queue, 20);
    while(!queue.isEmpty())
      queue.dequeue();

    Random rng = new Random();
    int[] exArray = new int[30];
    System.out.println("Testing the sorting algorithm:");
    for(int i = 0; i < exArray.length; ++i)
      exArray[i] = rng.nextInt() % 500;

    System.out.println("Input: " + Arrays.toString(exArray));
    sort(exArray, queue.getClass());
    System.out.println("Output: " + Arrays.toString(exArray));
  }
}
