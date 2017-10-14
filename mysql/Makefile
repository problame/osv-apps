.PHONY: module

VERSION=5.6.21
BASEDIR := "${CURDIR}"
BUILDDIR="$(BASEDIR)/build"
ROOTDIR="$(BASEDIR)/install"
SRCDIR="$(BASEDIR)/mysql-$(VERSION)"
CFLAGS="-fPIC"
CXXFLAGS="-fPIC -fpermissive"

module: usr.manifest

usr.manifest: install
	printf "\
/etc/**: $(ROOTDIR)/etc/**\n\
/usr/share/**: $(ROOTDIR)/usr/share/**\n\
/usr/lib/**: $(ROOTDIR)/usr/lib/**\n\
/usr/data/**: $(ROOTDIR)/usr/data/**\n\
/usr/bin/mysqld: $(BUILDDIR)/sql/mysqld\n\
" > usr.manifest

.PHONY: install
install: build.depend
	rm -rf $(ROOTDIR)
	mkdir -p $(ROOTDIR)/etc # includes install dir
	$(MAKE) -C $(BUILDDIR) install DESTDIR=$(ROOTDIR)
	cp $(BASEDIR)/my.cnf $(ROOTDIR)/etc/
	-./configure_install.bash $(BASEDIR) $(ROOTDIR) 
	find $(ROOTDIR) -name '*.a' -delete


.PHONY: build
build: build.depend

build.depend: patch.depend
	mkdir -p $(BUILDDIR)
	cd $(BUILDDIR); \
	cmake \
		-DCMAKE_INSTALL_PREFIX:PATH=/usr \
		-DCMAKE_CXX_FLAGS='-fpermissive -fPIC' \
		-DCMAKE_C_FLAGS='-fPIC' \
		-DWITH_UNIT_TESTS=OFF \
		-DWITH_NDBCLUSTER=OFF \
		-DWITH_NDBCLUSTER_STORAGE_ENGINE=OFF \
		-DWITH_PROTOBUF=OFF \
		-DWITH_EMBEDDED_SERVER=OFF \
		-DWITH_EMBEDDED_SHARED_LIBRARY=OFF \
		-DWITH_MYSQLD_LDFLAGS="-pie" \
		$(SRCDIR)
	$(MAKE) -C $(BUILDDIR)
	touch build.depend
	
patch.depend: extract.depend osv.patch
	cd $(SRCDIR) && patch -p1 < ../osv.patch
	touch patch.depend

extract.depend: mysql-$(VERSION).tar.gz
	tar zxf mysql-$(VERSION).tar.gz
	touch extract.depend

mysql-$(VERSION).tar.gz: 
	# TODO https
	echo fetching from internet
	wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-$(VERSION).tar.gz

.PHONY: clean
clean:
	rm -rf build install usr.manifest *.depend

.PHONY: cleanall
cleanall: clean
	rm mysql-$(VERSION).tar.gz

