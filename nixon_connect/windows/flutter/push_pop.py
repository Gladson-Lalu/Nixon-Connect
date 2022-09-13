def setInteractions(str1):
    list1, list2 = str1.split(";")
    list1 = list1.split(",")
    list2 = list2.split(",")
    ans = []
    for i in list1:
        for j in list2:
            if i == j:
                ans.append(i)
    return ",".join(ans)


str1 = input()
print(setInteractions(str1))
