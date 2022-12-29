
build_segment <- function(min,max,increment,inner_radius,outer_radius){
  x <- c()
  y <- c()
  
  for(i in seq(min, max, increment)){
    x1 <- inner_radius * sin(2*pi*(i/360))
    y1 <- inner_radius * cos(2*pi*(i/360))
    x <- c(x,x1)
    y <- c(y,y1)
  }
  
  for(j in seq(max, min, -increment)){
    x2 <- outer_radius * sin(2*pi*(j/360))
    y2 <- outer_radius * cos(2*pi*(j/360))
    x <- c(x,x2)
    y <- c(y,y2)
  }
  
  path <- 1:length(x)
  
  df <- data.frame(x = x,y = y,path = path,stringsAsFactors = F)
  return(df)
}


n_rings <- 15
n_questions <- 73
radius_start <- 5
radius_increase <- 0.25

inner_radius <- c()
outer_radius <- c()

for(r in 1:n_rings){
  inner_radius <- c(inner_radius,rep(radius_start + (radius_increase*(r-1)),n_questions))
  outer_radius <- c(outer_radius,rep(radius_start + (radius_increase*(r)),n_questions))
}

min <- rep(0:(n_questions-1) *(360/n_questions),n_rings)
max <- rep(1:n_questions *(360/n_questions),n_rings)
increment <- rep(360/(n_questions*10),n_questions * n_rings)

levels_df <- data.frame(min = min,
                        max = max,
                        increment = increment,
                        inner_radius = inner_radius,
                        outer_radius = outer_radius,
                        stringsAsFactors = F)


n <- nrow(levels_df)

sunburst_list = vector("list", length = n)

for(a in 1:nrow(levels_df)){
  
  df <- build_segment(levels_df$min[a],levels_df$max[a],levels_df$increment[a],levels_df$inner_radius[a],levels_df$outer_radius[a])
  df$id <- a
  sunburst_list[[a]] <- df
}
sunburst_df <- do.call(rbind, sunburst_list)

plot(sunburst_df$x,sunburst_df$y,type="n")
polygon(sunburst_df$x,sunburst_df$y)


write.csv(sunburst_df,"test_sunburst.csv",row.names = F)

