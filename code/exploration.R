dataset1 = read.table("vert_1.txt", header = TRUE)
dataset2 = read.table("arc_2.txt", header = TRUE)
dataset3 = read.table("arc_3.txt", header = TRUE)

# defining V as the number of vertices
# and A as the number of arcs of the input graph
# the theoretical time complexity of the algorithms is the following
# EK -> O(|V|*|A|^2)
# Dinic -> O(|A|*|V|^2)
# MPM -> O(|V|^3)

plot(dataset1$num_verts, dataset1$dinic1)
plot(dataset1$num_verts, dataset1$ek1)
plot(dataset1$num_verts, dataset1$mpm1)

plot(dataset2$num_arcs, dataset2$dinic1)
plot(dataset2$num_arcs, dataset2$ek1)
plot(dataset2$num_arcs, dataset2$mpm1)

plot(dataset3$num_arcs, dataset3$dinic1)
plot(dataset3$num_arcs, dataset3$dinic2)
plot(dataset3$num_arcs, dataset3$dinic3)

plot(dataset3$num_arcs, dataset3$ek1)
plot(dataset3$num_arcs, dataset3$ek2)
plot(dataset3$num_arcs, dataset3$ek3)

plot(dataset3$num_arcs, dataset3$mpm1)
plot(dataset3$num_arcs, dataset3$mpm2)
plot(dataset3$num_arcs, dataset3$mpm3)

lr.out = lm(dataset3$dinic1~dataset3$num_arcs)
summary(lr.out)
plot(lr.out)