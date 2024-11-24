import java.util.*; // Imported just so that we can use the constructor with
                    // ArrayList and Collections, but you should not be using
                    // stuff from that yourself outside of the main function

// This is the main class that we use for testing and global functions.
//
// Deciding what good tests to write is left up to you, but you should display
// something for each of the operation you implement
class ListExercises {
  public static void main(String[] args)
  {
    // Your code goes there
  }
}

// Representation of an internal node of the doubly-linked list; do not
// modify
class Node<T> {
  public Node<T> prev;
  public T val;
  public Node<T> next;
}


// This is the main class that we are going to be implementing today.
//
// The idea is that this should ultimately implements doubly-linked lists
// with pointers at the front and the back in a principled way, as alluded
// to in the lecture.
//
// Internally, essentially three kind of representations should be allowed:
// * either first = last = null and we consider the list empty
// * or we have first.prev = last.next = null and for every other node n
//   accessible from first and last, we should have
//     n.next.prev = n = n.prev.next
//   Furthermore, we should be able to reach last from first by taking
//   first.next. ... . next a certain number of times.
//   Note that in the particular case where we have a single element, we
//   have first = last; otherwise, first != last
// 
// All of your functions should preserve those invariants.
//
// Some of the code is provided; you don't necessarily need to read/understand
// all of it, some things are just there for convenience like toString, but
// feel free to take some inspiration from it
class DLList<T> {
  Node<T> first;
  Node<T> last;
  // int length;  // attribute to add and handle properlly for question 2
                  // the appropriate code snippets in the templates are commented
                  // out and should be uncommented when you start that question

  // Constructor that generates an empty list
  public DLList()
  {
    // length = 0;
    first = null;
    last  = null;
  }

  // Constructor that generates a list with a single element
  public DLList(T e)
  {
    // length = 1;
    first = new Node<T>();
    first.val = e;
    last = first;
  }

  // Constructor that generates a list with two elements
  public DLList(T e, T e2)
  {
    // length = 2;
    first = new Node<T>();
    first.val = e;
    last = new Node<T>();
    last.val = e;
    first.next = last;
    last.prev = first;
  }

  // Constructor able to convert an ArrayList to a DLList (will only work
  // once you have implemented push_back)
  public DLList(Collection<? extends T> c)
  {
    first = null;
    last  = null;
    for(var x : c)
      push_back(x);
    // length = c.size();
  }

  // Method that allows to display a DLList; use liberally to test your
  // functions!
  public String toString()
  {
    String res = "[";
    Node<T> it = first;
    if(it != null)
    {
      res += it.val;
      it = it.next;
      while(it != null)
      {
        res += ", " + it.val;
        it = it.next;
      }
    }
    return res + "]";
  }

  // Auxiliary function for the wellFormed method 
  private static <T>boolean locallyWellFormed(Node<T> n)
  {
    if(n != null)
    {
      if(n.next != null)
        if(n.next.prev != n)
          return false;
      if(n.prev != null)
        if(n.prev.next != n)
          return false;
    }
    return true;
  }

  // Checks whether a DLList represents a doubly-linked list with no cycles
  // and where the forward and backward pointers are internally consistent
  //
  // (it will not check if the length attribute is consistent for question 2)
  public boolean wellFormed()
  {
    if(first == null && last != null || first != null && last == null)
      return false;
    if(first == last)
      return true;
    if(first != null)
    {
      if(first.prev != null || last.next != null || !locallyWellFormed(first))
        return false;
      for(Node<T> it = first.next; it != last; it = it.next)
      {
        if(it == first || it == null || !locallyWellFormed(it))
          return false;
      }
      return true;
    }
    return true;
  }

  // BEGIN QUESTION 1


  // write a function that takes an element x and add it at the end of the
  // list. This should work in O(1)
  public void push_back(T x)
  {
     // Your code goes here
  }

  // write a function that takes an element x and add it at the front of the
  // list. This should work in O(1)
  public void push_front(T x)
  {
     // Your code goes here
  }

  // write a function that removes the first element of a list, and returns the
  // corresponding value
  public T pop_front()
  {
    // Your code goes here (remove the next line as well once you're done!)
    return null;
  }

  // write a function that takes another list and produces the concatenation
  // (the concatenation of [1,2] and [3,4,7] is [1,2,3,4,7])
  // You should have constant-time complexity
  public void concatenate(DLList<T> xs)
  {
     // Your code goes here
  }

  // BEGIN QUESTION 2
  //
  // At this stage, you should first uncomment the length attribute and adapt
  // the previous functions so that length keeps track correctly of the actual
  // length of the list

  // write a function that returns the size of the list
  // It should run in O(1) once you add the length attribute (otherwise,
  // this would be linear time)
  public int size()
  {
    // Your code goes here
    return -1;
  }


  // Hint: for the next two functions, it might be useful to have an auxiliary
  // private method Node<T> getCell(int i) that returns the ith cell in the
  // list. This is not *necessary*, but feel free to do so to avoid code
  // duplication :)

  // write a function that reads the ith value in the list.
  // It should run in O(min(i, length - i)) ideally, but O(i) is also
  // acceptable
  public T get(int i)
  {
    // Your code goes here
    return null;
  }

  // write a function that inserts a value at the ith spot in the list
  // It should run in O(min(i, length - i)) ideally, but O(i) is also
  // acceptable
  public void insertAt(int idx, T x)
  {
    // Your code goes here
  }


  // BEGIN QUESTION 3

  // write a function that splits the list in half; it should return
  // the second half that you get by spitting, while the first half should
  // correspond to the old reference to the list
  //
  // For instance, if
  //   xs = [1,2,3,4]
  // after the line ys = xs.splitInHalf(), we should have
  //   xs = [1,2] and ys = [3, 4]
  //
  // This should run in linear time
  public DLList<T> splitInHalf()
  {
    // Your code goes there
    return null;
  }

  // For the next two functions, we are going to use the Comparator interface
  // to pass around a function that will allow to compare two arguments of type
  // T (we can't just use <, as T might not be an integer). It is defined just
  // after the current class, so you can take a peek. What this will mean
  // essentially is that instead of write x < y for integers x and y, you
  // will need to write cmp.apply(x,y) for elements of T in the code below.
  //
  // write a function that takes additionally as input another list, and,
  // assuming that the current list and that additional argument are sorted,
  // inserts all of the elements of the other lists in the current one, so
  // that the overall thing is sorted (according to cmp)
  //
  // For instance, if
  //   xs = [1,2,7,10] and ys = [0, 5, 8]
  // after the line xs.mergeIn((x,y) -> x < y, ys), we should have
  //   xs = [0,1,2,5,7,8,10] (and whatever for ys, it can even be garbage)
  public void mergeIn(Comparator<T> cmp, DLList<T> other)
  {
    // Your code goes there
  }

  // Deduce a method mergeSort that works in linear space complexity and
  // O(nlog(n))
  public void mergeSort(Comparator<T> cmp)
  {
    // Your code goes here
  }
}

interface Comparator<T> {
  public boolean apply(T x, T y);
}


// BEGIN QUESTION 4
class DLListIterator<T> implements ListIterator<T> {
  // Suggested attributes for this class; but feel free to modify that if you
  // wish
  Node<T> prevState;
  Node<T> state;
  int pos;

  public DLListIterator(DLList<T> xs)
  {
    // Your code goes here
  }

  public boolean hasNext()
  {
    // Your code goes here
    return false;
  }

  public boolean hasPrevious()
  {
    // Your code goes here
    return false;
  }

  public void add(T x)
  {
    // Your code goes here
  }

  public void set(T x)
  {
    // Your code goes here
    // too lazy to do it right now
  }

  public void remove()
  {
    // Your code goes here
    // too lazy to do it right now
  }

  public int previousIndex()
  {
    // Your code goes here
    return 0;
  }

  public int nextIndex()
  {
    // Your code goes here
    return 0;
  }

  public T next()
  {
    // Suggested solution with the attributes I gave
    prevState = state;
    state = state.next;
    return prevState.val;
  }

  public T previous()
  {
    // Your code goes here
    return null;
  }
}
