### DATASETS
# In most instances where a repeated measures test could be done
# a non repeated measures is done despite the input being measured multiple times
# as this does not lead to a problem as long as it is remembered that
# the non repeated measures test will be more conservative in relation to
# the repeated measures tests

# dataset1: num_verts=[1000];prob_arc=[1.0];max_cap=[10,500,1000]
# > ./gen_ranges.sh 10 10 1 1 1000 100 1111
# > ./gen_ranges.sh 500 500 1 1 1000 100 1112
# > ./gen_ranges.sh 1000 1000 1 1 1000 100 1113
data1 <- read.table("hipo1_data", head=T)

# dataset2: num_verts=[1000];prob_arc=[0.2;0.5;1.0];max_cap=[100]
# > ./gen_arcs.sh 20 20 1 1 1000 100 1111
# > ./gen_arcs.sh 50 50 1 1 1000 100 1112
# > ./gen_arcs.sh 100 100 1 1 1000 100 1113
data2 <- read.table("hipo2_data", head=T)

# dataset3: num_verts=[500,1000,2000];prob_arc=[0.2;1.0];max_cap=[100]
# > ./gen_arcs.sh 20 100 90 1 500 100 1111
# > ./gen_arcs.sh 20 100 90 1 1000 100 1112
# > ./gen_arcs.sh 20 100 90 1 2000 100 1113
data3 <- read.table("hipo3_data", head=T)
#----------------------------------------------------------------------------
### HYPOTHESIS TESTING
## Hypothesis 1
#----------
# MPM
data1mpm <- data1[data1$algo == "mpm",]

# One-Way ANOVA (parametric)
m.mpm <- aov(time ~ max_cap, data=data1mpm)
summary(m.mpm)
# Assumptions
plot(m.mpm)
# homoskedasticity and normality of residuals hold
# Post-hoc analysis
pairwise.t.test(data1mpm$time, data1mpm$max_cap, p.adjust.method = "holm")
# there is a difference between a low max_cap (10) and higher levels of that factor(500, 1000)
# mpm is faster with low max_cap (paths saturate quicker -> less options left to build flow -> less iterations)
#----------
# EK
data1ek <- data1[data1$algo == "ek",]

# One-Way ANOVA (parametric)
m.ek <- aov(time ~ max_cap, data=data1ek)
summary(m.ek)
# Assumptions
plot(m.ek)
shapiro.test(residuals(m.ek))
# homoskedasticity holds, but not normality of residuals

# Kruskal-Wallis Analysis
kruskal.test(time ~ max_cap, data=data1ek)
# Post-hoc analysis
pairwise.wilcox.test(data1ek$time, data1ek$max_cap, p.adjust.method = "holm")
#----------
# Dinic
data1dinic <- data1[data1$algo == "dinic",]

# One-Way ANOVA (parametric)
m.dinic <- aov(time ~ max_cap, data=data1dinic)
summary(m.dinic)
# Assumptions
plot(m.dinic)
shapiro.test(residuals(m.dinic))
# homoskedasticity holds, but not normality of residuals

# Kruskal-Wallis Test (non-parametric)
kruskal.test(time ~ max_cap, data=data1dinic)
# Post-hoc analysis
pairwise.wilcox.test(data1dinic$time, data1dinic$max_cap, p.adjust.method = "holm")

#----------------------------------------------------------------------------
## Hypothesis 2
data2mpm <- data2[data2$algo=="mpm",]

# Repeated measures one way ANOVA (parametric)
mm2 <- aov(time ~ num_arcs + Error(factor(measure)), data=data2mpm)
summary(mm2)
# H0 is rejected -> num_arcs influences mpm execution time when num_verts=1000 and max_cap=100
# Assumptions
qqnorm(residuals(mm2$Within))
qqline(residuals(mm2$Within))
shapiro.test(residuals(mm2$Within))
# sphericity (cannot install afex)
# normality of residuals holds therefore we advance to post hoc analysis

# Post-hoc analysis
pairwise.t.test(data2mpm$time, data2mpm$num_arcs, paired=T, p.adjust.method = "holm")
interaction.plot(data2mpm$num_arcs, data2mpm$measure, data2mpm$time)
# all levels of the factor num_arcs lead to different execution times

# [OPTIONAL]
# Friedman Test (non-parametric)
friedman.test(time ~ num_arcs | measure, data=data2mpm)
# Post-hoc analysis
pairwise.wilcox.test(data2mpm$time, data2mpm$num_arcs, paired=T, p.adjust.method = "holm")

#----------------------------------------------------------------------------
## Hypothesis 3
data3mpm <- data3[data3$algo=="mpm",]

# 2-way ANOVA (parametric)
m3 <- aov(time ~ num_verts * prob_arc, data=data3mpm)
summary(m3)
# Assumptions
plot(m3)
# assumptions do not hold, fails homoskedasticity of residuals and normality of residuals
# therefore a non-parametric randomization test is needed

# Randomization Test (non-parametric)
aov.out = aov(time ~ num_verts * prob_arc, data=data3mpm)
Fver = summary(aov.out)[[1]]$F[1]
Farc = summary(aov.out)[[1]]$F[2]
Fint = summary(aov.out)[[1]]$F[3]
Tver = c(Fver)
Tarc = c(Farc)
Tint = c(Fint)
for (i in 1:4999) {
  data3mpm$time = sample(data3mpm$time)
  aov.out = aov(time ~ num_verts * prob_arc, data=data3mpm)
  rFver = summary(aov.out)[[1]]$F[1]
  rFarc = summary(aov.out)[[1]]$F[2]
  rFint = summary(aov.out)[[1]]$F[3]
  Tver = c(Tver, rFver)
  Tarc = c(Tarc, rFarc)
  Tint = c(Tint, rFint)
}
print(length(Tver[Tver >= Fver]) / 5000)
print(length(Tarc[Tarc >= Farc]) / 5000)
print(length(Tint[Tint >= Fint]) / 5000)

# all H0 are rejected
# num_verts influences execution time of mpm
# prob_arc influences execution time of mpm
# num_verts and prob_arc interact
  
#----------------------------------------------------------------------------
## Hypothesis 4

# Three-way ANOVA (parametric)
m4 <- aov(time ~ factor(num_verts)*factor(prob_arc)*factor(algo), data=data3)
summary(m4)

# Assumptions
plot(m4)
# unsure about homoskedasticity of residuals, but normality holds

# Post-hoc analysis
interaction.plot(data3$num_verts, data3$algo, data3$time)
interaction.plot(data3$prob_arc, data3$algo, data3$time)
interaction.plot(data3$num_verts, data3$prob_arc, data3$time)

## excluding EK; the slowest
data3fast <- data3[data3$algo %in% c("mpm", "dinic"), ]
interaction.plot(data3fast$num_verts, data3fast$algo, data3fast$time)
interaction.plot(data3fast$prob_arc, data3fast$algo, data3fast$time)
interaction.plot(data3fast$num_verts, data3fast$prob_arc, data3fast$time)

TukeyHSD(m4)
# HELP interperting this :)

# all factors influence execution time and interact with each other

#----------------------------------------------------------------------------
## Hypothesis 5
data5 <- data3[data3$num_verts %in% c(1000,2000), ]

# One-way ANOVA (parametric)
m5 <- aov(time ~ algo, data=data5)
summary(m5)
# Reject H0, execution time is different between at least one pair of algorithms

# Assumptions
plot(m5)

# Post-hoc analysis
pairwise.t.test(data5$time, data5$algo, p.adjust.method = "holm")
# at significance level 5% ek is significantly different from mpm and dinic
# we can say that ek is overall slowest, but we cannot say that dinic is the fastest

# [OPTIONAL]
# Kruskal-Wallis Test (non-parametric)
kruskal.test(time ~ algo, data=data5)
# there is a difference between execution times from algorithms (p-value < 0.05)

# Post-hoc analysis
pairwise.wilcox.test(data5$time, data5$algo, p.adjust.method = "holm")
# execution time varies between all algorithms

