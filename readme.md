* Compilation on Switch
```
cmake -DCMAKE_TOOLCHAIN_FILE=../xerces-c-1/switch.toolchain.cmake -Dtranscoder=iconv -Dmutex-manager=nothreads -Dnetwork=OFF -Dsse2=OFF -Dthreads=OFF -DBUILD_SHARED_LIBS=OFF -Dxmlch-type=uint16_t -DULONG_MAX=4294967295 ../xerces-c-1/
cmake -DCMAKE_TOOLCHAIN_FILE=../xerces-c-1/switch.toolchain.cmake -Dtranscoder=iconv -Dmutex-manager=nothreads -Dnetwork=OFF -Dsse2=OFF -Dthreads=OFF -DBUILD_SHARED_LIBS=OFF -Dxmlch-type=uint16_t -DULONG_MAX=4294967295 ../xerces-c-1/
cmake -DCMAKE_TOOLCHAIN_FILE=../xerces-c-1/switch.toolchain.cmake -Dtranscoder=iconv -Dmutex-manager=nothreads -Dnetwork=OFF -Dsse2=OFF -Dthreads=OFF -DBUILD_SHARED_LIBS=OFF -Dxmlch-type=uint16_t -DULONG_MAX=4294967295 ../xerces-c-1/
manager=nothreads -Dnetwork=OFF -Dsse2=OFF -Dthreads=OFF -DBUILD_SHARED_LIBS=OFF -Dxmlch-type=uint16_t -DULONG_MAX=4294967295 ../xerces-c-1/
make -j10
sudo -E make install
```
