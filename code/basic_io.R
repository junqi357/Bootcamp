## Import/Export Data
getwd()

MyData <- read.csv("data/trees.csv")

class(MyData) # 查看读入对象的类型
head(MyData)  # 查看前 6 行
str(MyData)   # 查看行数、列数和各列类型

MyData <- read.csv("data/trees.csv", header = FALSE)    # 把第一行也当作数据读入

head(MyData)
str(MyData)

MyData <- read.table("data/trees.csv", sep = ",", header = TRUE)    # sep = ","：以逗号分列；header = TRUE：第一行作为列名

MyData <- read.csv("data/trees.csv", skip = 5)    # 跳过文件前 5 行，再开始读取

head(MyData)


## Writting to and Saving Files
MyData <- read.csv("data/trees.csv", header = TRUE)
# header = TRUE 将第一行作为列名。

write.csv(MyData, "results/MyData.csv")
# 保存为逗号分隔的 CSV，默认包含行名。

dir("results/")
# 列出 results 文件夹里的内容。

write.table(MyData[1, ], file = "results/MyData.csv", append = TRUE)
# write.table() 默认用空格分隔；append = TRUE 追加到文件末尾。

write.csv(MyData, "results/MyData.csv", row.names = TRUE)
# 覆盖结果文件；row.names = TRUE 包含行名。

write.table(MyData, "results/MyData.csv", col.names = FALSE)
# col.names = FALSE 省略列名。

write.csv(MyData, "results/MyData.csv", row.names = FALSE)