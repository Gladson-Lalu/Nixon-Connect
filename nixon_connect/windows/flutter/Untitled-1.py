class UserMainCode(object):
    @classmethod
    def distantRelatives(cls, input1, input2):
        if input1 in {0, 1}:
            return 0

        def editDist(str1, str2, l1, l2):
            if l1 == 0:
                return l2
            if l2 == 0:
                return l1
            if str1[l1-1] == str2[l2-1]:
                return editDist(str1, str2, l1-1, l2-1)
            return 1 + min(editDist(str1, str2, l1, l2-1),
                           editDist(str1, str2, l1-1, l2),
                           editDist(str1, str2, l1-1, l2-1)
                           )

        maxd = 0
        m = dict()
        R = [[0 for x in range(input1+1)] for x in range(2)]
        input2 = "@" + input2 + "#"

        for j in range(2):
            rp = 0
            R[j][0] = 0

            i = 1
            while i <= input1:
                while input2[i - rp - 1] == input2[i + j + rp]:
                    rp += 1
                R[j][i] = rp
                k = 1
                while (R[j][i - k] != rp - k) and (k < rp):
                    R[j][i+k] = min(R[j][i-k], rp - k)
                    k += 1
                rp = max(rp - k, 0)
                i += k
        input2 = input2[1:len(input2)-1]
        m[input2[0]] = 1
        for i in range(1, input1):
            for j in range(2):
                for rp in range(R[j][i], 0, -1):
                    m[input2[i - rp - 1: i - rp - 1 + 2 * rp + j]] = 1
            m[input2[i]] = 1
        keys = list(m.keys())
        for i in range(0, keys.__len__()):
            for j in range(i+1, keys.__len__()):
                dist = editDist(keys[i], keys[j],
                                keys[i].__len__(), keys[j].__len__())
                maxd = max(maxd, dist)
        return maxd


print(UserMainCode.distantRelatives(8, "abbnmmna"))
