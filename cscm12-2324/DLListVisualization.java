import java.util.*;

/*
 * Below is the code I am using to visualize object of the class DLList and
 * out put graph descriptions of the structure in autograder.
 *
 * Looking at this file is not *necessary* to complete the coursework, but
 * might be helpful to write some tests of your own :)
*/


class DLListVisualization {

  public static <T> String nodeToString(Node<T> n)
  {
    return (n == null) ? "null" : ((n.val == null) ? "null" : n.val) + " (" + n.toString() + ")";
  }

  public static <T> String nodeValToString(Node<T> n)
  {
    return (n == null) ? "null" : ((n.val == null) ? "null" : n.val.toString());
  } 

  public static <T> String toDot(DLList<T> xs)
  {
    StringBuilder res = new StringBuilder();
    res.append("digraph {\n  rankdir=LR;\n");
    if(xs.first != null)
      res.append("  \"first\" -> \"" + nodeToString(xs.first)
               +"\"[color=green];\n");
    res.append("  \"first" + ((xs.first == null)?" = null":"") + "\" [shape=rectangle];\n");
    if(xs.last != null)
      res.append("  \"last\" -> \"" + nodeToString(xs.last)
                 +"\"[color=purple];\n");
    res.append("  \"last" + ((xs.last == null)?" = null":"") + "\" [shape=rectangle];\n");
    LinkedList<Node<T>> visited = new LinkedList<Node<T>>();
    LinkedList<Node<T>> frontier = new LinkedList<Node<T>>();
    frontier.add(xs.first);
    while(!frontier.isEmpty())
    {
      Node<T> cur = frontier.pop();
      visited.add(cur);
      if(cur != null)
      {
        res.append("  \"" + nodeToString(cur) + "\" -> \"" + nodeToString(cur.next) +
                   "\" [label = next, color = red];\n");
        if(!visited.contains(cur.next))
          frontier.add(0, cur.next);
        res.append("  \"" + nodeToString(cur) + "\" -> \"" + nodeToString(cur.prev) +
                   "\" [label = prev, color = blue];\n");
        if(!visited.contains(cur.prev))
          frontier.add(frontier.size(), cur.prev);
      }
      if(frontier.isEmpty() && !visited.contains(xs.last))
          frontier.add(xs.last);
    }
    for(Node<T> n : visited)
      res.append("  \"" + nodeToString(n) + "\" [label=\"" + nodeValToString(n) + "\"];\n");
    res.append("  \"length = " + xs.length + "\" [shape=rectangle];\n" );
    res.append("}");
    return res.toString();
  }

  public static <T> void dotDump(DLList<T> xs)
  {
    System.out.println("  Here is a graphviz description of the linked list you passed to dotDump:\n\n" +
            toDot(xs));
    System.out.println("\n\n  You may run graphviz or copy that to https://viz.js to visualize it.");
  }

}
