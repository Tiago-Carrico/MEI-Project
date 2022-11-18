library(ggplot2)
library(patchwork)

# DATASETS
# <name>    : num_vertices, prob_arc, max_capacity [min:max:step]
# dataset 1 : [100:2000:100], 0.5, 100
# dataset 2 : 400, [0.1:0.9:0.1], 100
# dataset 3 : 1000, [0.1:0.9:0.1], 100
dataset1 = read.table("vert_1.txt", header = TRUE)
dataset2 = read.table("arc_2.txt", header = TRUE)
dataset3 = read.table("arc_3.txt", header = TRUE)

# defining V as the number of vertices
# and A as the number of arcs of the input graph
# the theoretical time complexity of the algorithms is the following
# EK -> O(|V|*|A|^2)
# Dinic -> O(|A|*|V|^2)
# MPM -> O(|V|^3)

### DATASET 1 ###

## MPM ##
# scatter plot
scatter <- ggplot(dataset1, aes(num_verts,mpm1)) + geom_point() +
  labs(
    title="MPM [0.5 arc probability, 100 max capacity]",
    x="Number of Vertices (V)",
    y="Time (seconds)"
  ) + theme_bw()

# linear regression with sqrt(y)=a+bx transformation
lr.out = lm(sqrt(dataset1$mpm1)~dataset1$num_verts)

reg <- ggplot(dataset1, aes(num_verts, sqrt(mpm1))) + geom_point() +
  geom_smooth(method="lm", formula="y~x", se=FALSE) +
  annotate(
    geom="text",
    x=1000,
    y=0.6, 
    label=paste(
      "y=",
      formatC(lr.out[["coefficients"]][["(Intercept)"]], format='e', digits=3),
      "+",
      formatC(lr.out[["coefficients"]][["dataset1$num_verts"]], format='e', digits=3),
      "b, r²=",
      formatC(summary(lr.out)$r.squared, digits=4))
  ) +
  labs(
    title="MPM [0.5 arc probability, 100 max capacity]",
    x="Number of Vertices (V)",
    y="sqrt(Time) (seconds)"
  ) + theme_bw()

print(scatter + reg)

summary(lr.out)
par(mfcol=c(1,2))
plot(lr.out, which=1, ask=FALSE)
plot(lr.out, which=2, ask=FALSE)

# linear regression with y^(1/3)=a+bx transformation
lr.out = lm(dataset1$mpm1^(1/3)~dataset1$num_verts)

reg <- ggplot(dataset1, aes(num_verts, mpm1^(1/3))) + geom_point() +
  geom_smooth(method="lm", formula="y~x", se=FALSE) +
  annotate(
    geom="text",
    x=1000,
    y=0.7, 
    label=paste(
      "y=",
      formatC(lr.out[["coefficients"]][["(Intercept)"]], format='e', digits=3),
      "+",
      formatC(lr.out[["coefficients"]][["dataset1$num_verts"]], format='e', digits=3),
      "b, r²=",
      formatC(summary(lr.out)$r.squared, digits=4))
  ) +
  labs(
    title="MPM [0.5 arc probability, 100 max capacity]",
    x="Number of Vertices (V)",
    y="Time^(1/3) (seconds)"
  ) + theme_bw()

print(scatter + reg)

summary(lr.out)
par(mfcol=c(1,2))
plot(lr.out, which=1, ask=FALSE)
plot(lr.out, which=2, ask=FALSE)

## Dinic ##
# scatter plot
scatter <- ggplot(dataset1, aes(num_verts, dinic1)) + geom_point() +
  labs(
    title="Dinic [0.5 arc probability, 100 max capacity]",
    x="Number of Vertices (V)",
    y="Time (seconds)"
  ) + theme_bw()

# linear regression with transformation sqrt(y)=a+bx
lr.out = lm(sqrt(dataset1$dinic1)~dataset1$num_verts)

reg <- ggplot(dataset1, aes(num_verts,sqrt(dinic1))) + geom_point() +
  geom_smooth(method="lm", formula="y~x", se=FALSE) +
  annotate(
    geom="text",
    x=1000,
    y=0.35, 
    label=paste(
      "y=",
      formatC(lr.out[["coefficients"]][["(Intercept)"]], format='e', digits=3),
      "+",
      formatC(lr.out[["coefficients"]][["dataset1$num_verts"]], format='e', digits=3),
      "b, r²=",
      formatC(summary(lr.out)$r.squared, digits=4))
  ) +
  labs(
    title="Dinic [0.5 arc probability, 100 max capacity]",
    x="Number of Vertices (V)",
    y="sqrt(Time) (seconds)"
  ) + theme_bw()

print(scatter + reg)

summary(lr.out)
par(mfcol=c(1,2))
plot(lr.out, which=1, ask=FALSE)
plot(lr.out, which=2, ask=FALSE)

## EK ##
# scatter plot
ggplot(dataset1, aes(num_verts, ek1)) + geom_point() +
  labs(
    title="EK [0.5 arc probability, 100 max capacity]",
    x="Number of Vertices (V)",
    y="Time (seconds)"
  ) + theme_bw()

# linear regression with sqrt(y)=a+bx transformation
lr.out = lm(sqrt(dataset1$ek1)~dataset1$num_verts)

ggplot(dataset1, aes(num_verts, sqrt(ek1))) + geom_point() +
  geom_smooth(method="lm", formula="y~x", se=FALSE) +
  annotate(
    geom="text",
    x=1000,
    y=5, 
    label=paste(
      "y=",
      formatC(lr.out[["coefficients"]][["(Intercept)"]], format='e', digits=3),
      "+",
      formatC(lr.out[["coefficients"]][["dataset1$num_verts"]], format='e', digits=3),
      "b, r²=",
      formatC(summary(lr.out)$r.squared, digits=4))
  ) +
  labs(
    title="EK [0.5 arc probability, 100 max capacity]",
    x="Number of Vertices (V)",
    y="sqrt(Time) (seconds)"
  ) + theme_bw()

summary(lr.out)
par(mfcol=c(1,2))
plot(lr.out, which=1, ask=FALSE)
plot(lr.out, which=2, ask=FALSE)

### DATASET 2 ###

## EK ##
# scatter plot
scatter <- ggplot(dataset2, aes(num_arcs, ek1)) + geom_point() +
  labs(
    title="EK [400 vertices, 100 max capacity]",
    x="Number of Arcs (A)",
    y="Time (seconds)"
  ) + theme_bw()

# linear regression with sqrt(y)=a+bx transformation
lr.out = lm(sqrt(dataset2$ek1)~dataset2$num_arcs)

reg <- ggplot(dataset2, aes(num_arcs, sqrt(ek1))) + geom_point() +
  geom_smooth(method="lm", formula="y~x", se=FALSE) +
  annotate(
    geom="text",
    x=40000,
    y=0.5, 
    label=paste(
      "y=",
      formatC(lr.out[["coefficients"]][["(Intercept)"]], format='e', digits=3),
      "+",
      formatC(lr.out[["coefficients"]][["dataset2$num_arcs"]], format='e', digits=3),
      "b, r²=",
      formatC(summary(lr.out)$r.squared, digits=4))
  ) +
  labs(
    title="EK [400 vertices, 100 max capacity]",
    x="Number of Arcs (A)",
    y="sqrt(Time) (seconds)"
  ) + theme_bw()

print(scatter + reg)

summary(lr.out)
par(mfcol=c(1,2))
plot(lr.out, which=1, ask=FALSE)
plot(lr.out, which=2, ask=FALSE)

## Dinic ##
# scatter plot
scatter <- ggplot(dataset2, aes(num_arcs, dinic1)) + geom_point() +
  labs(
    title="Dinic [400 vertices, 100 max capacity]",
    x="Number of Arcs (A)",
    y="Time (seconds)"
  ) + theme_bw()

# linear regression y=a+bx
lr.out = lm(dataset2$dinic1~dataset2$num_arcs)

reg <- ggplot(dataset2, aes(num_arcs, dinic1)) + geom_point() +
  geom_smooth(method="lm", formula="y~x", se=FALSE) +
  annotate(
    geom="text",
    x=40000,
    y=0.0038, 
    label=paste(
      "y=",
      formatC(lr.out[["coefficients"]][["(Intercept)"]], format='e', digits=3),
      "+",
      formatC(lr.out[["coefficients"]][["dataset2$num_arcs"]], format='e', digits=3),
      "b, r²=",
      formatC(summary(lr.out)$r.squared, digits=4))
  ) +
  labs(
    title="Dinic [400 vertices, 100 max capacity]",
    x="Number of Arcs (A)",
    y="Time (seconds)"
  ) + theme_bw()

print(scatter + reg)

summary(lr.out)
par(mfcol=c(1,2))
plot(lr.out, which=1, ask=FALSE)
plot(lr.out, which=2, ask=FALSE)
# small times for Dinic due to low number of verts result in bigger uncertainty

## MPM ##
# scatter plot
scatter <- ggplot(dataset2, aes(num_arcs,mpm1)) + geom_point() +
  labs(
    title="MPM [400 vertices, 100 max capacity]",
    x="Number of Arcs (A)",
    y="Time (seconds)"
  ) + theme_bw()

# linear regression y=a+bx
lr.out = lm(dataset2$mpm1~dataset2$num_arcs)

reg <- ggplot(dataset2, aes(num_arcs, mpm1)) + geom_point() +
  geom_smooth(method="lm", formula="y~x", se=FALSE) +
  annotate(
    geom="text",
    x=40000,
    y=0.015, 
    label=paste(
      "y=",
      formatC(lr.out[["coefficients"]][["(Intercept)"]], format='e', digits=3),
      "+",
      formatC(lr.out[["coefficients"]][["dataset2$num_arcs"]], format='e', digits=3),
      "b, r²=",
      formatC(summary(lr.out)$r.squared, digits=4))
  ) +
  labs(
    title="MPM [400 vertices, 100 max capacity]",
    x="Number of Arcs (A)",
    y="Time (seconds)"
  ) + theme_bw()

print(scatter + reg)

summary(lr.out)
par(mfcol=c(1,2))
plot(lr.out, which=1, ask=FALSE)
plot(lr.out, which=2, ask=FALSE)

# linear regression with sqrt(y)=a+bx transformation
lr.out = lm(sqrt(dataset2$mpm1)~dataset2$num_arcs)

ggplot(dataset2, aes(num_arcs, sqrt(mpm1))) + geom_point() +
  geom_smooth(method="lm", formula="y~x", se=FALSE) +
  annotate(
    geom="text",
    x=40000,
    y=0.125, 
    label=paste(
      "y=",
      formatC(lr.out[["coefficients"]][["(Intercept)"]], format='e', digits=3),
      "+",
      formatC(lr.out[["coefficients"]][["dataset2$num_arcs"]], format='e', digits=3),
      "b, r²=",
      formatC(summary(lr.out)$r.squared, digits=4))
  ) +
  labs(
    title="MPM [400 vertices, 100 max capacity]",
    x="Number of Arcs (A)",
    y="sqrt(Time) (seconds)"
  ) + theme_bw()

summary(lr.out)
par(mfcol=c(1,2))
plot(lr.out, which=1, ask=FALSE)
plot(lr.out, which=2, ask=FALSE)

### DATASET 3 ###

## EK ##
# scatter plot
ggplot(dataset3, aes(num_arcs, ek1)) + geom_point() +
  labs(
    title="EK [1000 vertices, 100 max capacity]",
    x="Number of Arcs (A)",
    y="Time (seconds)"
  ) + theme_bw()

# linear regression with sqrt(y)=a+bx transformation
lr.out = lm(sqrt(dataset3$ek1)~dataset3$num_arcs)

ggplot(dataset3, aes(num_arcs, sqrt(ek1))) + geom_point() +
  geom_smooth(method="lm", formula="y~x", se=FALSE) +
  annotate(
    geom="text",
    x=250000,
    y=3.5, 
    label=paste(
      "y=",
      formatC(lr.out[["coefficients"]][["(Intercept)"]], format='e', digits=3),
      "+",
      formatC(lr.out[["coefficients"]][["dataset3$num_arcs"]], format='e', digits=3),
      "b, r²=",
      formatC(summary(lr.out)$r.squared, digits=4))
  ) +
  labs(
    title="EK [1000 vertices, 100 max capacity]",
    x="Number of Arcs (A)",
    y="sqrt(Time) (seconds)"
  ) + theme_bw()

summary(lr.out)
par(mfcol=c(1,2))
plot(lr.out, which=1, ask=FALSE)
plot(lr.out, which=2, ask=FALSE)

## Dinic ##
# scatter plot
ggplot(dataset3, aes(num_arcs, dinic1)) + geom_point() +
  labs(
    title="Dinic [1000 vertices, 100 max capacity]",
    x="Number of Arcs (A)",
    y="Time (seconds)"
  ) + theme_bw()

# linear regression y=a+bx
lr.out = lm(dataset3$dinic1~dataset3$num_arcs)

ggplot(dataset3, aes(num_arcs, dinic1)) + geom_point() +
  geom_smooth(method="lm", formula="y~x", se=FALSE) +
  annotate(
    geom="text",
    x=250000,
    y=0.045, 
    label=paste(
      "y=",
      formatC(lr.out[["coefficients"]][["(Intercept)"]], format='e', digits=3),
      "+",
      formatC(lr.out[["coefficients"]][["dataset3$num_arcs"]], format='e', digits=3),
      "b, r²=",
      formatC(summary(lr.out)$r.squared, digits=4))
  ) +
  labs(
    title="Dinic [1000 vertices, 100 max capacity]",
    x="Number of Arcs (A)",
    y="Time (seconds)"
  ) + theme_bw()

summary(lr.out)
par(mfcol=c(1,2))
plot(lr.out, which=1, ask=FALSE)
plot(lr.out, which=2, ask=FALSE)

## MPM ##
# scatter plot
ggplot(dataset3, aes(num_arcs,mpm1)) + geom_point() +
  labs(
    title="MPM [1000 vertices, 100 max capacity]",
    x="Number of Arcs (A)",
    y="Time (seconds)"
  ) + theme_bw()

# linear regression y=a+bx
lr.out = lm(dataset3$mpm1~dataset3$num_arcs)

ggplot(dataset3, aes(num_arcs, mpm1)) + geom_point() +
  geom_smooth(method="lm", formula="y~x", se=FALSE) +
  annotate(
    geom="text",
    x=250000,
    y=0.175, 
    label=paste(
      "y=",
      formatC(lr.out[["coefficients"]][["(Intercept)"]], format='e', digits=3),
      "+",
      formatC(lr.out[["coefficients"]][["dataset3$num_arcs"]], format='e', digits=3),
      "b, r²=",
      formatC(summary(lr.out)$r.squared, digits=4))
  ) +
  labs(
    title="MPM [1000 vertices, 100 max capacity]",
    x="Number of Arcs (A)",
    y="Time (seconds)"
  ) + theme_bw()

summary(lr.out)
par(mfcol=c(1,2))
plot(lr.out, which=1, ask=FALSE)
plot(lr.out, which=2, ask=FALSE)

# linear regression with sqrt(y)=a+bx transformation
lr.out = lm(sqrt(dataset3$mpm1)~dataset3$num_arcs)

ggplot(dataset3, aes(num_arcs, sqrt(mpm1))) + geom_point() +
  geom_smooth(method="lm", formula="y~x", se=FALSE) +
  annotate(
    geom="text",
    x=250000,
    y=0.45, 
    label=paste(
      "y=",
      formatC(lr.out[["coefficients"]][["(Intercept)"]], format='e', digits=3),
      "+",
      formatC(lr.out[["coefficients"]][["dataset3$num_arcs"]], format='e', digits=3),
      "b, r²=",
      formatC(summary(lr.out)$r.squared, digits=4))
  ) +
  labs(
    title="MPM [1000 vertices, 100 max capacity]",
    x="Number of Arcs (A)",
    y="sqrt(Time) (seconds)"
  ) + theme_bw()

summary(lr.out)
par(mfcol=c(1,2))
plot(lr.out, which=1, ask=FALSE)
plot(lr.out, which=2, ask=FALSE)