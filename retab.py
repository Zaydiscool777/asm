import sys
for j in sys.argv[1:]:
    f = open(j, "r+")
    g = []
    for i in f.readlines():
        if i[0] == '\t':
            g.append(i[1:])
        else:
            g.append('\t' + i)
    f.truncate(0)
    f.seek(0)
    f.writelines(g)
    f.close()
    