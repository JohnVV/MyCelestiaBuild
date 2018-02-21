TEMPLATE = app
TARGET = cmodview

QT += opengl

DESTDIR = bin
OBJECTS_DIR = obj
MOC_DIR = moc
 LIBS += -lGLU
 
CMOD_SOURCES = \
    ../common/convert3ds.cpp \
    ../common/convertobj.cpp \
    ../common/cmodops.cpp \

CMOD_HEADERS = \
    ../common/convert3ds.h \
    ../common/convertobj.h \
    ../common/cmodops.h

CMODVIEW_HEADERS = \
    mainwindow.h \
    modelviewwidget.h \
    materialwidget.h \
    glshader.h \
    glframebuffer.h

CMODVIEW_SOURCES = \
    cmodview.cpp \
    glshader.cpp \
    glframebuffer.cpp \
    mainwindow.cpp \
    modelviewwidget.cpp \
    materialwidget.cpp \


#### CMOD Mesh library ####

MODEL_SOURCES = \
    ../../../celmodel/material.cpp \
    ../../../celmodel/mesh.cpp \
    ../../../celmodel/model.cpp \
    ../../../celmodel/modelfile.cpp

MODEL_HEADERS = \
    ../../../celmodel/material.h \
    ../../../celmodel/mesh.h \
    ../../../celmodel/model.h \
    ../../../celmodel/modelfile.h


#### 3DS Mesh library ####

TDS_SOURCES = \
    ../../../cel3ds/3dsmodel.cpp \
    ../../../cel3ds/3dsread.cpp

TDS_HEADERS = \
    ../../../cel3ds/3dschunk.h \
    ../../../cel3ds/3dsmodel.h \
    ../../../cel3ds/3dsread.h

    
#### Celestia utilities ####

CELUTIL_SOURCES = \
    ../../../celutil/debug.cpp

CELUTIL_HEADERS = \
    ../../../celutil/bytes.h \
    ../../../celutil/debug.h \

#### GL Extension Wrangler ####
DEFINES += GLEW_STATIC 

GLEW_SOURCES = \
    ../../../../thirdparty/glew/src/glew.c

GLEW_HEADERS = \
    ../../../../thirdparty/glew/include/GL/glew.h \
    ../../../../thirdparty/glew/include/GL/glxew.h \
    ../../../../thirdparty/glew/include/GL/wglew.h


SOURCES = \
    $$CMOD_SOURCES \
    $$MODEL_SOURCES \
    $$TDS_SOURCES \
    $$CELUTIL_SOURCES \
    $$GLEW_SOURCES \
    $$CMODVIEW_SOURCES

HEADERS = \
    $$CMOD_HEADERS \
    $$MODEL_HEADERS \
    $$TDS_HEADERS \
    $$CELUTIL_HEADERS \
    $$GLEW_HEADERS \
    $$CMODVIEW_HEADERS

INCLUDEPATH += ../common
INCLUDEPATH += ../../..
INCLUDEPATH += ../../../../thirdparty/Eigen
INCLUDEPATH += ../../../../thirdparty/glew/include

unix {
    !exists(config.h):system(touch config.h)
}




