
library(ggplot2)

ggplot(grades)+geom_point(aes(x=e1,y=e2,shape=factor(success),color=factor(success)))+
  labs(x="Exam 1 score",y="Exam 2 score")+
  scale_colour_manual(name=NULL,
                      labels = c("Not admitted","Admitted"),
                      values = c("red","black")) +   
  scale_shape_manual(name=NULL,
                     labels = c("Not admitted","Admitted"),
                     values = c(16, 3)) +
  theme(legend.position=c(0.85,.85),panel.background=element_rect(fill="transparent"),
        axis.line=element_line(color="#d9d9d9"),
        legend.background = element_blank(),
        legend.box.background = element_rect(colour = "black"))
  



#testing