from queue import *

class tree:
    def __init__(self, x, c = []):
            self.label = x
            self.children = []
            for i in c:
                self.children.append(i)
    
    def toListOfString(self):
        res = ['(' + str(self.label) + ', [']
        for i in self.children:
            res += i.toListOfString()
            res.append(' ')
        res.append('])')
        return res
    
    def __str__(self):
        return ''.join(self.toListOfString())
    
    def BFEnumeration(self):
        res = []
        q = Queue()
        q.put(self)
        while not q.empty():
            t = q.get()
            res.append(t.label)
            for c in t.children:
                q.put(c)
        return res
    
x = tree(2, [tree(1), tree(3, [tree(4)]), tree(5)])
