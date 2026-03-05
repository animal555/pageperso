
class cell:
  # A cell is essentially a non-empty single linked list.
  # It has two attributes:
  # * head, which is the first value in the linked list
  # * tail, which is the a reference to the rest of the list.
  # The empty list is represented by the value None
  def __init__(self, v, n = None):
    self.head = v
    self.tail = n 
  # Please don't mess with the cell class further (lest you break some debugging
  # stuff below)


# The class llist, which contains three attributes:
# * first, which is either None or a cell
# * last, which is either None or a cell
# * size, which is an integer
# We discussed the first two during the lecture: they are references to the
# first and last cell in the linked list. The attribute size internally tracks
# the size of the whole datastructure.
class llist:
  # The constructor, which takes as optional input an iterable object (e.g.,
  # a python list), and builds the corresponding linked list.
  def __init__(self, col = []):
    self.first = None
    self.last = None
    self.size = 0
    for i in col:
      self.append(i)

  # Adds a single element x at the end of the list, returns nothing
  def append(self, x):
    if self.first == None:
        self.first = cell(x)
        self.last = self.first
    else:
        self.last.tail = cell(x)
        self.last = self.last.tail
    self.size += 1

  # Allows to use the built-in len function of python with llist
  def __len__(self):
    return self.size

  # Should add a single element x at the beginning of the list
  # FOR YOU TO IMPLEMENT!
  def prepend(self, x):
    if self.first == None:
        self.first = cell(x)
        self.last = self.first
    else:
        self.first.tail = cell(x)
        self.first = self.first.tail
    self.size += 1

  # Should insert an element x at index i
  # Should not return anything
  # FOR YOU TO IMPLEMENT!
  def insert(self, i, x):
    if i == 0:
        self.prepend(x)
    else:
        prev = self.first
        while i > 1 and prev != None:
          prev = self.tail
          i -= 1
        if i < 1 or prev == None:
          raise IndexError
        else:
          prev.tail = cell(x, prev.tail)
          size += 1
        

  # Should concatenate the list given as an argument at the end of the current
  # object. Should not return any value. Should work in O(1)
  # FOR YOU TO IMPLEMENT!
  def concat(self, otherList):
    if otherList.first == None:
        return
    if self.first == None:
        self.first = otherList.first
    else:
        self.last.tail = otherList.first
    self.last = otherList.last
    self.size += otherList.size


# Now we turn to an in place implementation of merge-sort

  def isEmpty(self):
      return self.first == None

  def peekFront(self):
      if self.isEmpty():
          raise ValueError
      return self.first.head

  def popFront(self):
      if self.isEmpty():
          raise ValueError
      x = self.first.head
      self.size -= 1
      self.first = self.first.tail
      if self.first == None:
          self.last = None
      return x

  def split(self):
      n = self.size // 2
      o = llist()
      for i in range(0, n):
        o.append(self.popFront())
      return o

  # Assuming self and other are both sorted, the following merges
  # other into self (emptying the other list in the process) so that
  # the end result is sorted
  def merge(self, other):
      if self.first == None:
          self.first = other.first
          self.last = other.last
          self.size = other.size
          return
      elif other.first == None:
          return
      v = self.peekFront()
      if v > other.peekFront():
         self.first.head = other.peekFront()
         other.first.head = v
      prev = self.first
      cur = prev.tail
      while cur != None and not other.isEmpty():
         if cur.head < other.peekFront():
             prev = cur
             cur = cur.tail
         else:
             v = other.popFront()
             prev.tail = cell(v, cur)
             self.size += 1
             prev = prev.tail
      self.concat(other)
      

  # The code of mergeSort that is supposed to sort the linked list in place
  # if the functions above are well-implemented
  def mergeSort(self):
    if len(self) <= 1:
        return
    other = self.split()
    self.mergeSort()
    other.mergeSort()
    self.merge(other)

  # Converts the list to a string, so that you may use print with a list
  # object and get something human readable
  def __str__(self):
     l = []
     c = self.first
     while c != None:
       l.append(str(c.head))
       c = c.tail
     return '<' + ', '.join(l) + '>'

   

# The debugging functions discussed in the lab sheet. You do not need to
# understand the code below; these functions are meant to help you out!

# First the following function checks if a linked list object is healthy in the
# following sense:
# * the attributes first and last are either None or not None at the same time
# * if last is not None, then last.tail == None
# * there is no cycle in the linked list
# * last is reachable from first using tail if it's not None
# * the size attributes does reflect the length of the list in question
#
# If this returns false on a list built using methods you coded in a sensible
# way, you have a bug! If you struggle to see where the bug is, please use toDot
# to try to picture what's going on.
def isHealthy(xs):
    lastFirstOK = xs.first == None and xs.last == None or xs.first != None and xs.last != None
    if xs.last != None:
        lastFirstOK = lastFirstOK and xs.last.tail == None
    if not lastFirstOK:
        return False
    visited = { None }
    cur = xs.first
    i = 0
    while cur != None:
        if cur in visited:
            return False
        visited.add(cur)
        cur = cur.tail
        i += 1
    return xs.last in visited and i == xs.size

# toDot returns a string that generates a dot file that describes a graph
# representation of whatever the datastructure looks like (even if it is
# a bit nonsensical!)
# If you do not have graphviz on your computer, you may paste the output
# in e.g. https://dreampuf.github.io/GraphvizOnline or any similar tool
# (the code below is overcomplicated btw; I scavenged it from something I did
# last year to deal with doubly-linked lists)
def toDot(xs):
    res = []
    res.append("digraph {\n  rankdir=LR;\n")
    visited = []
    if xs.first != None:
      res.append("  \"first\" -> \"" + cellToString(xs.first) + "\"[color=green];\n")
      res.append("  \"first" + "\" [shape=rectangle];\n")
    else:
      res.append("  \"first" + " = None" + "\" [shape=rectangle];\n")
    if xs.last != None:
      res.append("  \"last\" -> \"" + cellToString(xs.last) +"\"[color=purple];\n")
      res.append("  \"last" + "\" [shape=rectangle];\n")
    else:
      res.append("  \"last" + " = None" + "\" [shape=rectangle];\n")
    frontier = [xs.first]
    while len(frontier) != 0:
      cur = frontier.pop()
      visited.append(cur)
      if cur != None:
        res.append("  \"" + cellToString(cur) + "\" -> \"" + cellToString(cur.tail) + "\" [label = tail, color = red];\n")
        if not cur.tail in visited:
          frontier.insert(0, cur.tail)
      if len(frontier) == 0 and not xs.last in visited:
        frontier.append(xs.last)
    for n in visited:
      res.append("  \"" + cellToString(n) + "\" [label=\"" + cellValToString(n) + "\"];\n")
    res.append("  \"length = " + str(xs.size) + "\" [shape=rectangle];\n" )
    res.append("}")
    return ''.join(res)

# Helper function for toDot
def cellToString(n):
  if n == None:
      return "None"
  else:
      return str(n.head) + " (" + str(n)[22:-1] + ")";

# Helper function for toDot
def cellValToString(n):
  if n == None:
      return "None"
  else:
      return str(n.head)

