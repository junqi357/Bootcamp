def buggyfunc(x):
    y = x                 # y 的初始值与 x 相同
    for i in range(x):    # 循环 x 次
        try:
            y = y - 1
            z = x / y
        except ZeroDivisionError:
            print(f"The result of dividing a number by zero is undefined")
        except:
            print(f"This didn't work;{x = }; {y = }")
        else:
            print(f"OK; {x = }; {y = }, {z = };")
    return z

buggyfunc(20)             # 用 x = 20 调用函数

