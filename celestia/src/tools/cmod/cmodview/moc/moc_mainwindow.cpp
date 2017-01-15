/****************************************************************************
** Meta object code from reading C++ file 'mainwindow.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.6)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../mainwindow.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'mainwindow.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.6. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_MainWindow[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
      16,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      12,   11,   11,   11, 0x0a,
      33,   24,   11,   11, 0x0a,
      52,   11,   11,   11, 0x0a,
      64,   11,   11,   11, 0x0a,
      91,   78,   11,   11, 0x0a,
     110,   11,   11,   11, 0x0a,
     131,  124,   11,   11, 0x0a,
     156,  124,   11,   11, 0x0a,
     180,   11,   11,   11, 0x0a,
     198,   11,   11,   11, 0x0a,
     217,   11,   11,   11, 0x0a,
     236,   11,   11,   11, 0x0a,
     250,   11,   11,   11, 0x0a,
     288,   11,   11,   11, 0x0a,
     310,   11,   11,   11, 0x0a,
     332,   11,   11,   11, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_MainWindow[] = {
    "MainWindow\0\0openModel()\0fileName\0"
    "openModel(QString)\0saveModel()\0"
    "saveModelAs()\0saveFileName\0"
    "saveModel(QString)\0revertModel()\0"
    "action\0setRenderStyle(QAction*)\0"
    "setRenderPath(QAction*)\0generateNormals()\0"
    "generateTangents()\0uniquifyVertices()\0"
    "mergeMeshes()\0changeCurrentMaterial(cmod::Material)\0"
    "updateSelectionInfo()\0editBackgroundColor()\0"
    "initializeGL()\0"
};

void MainWindow::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        MainWindow *_t = static_cast<MainWindow *>(_o);
        switch (_id) {
        case 0: _t->openModel(); break;
        case 1: _t->openModel((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 2: _t->saveModel(); break;
        case 3: _t->saveModelAs(); break;
        case 4: _t->saveModel((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 5: _t->revertModel(); break;
        case 6: _t->setRenderStyle((*reinterpret_cast< QAction*(*)>(_a[1]))); break;
        case 7: _t->setRenderPath((*reinterpret_cast< QAction*(*)>(_a[1]))); break;
        case 8: _t->generateNormals(); break;
        case 9: _t->generateTangents(); break;
        case 10: _t->uniquifyVertices(); break;
        case 11: _t->mergeMeshes(); break;
        case 12: _t->changeCurrentMaterial((*reinterpret_cast< const cmod::Material(*)>(_a[1]))); break;
        case 13: _t->updateSelectionInfo(); break;
        case 14: _t->editBackgroundColor(); break;
        case 15: _t->initializeGL(); break;
        default: ;
        }
    }
}

const QMetaObjectExtraData MainWindow::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject MainWindow::staticMetaObject = {
    { &QMainWindow::staticMetaObject, qt_meta_stringdata_MainWindow,
      qt_meta_data_MainWindow, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &MainWindow::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *MainWindow::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *MainWindow::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_MainWindow))
        return static_cast<void*>(const_cast< MainWindow*>(this));
    return QMainWindow::qt_metacast(_clname);
}

int MainWindow::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QMainWindow::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 16)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 16;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
