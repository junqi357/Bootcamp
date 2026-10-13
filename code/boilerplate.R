MyFunction <- function(Arg1, Arg2) {

  print(paste("Argument", as.character(Arg1), "is a", class(Arg1)))

  print(paste("Argument", as.character(Arg2), "is a", class(Arg2)))

  return(c(Arg1, Arg2))
}

MyFunction(1, 2)
MyFunction("riki", "Tiki")

ls(pattern = "MyFun*")

class(MyFunction)