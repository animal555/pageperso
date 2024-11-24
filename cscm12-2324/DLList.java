class DLList<T> {

  public Node<T> first;
  public Node<T> last;
  public int length;

  public int size()
  {
    return length;
  }

  // Constructor that generates an empty list
  public DLList()
  {
    length = 0;
    first = null;
    last  = null;
  }

  // Constructor that generates a list with a single element
  public DLList(T e)
  {
    length = 1;
    first = new Node<T>();
    first.val = e;
    last = first;
  }

  // Constructor that generates a list with two elements
  public DLList(T e, T e2)
  {
    length = 2;
    first = new Node<T>();
    first.val = e;
    last = new Node<T>();
    last.val = e2;
    first.next = last;
    last.prev = first;
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

  // QUESTION 1
  public void push_back(T x)
  {
     // Your code goes here
  }

  // QUESTION 2
  public void push_front(T x)
  {
     // Your code goes here
  }

  // QUESTION 3
  public T pop_front()
  {
    // Your code goes here
    // The next line should be replaced by something sensible once you're done!
    return null;
  }

  // QUESTION 4
  public void concatenate(DLList<T> xs)
  {
     // Your code goes here
  }

  // QUESTION 5
  public T get(int idx)
  {
    // Your code goes here
    // The next line should be replaced by something sensible once you're done!
    return null;
  }

  // QUESTION 6
  public void insertAt(int idx, T x)
  {
    // Your code goes here
  }

  // QUESTION 7
  public void reverse()
  {
    // Your code goes here
  }
}
