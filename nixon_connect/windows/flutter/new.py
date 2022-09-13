def setInteractions(str1):
    list1, list2 = str1.split(";")
    list1 = list1.split(",")
    list2 = set(list2.split(","))
    ans = []
    for i in list1:
        if i in list2:
            ans.append(i)
    return ",".join(ans)


str1 = input()
print(setInteractions(str1))
