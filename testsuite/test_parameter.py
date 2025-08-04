# No parameters
def test1():
    pass

# One parameter
def test2(a):
    pass

# Two parameters
def test3(a,b):
    pass

# Three parameters
def test4(a,b,c):
    pass

# Init parameters
def test5(a = b):
    pass

# Modifier parameters
def test6(a,/,b,*,c):
    pass

# Arg parameters
def test7(*args, **kwargs):
    pass

# Template parameters
def test8[T]():
    pass

# Annotated parameters
def test9(a:int, b:x, c:"Hello"):
    pass

# All function parameters
def test10[T](a,/,b:int,c=2,*args,**kwargs):
    pass

# Class template parameters
class CLS[T]:
    pass


