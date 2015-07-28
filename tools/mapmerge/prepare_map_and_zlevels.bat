set MAPFILE=tgstation.2.1.3.dmm
set MAPFILEz2=z2.dmm
set MAPFILEz3=z3.dmm
set MAPFILEz4=z4.dmm
set MAPFILEz5=z5.dmm
set MAPFILEz6=z6.dmm
set MAPFILEz7=z7.dmm

cd ../../_maps/map_files/TgStation/
copy %MAPFILE% %MAPFILE%.backup

cd ../generic/
copy %MAPFILEz2% %MAPFILEz2%.backup
copy %MAPFILEz3% %MAPFILEz3%.backup
copy %MAPFILEz4% %MAPFILEz4%.backup
copy %MAPFILEz5% %MAPFILEz5%.backup
copy %MAPFILEz6% %MAPFILEz6%.backup
copy %MAPFILEz7% %MAPFILEz7%.backup

pause
