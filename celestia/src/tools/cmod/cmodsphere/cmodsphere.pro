TEMPLATE = app
TARGET = cmodsphere

DESTDIR = bin
OBJECTS_DIR = obj

CMODSPHERE_SOURCES = \
    cmodsphere.cpp
    
CELMATH_HEADERS = \
    ../../../celmath/vecmath.h

INCLUDEPATH += ../../..

SOURCES = \
    $$CMODSPHERE_SOURCES

HEADERS = \
    $$CELMATH_HEADERS


