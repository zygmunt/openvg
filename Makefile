PREFIX=/usr
LIBDIR=$(PREFIX)/lib
INCDIR=$(PREFIX)/include

VC_LIBDIR ?= /opt/vc/lib
VC_INCDIR ?= /opt/vc/include

INCLUDEFLAGS=-I$(VC_INCDIR) -I$(VC_INCDIR)/interface/vmcs_host/linux -I$(VC_INCDIR)/interface/vcos/pthreads 
LIBFLAGS=-L$(VC_LIBDIR) -lEGL -lGLESv2 -ljpeg

#-fPIC
# FONTLIB=/usr/share/fonts/truetype/ttf-dejavu
# FONTFILES=DejaVuSans.inc  DejaVuSansMono.inc DejaVuSerif.inc

LIBRARY=libshapes.so

# HOST_CXX ?= $(CXX)

# fonts: font2openvg $(FONTFILES)

all: libshapes.so

libshapes.o:
	$(CC) -O2 -Wall $(INCLUDEFLAGS) -c libshapes.c $(CFLAGS)

oglinit.o:
	$(CC) -O2 -Wall $(INCLUDEFLAGS) -c oglinit.c $(CFLAGS)

$(LIBRARY): oglinit.o libshapes.o
	$(CC) $(LIBFLAGS) -shared -o $(LIBRARY) oglinit.o libshapes.o $(CFLAGS)

#gopenvg: openvg.go
#	go install .

# font2openvg:
# 	$(HOST_CXX) -I/usr/include/freetype2 fontutil/font2openvg.cpp -o font2openvg -lfreetype
# 
# DejaVuSans.inc: font2openvg $(FONTLIB)/DejaVuSans.ttf
# 	./font2openvg $(FONTLIB)/DejaVuSans.ttf DejaVuSans.inc DejaVuSans
# 
# DejaVuSerif.inc: font2openvg $(FONTLIB)/DejaVuSerif.ttf
# 	./font2openvg $(FONTLIB)/DejaVuSerif.ttf DejaVuSerif.inc DejaVuSerif
# 
# DejaVuSansMono.inc: font2openvg $(FONTLIB)/DejaVuSansMono.ttf
# 	./font2openvg $(FONTLIB)/DejaVuSansMono.ttf DejaVuSansMono.inc DejaVuSansMono

clean:
	rm -f *.o *.so font2openvg *.c~ *.h~

install_headers:
	install -m 644 -p shapes.h $(DESTDIR)$(INCDIR)/
	install -m 644 -p fontinfo.h $(DESTDIR)$(INCDIR)/

install_library:
	install -D -m 0755 $(LIBRARY) $(DESTDIR)$(LIBDIR)/$(LIBRARY)

install: install_headers install_library

# install:
# 	install -m 755 -p font2openvg /usr/bin/
# 	install -m 755 -p libshapes.so /usr/lib/libshapes.so.1.0.0
# 	strip --strip-unneeded /usr/lib/libshapes.so.1.0.0
# 	ln -f -s /usr/lib/libshapes.so.1.0.0 /usr/lib/libshapes.so
# 	ln -f -s /usr/lib/libshapes.so.1.0.0 /usr/lib/libshapes.so.1
# 	ln -f -s /usr/lib/libshapes.so.1.0.0 /usr/lib/libshapes.so.1.0
# 	install -m 644 -p shapes.h /usr/include/
# 	install -m 644 -p fontinfo.h /usr/include/
# 
# uninstall:
# 	rm -f /usr/bin/font2openvg
# 	rm -f /usr/lib/libshapes.so.1.0.0 /usr/lib/libshapes.so.1.0 /usr/lib/libshapes.so.1 /usr/lib/libshapes.so
# 	rm -f /usr/include/shapes.h /usr/include/fontinfo.h
