#Program radi animacije polja iz netCDF formata LOTOS-EUROS modela. Ulazni podaci mogu biti iz više domena, pa ih spaja i crta (ncfile[[]] staviti redom od vece prema manjoj domeni).

# dodatni paketi
library("ncdf4")
library("raster")
library("rworldmap")
library("rworldxtra")
library("viridis")
#setwd("F:/Programs/R/LOTOS-EUROS")
Nlev <- 50 # broj razlicitih boja
boja <- c("#FFFFFF","#FFFFFF",rev(inferno(Nlev))[1:30])

############################
########## CONFIG ##########
############################

#datoteke s poljima, od vece prema manjoj domeni
ncfile<-list()
ncfile[[1]]<-nc_open("../input/LE_conc-sfc.nc")
ncfile[[2]]<-nc_open("../input/LE_conc-sfc-HR.nc")
# bira se polje, jedno ili više
#names(ncfile[[1]]$var)
polje<-"tpm10"
# za svako polje potrebno je definirati konverzijski faktor
fact<-data.frame(o3=2*10^9,tpm10=10^9)
# mjerna jednicia
mj<-list()
mj[["o3"]]<-expression(ppm)
mj[["tpm10"]]<-expression(mu~g/m^3)
#nazi run-a/intervala/animacije npr. zima,ljeto,wrf,ecmwf
ime<-"HR"
#period animacije polja s korakom 1=1h
t_anim<-seq(1050,1175,1)
#t_anim<-seq(1094,1094,1)
#vanjska domena
xl<-c(8,24)
yl<-c(39,50)
#interval zatraženog datuma
as.POSIXlt(ncfile[[1]]$dim$time$vals[t_anim[1]], origin = strsplit(ncfile[[1]]$dim$time$units,split = "since ")[[1]][2])
as.POSIXlt(ncfile[[1]]$dim$time$vals[rev(t_anim)[1]], origin = strsplit(ncfile[[1]]$dim$time$units,split = "since ")[[1]][2])

############################
####### CONFIG END #########
############################

rng<-NULL
for (i in polje) {
      #odredi raspon polja (min,max)
      if (i==polje[1]) {
            origin<-strsplit(ncfile[[1]]$dim$time$units,split = "since ")[[1]][2]
            for (k in 2:length(ncfile))
            rng<-range(rng,ncvar_get(ncfile[[k]],varid = i)[,,t_anim]*as.numeric(fact[i]))
            # provjera origina
            if(strsplit(ncfile[[k]]$dim$time$units,split = "since ")[[1]][2]!=origin) stop("origin u file-u nije isti")
      }
      
      #petlja po terminima/intervalu "t_anim"
      for (tt in t_anim){
            
            #naslov/ime polje/datum
            naslov<-paste0(ime,"_",i,", ",format( as.POSIXlt(ncfile[[1]]$dim$time$vals[tt], origin = strsplit(ncfile[[1]]$dim$time$units,split = "since ")[[1]][2]), format = "%Y-%m-%d %H h"))
            
            #kvaliteta slike res=300
            png(paste0(".\\output\\",naslov,".png"),width=8,height = 8,units = "in",res=100,pointsize = 18)          
            
            #petlja po domenama (ncfile)
            for (k in 1:length(ncfile)){  
                  
                  #cita raster i množi ga s faktorom
                  ras<-raster(ncfile[[k]]$filename,varname=i,band=tt)*as.numeric(fact[i])
                  
                  if (k==1) {
                        plot(ras,xlab="Lon [°]",ylab="Lat [°]",main=naslov,zlim=rng,col = boja,xlim=xl,ylim=yl)
                        parametri<-par()
                        }
                  #if (k==1) plot(ras,xlab="Lon [°]",ylab="Lat [°]",main=naslov,zlim=rng,col = boja)
                  else {
                        plot(ras,xlab="Lon [°]",ylab="Lat [°]",main=naslov,zlim=rng,col = boja,add=T)
                        
                        }
                  #dodavanje karte
                  par(parametri)
                  plot(getMap(resolution = "high"),add=T)
                  #poligon domene
                  polygon(x=c(extent(ras)[1],extent(ras)[1],extent(ras)[2],extent(ras)[2]), y =c(extent(ras)[3],extent(ras)[4],extent(ras)[4],extent(ras)[3]) ,border="red",lwd = 2)
                  #mjerne jedinice
                  mtext(text = mj[[i]], side = 4, line = 0.3, outer = FALSE, at = NA,adj = NA, padj = NA, cex = NA, col = NA, font = NA)
            }
            
            dev.off()
      }
      # opcija za brzinu "-delay 6"
      shell(paste0("convert.exe -delay 6 output/*",ime,"_",i,"*.png ",ime,"_", i,".gif"))
}


