# LOTOS-EUROS-post-processing
Post processing za LOTOS-EUROS

## Uvod
Program za animaciju 2-D polja koncentracije polutanata i prikaz LE domene. 

## Domena
Domena je određena ulaznim podacima kao što su emisije, meteorologija itd. Osnovni run LE korsti MACC domenu.

Ulazni podaci |	Naziv |	Lon [°] |	Lat [°] |	Rezolucija (lon x lat) [°]
--- | --- | --- | --- | ---
Emisije |	MAC-II (SNAP) |	-30,60 |	30,72 |	0.125 x 0.0625
Emisije |		MACC-III (SNAP) |	-30,60 |	30,72 |	0.125 x 0.0625
Emisije |		CEIP (GNFR) |	-30,90 |	30,82	0.1 | x 0.1
Meteo |	ECMWF (meteo tools) |	-46.125,84.094 |	25.935,78.0866 |	F640, (360/4N,90/N) (0.140625 x 0.140625)
LE domena (rc file) |	MACC |	-15,35 |	35,70 |	0.5 x 0.25
LE domena (rc file) |		MACC-II |	-25,45 |	30,70 |	0.5 x 0.25
LE domena (rc file) |		HR |	13°,20° |	42°,47° |	0.125 x 0.0625



![](./images/Domene.png)
*Različite domene uaznih podataka*
