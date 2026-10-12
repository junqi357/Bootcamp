a <- 4
a
a * a

a_squared <- a * a
sqrt(a_squared)

v <- c(0, 1, 2, 3, 4)  
v                       
is.vector(v)            
mean(v)
var(v)       # 方差：数字的分散程度，得到 2.5
median(v)    # 中位数：排好顺序后中间的数字，得到 2
sum(v)       # 所有数字相加，得到 10
prod(v + 1)  # 每个数字先加 1，再全部相乘，得到 120
length(v)    # 查看有几个数字，得到 5     

2 + (3 * 4)  # 圆括号里的计算先执行，得到 14
(2 + 3) * 4  # 先算 2 + 3，再乘 4，得到 20

mean(v)      # 圆括号也用来给函数传入数据，得到 2
v[4]         # 方括号取出 v 中第 4 个数字，得到 3

##variable names and tabbing
wing.width.cm <- 1.2               # 翅膀宽度，单位 cm
wing.length.cm <- c(4.7, 5.2, 4.8) # 三个翅膀长度，单位 cm

##operators
7 + 2   # 加法，得到 9
7 - 2   # 减法，得到 5
7 * 2   # 乘法，得到 14
7 / 2   # 除法，得到 3.5
7 ^ 2   # 平方，得到 49
7 %% 2  # 除以 2 的余数，得到 1
7 %/% 2 # 整数除法，得到 3

7 == 2  # 判断是否相等，得到 FALSE
7 != 2  # 判断是否不同，得到 TRUE
7 > 2   # 判断是否大于，得到 TRUE
7 >= 7  # 判断是否大于或等于，得到 TRUE

#logics
(7 > 2) & (7 < 10)  # &：两个条件都成立，得到 TRUE
(7 > 2) & (7 > 10)  # 第二个条件为 FALSE，得到 FALSE

(7 > 2) | (7 > 10)  # |：至少一个条件成立，得到 TRUE

!(7 > 2)           # !：把判断结果反转，TRUE 变成 FALSE

##parentheses, 括号
2 + (3 * 4)  # 圆括号里的计算先执行，得到 14
(2 + 3) * 4  # 先算 2 + 3，再乘 4，得到 20

##variable types
v <- TRUE       # 把 v 更新为逻辑值 TRUE
class(v)        # 得到 "logical"：逻辑类型

v <- 3.2
class(v)        # 得到 "numeric"：数值类型

v <- 2L         # 数字后面的 L 表示整数
class(v)        # 得到 "integer"：整数类型

v <- "A string"
class(v)        # 得到 "character"：字符类型

#type conversions
as.integer(3.1)    # 转为整数，舍去小数部分，得到 3
as.numeric(4)      # 转为数值类型，得到 4
as.character(155)  # 转为文字，得到 "155"
as.logical(5)      # 非零数字转为 TRUE
as.logical(0)      # 0 转为 FALSE

##special values
b <- 0 / 0
b                 # 得到 NaN：这个计算的数值结果未定义 (numeric)
is.nan(b)         # 检查是否为 NaN，得到 TRUE

b <- 5 / 0
b                 # 得到 Inf：正无穷 (numeric)
is.infinite(b)    # 检查是否为无穷，得到 TRUE
is.finite(b)      # 检查是否为有限数值，得到 FALSE

#missing value (NA)
b <- NA      # 把缺失值保存为 b
b            # 显示 NA
class(b)     # 这里得到 "logical"
is.na(b)     # 检查 b 是否为缺失值，得到 TRUE

#E notation, 乘以 10 的几次方
1E4       # 1 × 10⁴，得到 10000
1e4       # 小写 e 也一样，得到 10000
5e-2      # 5 × 10⁻²，得到 0.05
1E4 ^ 2   # 10000 的平方，得到 1e+08，即 100000000

##Data sturctures
#vectors
v1 <- c(0.02, 0.5, 1)           # 数值向量
v2 <- c("a", "bc", "def", "ghij") # 文字向量
v3 <- c(TRUE, TRUE, FALSE)        # 逻辑向量

v1  # 显示三个数字
v2  # 显示四段文字
v3  # 显示三个逻辑值

v1 <- c(0.02, TRUE, 1)
v1                       # 得到 0.02、1、1，TRUE 转成数字 1

v1 <- c(0.02, "Mary", 1)
v1                       # 得到 "0.02"、"Mary"、"1"，全部转成文字
                        #混合时统一类型顺序：logical → integer → numeric → character

v2 <- character(3)  # 创建三个位置的文字向量
v2                  # 得到 "" "" ""，每个位置都是空文字

v3 <- numeric(3)    # 创建三个位置的数值向量
v3                  # 得到 0 0 0，每个位置初始为 0

heights_cm <- c(8, 12, 10, 15)      # 把四株植物的高度保存为向量
above_threshold <- heights_cm > 10  # 逐个判断高度是否超过 10
above_threshold                     # 得到 FALSE TRUE FALSE TRUE
sum(above_threshold)                # 统计 TRUE 的数量，得到 2
sum(heights_cm >= 10)               # 包括刚好 10 cm 的植物，得到 3

##creating sequences
years <- 1990:2009  # 从 1990 到 2009，每次增加 1
years              # 显示这些年份

years <- 2009:1990  # 从 2009 到 1990，每次减少 1
years              # 显示倒序的年份

seq(1, 10, 0.5)    # 从 1 到 10，每次增加 0.5
                  #: 的间隔是 1；seq() 可以指定间隔

##indices and indexing, 索引
MyVar <- c("a", "b", "c", "d", "e")

MyVar[1]             # 取第 1 个，得到 "a"
MyVar[4]             # 取第 4 个，得到 "d"
MyVar[1:3]           # 取第 1 到第 3 个，得到 "a" "b" "c"
MyVar[c(3, 2, 1)]    # 按指定顺序取，得到 "c" "b" "a"
MyVar[c(1, 1, 5, 5)] # 重复取指定位置，得到 "a" "a" "e" "e"
MyVar[-3]            # 取第 3 个以外的值，得到 "a" "b" "d" "e"

##data frames, 数据框：把几列数据组合成一张表，每列可以保存不同类型的数据。
plants <- data.frame(
  species = c("Oak", "Birch", "Pine"), # 第一列：植物名称
  height_cm = c(8, 12, 15)            # 第二列：高度
)
plants                               # 显示整张表

plants$height_cm  # 用 $ 和列名取出高度列，得到 8 12 15
plants[2, 1]     # [行, 列]：第 2 行、第 1 列，得到 "Birch"
plants[1, ]     # 第 1 行的所有列
plants[, 2]     # 第 2 列的所有行

str(plants)     # 查看表格结构和每列的数据类型
head(plants)    # 查看前几行；这张表会显示全部三行

dim(plants)      # 行数和列数，得到 3 2：三行、两列
names(plants)    # 列名，得到 "species" "height_cm"
class(plants)    # 对象类型，得到 "data.frame"
tail(plants)     # 默认显示后六行，这里也显示全部三行