
# Function: build_block
# Input: Parameters for radial heatmap block, min and max are the angles
# Returns: The x,y coordinates for an individual block for a radial heatmap as a data.frame

build_block <- function(min,max,increment,inner_radius,outer_radius){
  
  # Imagine a rectangle curved to fit into a circle
  # This section curves the top and bottom lines of rectangle to form a radial
  
  # Initialise two lists
  x <- c()
  y <- c()
  
  # Curve bottom line of a rectangle
  for(i in seq(min, max, increment)){
    x1 <- inner_radius * sin(2*pi*((90 - i)/360))
    y1 <- inner_radius * cos(2*pi*((90 - i)/360))
    x <- c(x,x1)
    y <- c(y,y1)
  }
  
  # Curve top line of a rectangle
  for(j in seq(max, min, -increment)){
    x2 <- outer_radius * sin(2*pi*((90 - j)/360))
    y2 <- outer_radius * cos(2*pi*((90 - j)/360))
    x <- c(x,x2)
    y <- c(y,y2)
  }
  
  # Create geometry path to draw block
  path <- 1:length(x)
  
  # Create data.frame of x,y coordinates
  df <- data.frame(
    x = x,
    y = y,
    path = path,
    stringsAsFactors = F)
  
  # Output data.frame
  return(df)
}

# Function: build_radial_amp
# Depends on: build_block
# Input: Parameters for number of rings, segments, and dimensions
# Returns: Data.frame of all radial heatmap blocks, with x,y coordinates

build_radial_map <- function(n_rings,n_segments,radius_start,radius_increase){
  
  # Initialise two lists
  inner_radius <- c()
  outer_radius <- c()
  
  # Create two list of data points for radius of the upper and lower rings
  for(r in 1:n_rings){
    inner_radius <- c(inner_radius,rep(radius_start + (radius_increase*(r-1)),n_segments))
    outer_radius <- c(outer_radius,rep(radius_start + (radius_increase*(r)),n_segments))
  }
  
  # Create lists upper and lower rectangle dimensions, 
  # with additional datapoints to help a smooth image when converting to radial
  min <- rep(0:(n_segments-1) *(360/n_segments),n_rings)
  max <- rep(1:n_segments *(360/n_segments),n_rings)
  increment <- rep(360/(n_segments*10),n_segments * n_rings)
  
  # Add all lists to a data.frame
  levels_df <- data.frame(
    min = min,
    max = max,
    increment = increment,
    inner_radius = inner_radius,
    outer_radius = outer_radius,
    stringsAsFactors = F)
  
  # Calculate the number of iterations 
  n <- nrow(levels_df)
  
  # Initialise list to store output of loop
  radial_heatmap_list = vector("list", length = n)
  
  # Loop over levels_df data.frame with build_block function
  for(a in 1:n){
    
    # Convert rectangles to radial blocks
    df <- build_block(
      levels_df$min[a],
      levels_df$max[a],
      levels_df$increment[a],
      levels_df$inner_radius[a],
      levels_df$outer_radius[a])
    
    # Add dimensions for joining
    df$block_id <- a
    df$ring <- floor((a-1) / n_segments) +1 
    df$segment <- ifelse(a %% n_segments == 0,n_segments,a %% n_segments)
    
    # Add loop result to list of data.frames
    radial_heatmap_list[[a]] <- df
  }
  
  # Combine all data.frames in list together
  radial_heatmap_df <- do.call(rbind, radial_heatmap_list)
  
  # Output the radial heatmap coordinates
  return(radial_heatmap_df)
}

# Create a radial with some parameters
radial_heatmap_df <- build_radial_map(
                          n_rings = 3,
                          n_segments = 12,
                          radius_start = 1,
                          radius_increase = 0.5)

# create a plot of the output radial heatmap
plot(radial_heatmap_df$x,radial_heatmap_df$y,type="n",xlab ='x', ylab = 'y')
polygon(radial_heatmap_df$x,radial_heatmap_df$y)

# write output data to csv
write.csv(radial_heatmap_df,"radial_heatmap.csv",row.names = F)


