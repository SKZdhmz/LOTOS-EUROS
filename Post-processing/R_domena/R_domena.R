# LOTOS_EUROS čita domenu iz LE meteo file-a, potrebno ga je staviti u input direktorij s imenom "LE_v2-1-001_meteo.*_20160102.nc"
library("ncdf4")
library("raster")
library("rworldmap")
library("rworldxtra")
#setwd("F:/Programs/R/LOTOS-EUROS")

for (i in 1:2) {
  png(paste0(".\\output/LE_domena_",i,".png"),width=8,height = 8,units = "in",res=300,pointsize = 18)
      
  #file iz kojeg cita orografiju
  ras<-raster(dir("../input/",pattern = "LE_v2-1-001_meteo.*_20160102.nc",full.names = T)[i],varname="oro")
  plot(ras,xlab="Lon [°]",ylab="Lat [°]",main="Orography")
  if (res(ras)[1]>0.2) plot(getMap(resolution = "coarse"),add=T)
  else plot(getMap(resolution = "high"),add=T)
  mtext("m", side = 4, line = 0.3, outer = FALSE, at = NA,adj = NA, padj = NA, cex = NA, col = NA, font = NA)
  
  # ako je domena velika onda crta HR domenu definirana poligonom, potrebno je jos jasno definirati HR domenu
  if (extent(ras)[1]<10 || extent(ras)[2]>22 || extent(ras)[3]<41 || extent(ras)[4]>48) polygon(x=c(11,11,21,21), y =c(42,47,47,42) ,border="red",lwd = 2)
  dev.off()
}

#DOMENE MACC-II,III CEIP, LE MACC MACC-II
{
#png(paste0(".\\output/Domene_modela.png"),width=14,height = 8,units = "in",res=300,pointsize = 18)
par(mar=c(5.1, 4.1, 4.1, 6.1), xpd=F)
plot(NULL,xlim=c(-30,90),ylim=c(30,85),asp=1,xlab="Lon [°]",ylab="Lat [°]",main="Domene ulaznih podataka")
plot(getMap(resolution = "high"),add=T)

#CEIP -30,90	30,82
polygon(x=c(-30,-30,90,90), y =c(30,82,82,30) ,border="purple",lwd = 2)
#MACC 2/3 -30,60	30,72
polygon(x=c(-30,-30,60,60), y =c(30,72,72,30) ,border="red",lwd = 2)
#meteo
#polygon(x=c(11,11,21,21), y =c(42,47,47,42) ,border="red",lwd = 2)
#LE
#MACC-II -25,45	30,70
polygon(x=c(-25,-25,45,45), y =c(30,70,70,30) ,border="blue",lwd = 2)
#MACC -15,35	35,70
polygon(x=c(-15,-15,35,35), y =c(35,70,70,35) ,border="green",lwd = 2)
#HR
polygon(x=c(11,11,21,21), y =c(42,47,47,42) ,border="orange",lwd = 2)


par(mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)
legend("topright", bty="n",inset=c(-0.17,0),cex=0.7, legend=c("Em. MACC-II/III","Em. CEIP","LE MACC","LE MACC-II","LE HR"),lty = 1,col=c("red","purple","green","blue","orange"))
#dev.off()

}

