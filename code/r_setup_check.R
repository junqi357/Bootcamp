df <- mtcars  # 使用 R 自带的汽车数据表
View(df)      # 打开表格查看器

results <- list(
  coefficients = c(1.2, 3.4),           # 一组数字
  metadata = list(name = "experiment1") # 内层列表，保存实验名称
)

plot(cars)  # 用自带数据画散点图
?mean      # 打开 mean() 的帮助说明

R.home()       # R 的安装位置
.libPaths()    # R 包的存放位置
Sys.which("R") # 当前使用的 R 程序路径
