library(devtools)
library(roxygen2)        


#create("TestR")
package_name <- 'TestPackage'
network_wdir <- getwd()
local_wdir <- "E:/Work_temp"

file.copy(from= file.path(network_wdir, package_name), to = local_wdir, 
          overwrite = TRUE, recursive = T, copy.mode = TRUE)

setwd(file.path(local_wdir, package_name))
roxygenise()


file.copy(from = file.path(local_wdir, package_name), to = network_wdir, 
          overwrite = TRUE, recursive = T, 
          copy.mode = TRUE)
setwd(network_wdir)
unlink(file.path(local_wdir, package_name), recursive = T)

####################
