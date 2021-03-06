NanoMean = function(excitation = c(220,450,5), emission = c(230, 600, 2), EMCOL = F, split="_", RU = F,
                    data.file, fluorometer, EEMskip, sd=F)

{
	wlex = seq(excitation[1], excitation[2], excitation[3])
	wlem = seq(emission[1], emission[2], emission[3])
	nex = length(wlex)
	nem  = length(wlem)
  
	subfolder = "/nano/"
	filename = list()
	counter = 1
	data.list = list()
	index = 0
	list.length = 0
	file.list = list.files(paste0("./",data.file,"/nano")) #was file.dir
	#fdom.temp = grep("FDOM", file.dir)
	#cdom.temp = grep("CDOM", file.dir)
	#file.dir = file.dir[-fdom.temp]
	#file.dir = file.dir[-cdom.temp]
	#file.list = list()

	#for(i in 1:length(file.dir))
	#{
	  #file.list[[i]] = paste(file.dir[i], "/", list.files(file.dir[i]), sep = "")
	#}
	file.data = unlist(file.list)
  
	if(length(file.data) > 1)
	{
		for (i in 1:length(file.data))
		{
			EEM = read.EEM(file.data[i], excitation, emission, EMCOL, counter, split = split,
			               fluorometer = fluorometer, EEMskip = EEMskip, data.file = data.file,
			               subfolder = subfolder)
			data.list[[i + index]] = EEM$EEM.list
			filename[[i + index]] = unlist(EEM$EEM.name)
			index = index + length(file.data)
			list.length = list.length + length(file.data) * counter
		}
	}
	else
	{
		if(length(file.data) == 1)
		{
			EEM = read.EEM(file.data, excitation, emission, EMCOL, counter, split = split,
			               fluorometer = fluorometer, EEMskip = EEMskip, data.file = data.file,
			               subfolder = subfolder)
			data.list[[index + 1]] = EEM$EEM.list
			filename[[index + 1]] = unlist(EEM$EEM.name)
			index = index + 1
			list.length = list.length + counter
		}
	}
	
	nano = array(unlist(data.list), dim = c(nex, nem, length(file.data)))
	dummy = array(0, dim = c(nex, nem, 1))
	for (i in 1:length(file.data))
	{
		dummy[,,1] = nano[,,i] + dummy[,,1]
	}
	dummy = dummy / length(file.data) #Calculate mean of nano files
	
	if(sd)
	{
	  ecartype = apply(nano,1:2,sd) #calculate sd of nano files
	  ecartype = list(EEM.list = list(eem=ecartype), wlex = wlex, wlem = wlem)
	  return(ecartype)
	}
	
	if(RU)
	{
		data = list(EEM.list = list(eem=dummy), wlex = wlex, wlem = wlem)
		return(data)
	}
	return(dummy)	
}
