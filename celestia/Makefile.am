ACLOCAL_AMFLAGS = -I macros

pkgdatadir = @datadir@/@PACKAGE@


noinst_DATA = \
	coding-standards.html \
	devguide.txt 

pkgdata_DATA = \
	celestia.cfg \
	controls.txt \
	COPYING \
	$(wildcard *.cel)

EXTRA_DIST = \
	$(pkgdata_DATA) \
	$(noinst_DATA) \
	splash.png \
	po/extract_resource_strings.pl \
	po/translate_resources.pl \
	TRANSLATORS

splashdir = $(pkgdatadir)/splash
splash_DATA = splash.png

SUBDIRS = src data extras extras-standard textures models shaders fonts po po2 locale scripts

# Non-automake directories
NONAUTO = admin macosx windows


$(top_srcdir)/subdirs:
	cd $(top_srcdir) && $(MAKE) -f admin/Makefile.common subdirs

# This is just silly
#$(top_srcdir)/acinclude.m4: $(top_srcdir)/admin/acinclude.m4.in $(top_srcdir)/admin/libtool.m4.in
#	@cd $(top_srcdir) && cat admin/acinclude.m4.in admin/libtool.m4.in > acinclude.m4

MAINTAINERCLEANFILES = subdirs configure.in acinclude.m4

package-messages:
	$(MAKE) -f admin/Makefile.common package-messages
	$(MAKE) -C po merge

dist-hook:
	( \
	  cd $(srcdir) && \
	  ( \
	    for dir in $(NONAUTO) ; do \
	      find $$dir -depth -print | egrep -v '(~$$)|(/CVS)|(/\.svn)|(/\.#)|(/\.deps)' \
	      | cpio -pdum $(distdir) 2>/dev/null ; \
	    done \
	  ) \
	)

	cd $(top_distdir) && perl admin/am_edit -padmin
	cd $(top_distdir) && $(MAKE) -f admin/Makefile.common subdirs



