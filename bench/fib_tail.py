from bench import bench

print(bench(10000, '''
def fib(n, a=0, b=1):
  if n > 1: 
    return fib(n-1, b, a+b)
  else:
    return a if n == 0 else b
''', '''
fib(20)
'''))
