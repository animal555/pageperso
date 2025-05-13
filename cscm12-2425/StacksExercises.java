import java.util.*;

// java contains a standard Stack interface, which is documented at e.g.
// https://docs.oracle.com/en/java/javase/18/docs/api/java.base/java/util/Stack.html
//
// We are declaring our own here for pedagogical purposes


interface MyStackMinimal<T> {
  T pop();           // Remove an element on top of the stack
  void push(T e);    // Add element on top of the stack
}

interface MyStack<T> extends MyStackMinimal<T> {
  T peek();   // Looks at the topmost element without removing it
  boolean isEmpty(); // Is the stack empty?
  int size(); // What is the size of the stack currently?
}


class MyArrayStackInt implements MyStackMinimal<Integer> {
// Question 1: delete the line above, uncomment the ine below, and implement
// the missing methods
// class MyArrayStackInt implements MyStack<Integer> {

  private int[] stack;
  private int size = 0;

  public MyArrayStackInt(int capacity)
  {
     stack = new int[capacity];
  }

  public Integer pop()
  {
    if(size == 0)
      throw new EmptyStackException();
    size--;
    return stack[size];
  }

  public void push(Integer e)
  {
    stack[size] = e;
    size++;
  }

  public int size()
  {
    return size;
  }
}

class StacksExercises {

  // Recall the following algorithmic problem presented during the lecture:
  //   Input: an array of integers arr
  //   Output: an array of integers span such that span[j] contains the
  //   maximal integer i such that arr[j-i+1] ... arr[j-1] arr[j] be all
  //   <= arr[j]
  //
  // Here to show how to use a stack, I reproduce the code we had; the stack
  // is passed as an argument and assumed to be empty
  static int[] lookbackProblem(int[] arr, MyStack<Integer> emptyStack)
  {
    final MyStack<Integer> stack = emptyStack;
    final int n = arr.length;
    final int[] span = new int[n];
    for(int i = 0; i < n; ++i)
    {
      boolean done = false;
      while(!stack.isEmpty() && !done)
      {
        if(arr[stack.peek()] <= arr[i])
          stack.pop();
        else
          done = true;
      }
      int h;
      if(stack.isEmpty())
        h = -1;
      else
        h = stack.peek();
      span[i] = i - h;
      stack.push(i);
    }
    return span;
  }

  public static void main(String[] args)
  {
    int[] testIn = {5,3,564,645,2,32,15,23,54,2,43,5,3}; 
    System.out.println("Input: " + Arrays.toString(testIn));
    // MyArrayStackInt t = new MyArrayStackInt(50);
    // int[] testOut = lookbackProblem(testIn);
    // System.out.println("Output: " + Arrays.toString(testOut));
  }
}
