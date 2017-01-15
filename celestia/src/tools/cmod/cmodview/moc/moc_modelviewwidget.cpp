/****************************************************************************
** Meta object code from reading C++ file 'modelviewwidget.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.6)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../modelviewwidget.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'modelviewwidget.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.6. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_ModelViewWidget[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       8,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: signature, parameters, type, tag, flags
      17,   16,   16,   16, 0x05,
      36,   16,   16,   16, 0x05,

 // slots: signature, parameters, type, tag, flags
      59,   53,   16,   16, 0x0a,
      91,   86,   16,   16, 0x0a,
     123,  117,   16,   16, 0x0a,
     158,  151,   16,   16, 0x0a,
     176,  151,   16,   16, 0x0a,
     198,  151,   16,   16, 0x0a,

       0        // eod
};

static const char qt_meta_stringdata_ModelViewWidget[] = {
    "ModelViewWidget\0\0selectionChanged()\0"
    "contextCreated()\0color\0"
    "setBackgroundColor(QColor)\0path\0"
    "setRenderPath(RenderPath)\0style\0"
    "setRenderStyle(RenderStyle)\0enable\0"
    "setLighting(bool)\0setAmbientLight(bool)\0"
    "setShadows(bool)\0"
};

void ModelViewWidget::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        ModelViewWidget *_t = static_cast<ModelViewWidget *>(_o);
        switch (_id) {
        case 0: _t->selectionChanged(); break;
        case 1: _t->contextCreated(); break;
        case 2: _t->setBackgroundColor((*reinterpret_cast< const QColor(*)>(_a[1]))); break;
        case 3: _t->setRenderPath((*reinterpret_cast< RenderPath(*)>(_a[1]))); break;
        case 4: _t->setRenderStyle((*reinterpret_cast< RenderStyle(*)>(_a[1]))); break;
        case 5: _t->setLighting((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 6: _t->setAmbientLight((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 7: _t->setShadows((*reinterpret_cast< bool(*)>(_a[1]))); break;
        default: ;
        }
    }
}

const QMetaObjectExtraData ModelViewWidget::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject ModelViewWidget::staticMetaObject = {
    { &QGLWidget::staticMetaObject, qt_meta_stringdata_ModelViewWidget,
      qt_meta_data_ModelViewWidget, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &ModelViewWidget::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *ModelViewWidget::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *ModelViewWidget::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_ModelViewWidget))
        return static_cast<void*>(const_cast< ModelViewWidget*>(this));
    return QGLWidget::qt_metacast(_clname);
}

int ModelViewWidget::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QGLWidget::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 8)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 8;
    }
    return _id;
}

// SIGNAL 0
void ModelViewWidget::selectionChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}

// SIGNAL 1
void ModelViewWidget::contextCreated()
{
    QMetaObject::activate(this, &staticMetaObject, 1, 0);
}
QT_END_MOC_NAMESPACE
