from copy import copy

Ops = '+*/-'
OpsFun = { '+' : lambda x, y: x.__add__(y),\
           '*' : lambda x, y: x.__mul__(y),\
           '/' : lambda x, y: x.__floordiv__(y),\
           '-' : lambda x, y: x.__sub__(y)\
         }
maxOpCode = max([ ord(i) for i in Ops])

class ArithmeticExpression:
  """
  We want the following attributes around:
  * subLeft for the left subexpression
  * subRight for the right subexpression
  * label for the top-level operator or the integer value of the expression
    The operators '+*/-' will be stored as strings, the integers as ints.
  * hashCode, for the hash of the whole thing
  * value, for the value the expression evaluates to

  This datastructure is meant to be immutable; don't mess with the attributes
  from outside of the class
  """

  def __init__(self, x, l = None, r = None):
      self.label = x
      self.subLeft = l
      self.subRight = r
      if type(x) == int:
          x += 1 + maxOpCode
      self.hashCode = hash((x, l, r))
      if self.subLeft == None:
          self.value = self.label
      else:
          if self.subLeft.value == None or self.subRight.value == None or\
             self.label == '/' and\
             (self.subRight.value == 0 or self.subLeft.value % self.subRight.value != 0):
              self.value = None
          else:
              self.value = OpsFun[self.label](self.subLeft.value, self.subRight.value)

  def eval(self):
      return self.value

  def __hash__(self):
      return self.hashCode

  def __eq__(self, other):
      return other != None and\
             self.hashCode == other.hashCode and\
             self.label == other.label and\
             self.subRight == other.subRight and\
             self.subLeft == other.subLeft

  # not terribly efficient
  def __str__(self):
      if self.subLeft == None:
          return str(self.label)
      else:
          return '(' + str(self.subLeft) + ' ' + self.label + ' ' + str(self.subRight) + ')'
  



# A helper function you may want to use!
def allSplits(xs):
  def aux(xs):
      res = []
      if len(xs) == 2:
         res = [([xs[0]], [xs[1]])]
      elif len(xs) > 2:
         k = xs.pop()
         yss = aux(xs)
         while len(yss) > 0:
             (ys0, ys1) = yss.pop()
             ys0copy = copy(ys0)
             ys1copy = copy(ys1)
             ys0.append(k)
             ys1copy.append(k)
             for i in [(ys0, ys1), (ys0copy, ys1copy)]:
                 res.append(i)
         xs.append(k)
      return res
  return list(map(lambda x: tuple(map(tuple, x)), aux(list(xs))))


"""
TODO: the countdown function takes as input a tuple of integers and an integer,
and should return an arithmetic expression that uses integers in the tuple
at most once to computer the second integer.

You should define the auxiliary function populateMemo whose purpose is to
fill the hash table memoAllExpressions. populateMemo(numbers) should fill
all cells indexed by sublists of numbers.
"""

# A hash table meant to map a list of numbers to a set of all possible arithmetic
# expressions that can be generated from it; here I give you some examples in
# the initialization
memoAllExpressions = { (0,) : {ArithmeticExpression(0)},\
                       (2, 4) : { ArithmeticExpression(4),\
                                  ArithmeticExpression(2),\
                                  ArithmeticExpression('+', ArithmeticExpression(2), ArithmeticExpression(4)),\
                                  ArithmeticExpression('-', ArithmeticExpression(4), ArithmeticExpression(2)),\
                                  ArithmeticExpression('*', ArithmeticExpression(2), ArithmeticExpression(4)),\
                                  ArithmeticExpression('/', ArithmeticExpression(4), ArithmeticExpression(2))}\
                    }

def populateMemo(numbers):
  return
def countdown(numbers, goal):
  return

def playCountdown(numbers, goal):
  sol = countdown(countdowninstance, goal)
  if sol == None:
      print('it is not possible to reach', goal, 'using', countdowninstance)
  else:
      print(goal, 'can be reached using', countdowninstance)
      print('Here is the an arithmetic expression witnessing that')
      print(sol)

if __name__ == "__main__":
  ys = (3, 2, 1, 0)
  print(allSplits(ys))
  xs = tuple(range(0,6))
  print(xs)
  print(allSplits(xs))
  countdowninstance = (5,4,3,2)
  playCountdown(countdowninstance, 6)
