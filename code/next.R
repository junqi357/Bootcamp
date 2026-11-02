for (i in 1:10) {
    if ((i %% 2) == 0) {
        next    # Skip even numbers
    }
    print(i)
}