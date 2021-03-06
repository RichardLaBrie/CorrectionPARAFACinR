#'@title Creates data folder, subfolder and R project

#'@description This function creates folders and .Rproj file require by the various functions to work.
#'These steps can be done by hand instead.

#'@param WDpath the path to the working directory 
#'@param folder is the name of the folder containing subfiles parameter. Default is "data"
#'@param subfiles is the list of folder where to put cdom, fdom and nano water samples
#'@param example TRUE if you wich to donwload exemple files to test the package

#'@export

#Example: FolderCreation(path.to.folder = "D:/test", WorkingDirectory = "test")

FolderCreation <- function(WDpath=".", folder = "data", subfiles = c("CDOM","FDOM","nano"),example=TRUE)
{
  if(dir.exists(paste0(WDpath,"\\",folder))){ stop("The data folder already exists")}
  
  dir=basename(WDpath)
  if(dir=="."){dir=basename(getwd())}
  
  path <- file.path(WDpath, paste0(dir, ".Rproj"))
  template_path <- system.file("templates/template.Rproj", package = "devtools")
  file.copy(template_path, path)
  
  dir.create(file.path(WDpath,folder), showWarnings = T)
  for(i in 1:3)
  {
    dir.create(file.path(WDpath,folder,subfiles[i]), showWarnings = FALSE)
  }
  
  if(example){ 
    #remove(files)
    download.file("https://raw.githubusercontent.com/RichardLaBrie/paRafac_correction/master/example_paths.csv", paste0(folder,"/example_paths.csv"), method="libcurl")
    files=data.frame(path=read.csv(paste0(folder,"/example_paths.csv"))[2])
    file.remove(paste0(folder,"/example_paths.csv"))
    files$urls=paste0("https://raw.githubusercontent.com/RichardLaBrie/paRafac_correction/master/data",files$paths)
    files$paths_samples=paste0(WDpath,"\\",folder,files$paths)
    for(i in 1:38){
      download.file(as.character(files$urls[i]), as.character(files$paths_samples[i]), method="libcurl",quiet =F)}
    
    files$urls=paste0("https://raw.githubusercontent.com/RichardLaBrie/paRafac_correction/master/",files$paths)
    files$paths=paste0(WDpath,"\\",files$paths)
    for(i in c(39,40)){
      download.file(as.character(files$urls[i]), as.character(files$paths[i]), method="libcurl",quiet =F)}
  }
  
}
