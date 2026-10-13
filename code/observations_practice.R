observations <- read.csv(
  "data/bootcamp_observations.csv",
  colClasses = "character",
  na.strings = "",
  check.names = FALSE
)
# colClasses = "character" 将所有列读成文字。
# na.strings = "" 将空字段识别为缺失值 NA。
# check.names = FALSE 保留文件原有的列名。

str(observations)
# 查看记录数、列数和各列类型。

print(observations)
# print() 明确打印对象内容，运行整个脚本时也会显示。

expected_columns <- c("site", "date", "count")

names(observations)

identical(names(observations), expected_columns)
# identical() 检查两个对象是否完全相同，包括顺序。

stopifnot(identical(names(observations), expected_columns))
# stopifnot() 在条件为 FALSE 时停止运行并报错。