dataset = read.table("vert.txt", header = TRUE)

# defining V as the number of vertices
# and A as the number of arcs of the input graph
# the theoretical time complexity of the algorithms is the following
# EK -> O(|V|*|A|^2)
# Dinic -> O(|A|*|V|^2)
# MPM -> O(|V|^3)

plot(dataset$num_verts, dataset$dinic1)
plot(dataset$num_verts, dataset$ek1)
plot(dataset$num_verts, dataset$mpm1)

lr.out = lm(dataset$ek1~dataset$num_verts)
summary(lr.out)
plot(lr.out)