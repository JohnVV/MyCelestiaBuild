/****************************************************************************
** Meta object code from reading C++ file 'materialwidget.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.6)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../materialwidget.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'materialwidget.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.6. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_MaterialWidget[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
      13,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: signature, parameters, type, tag, flags
      16,   15,   15,   15, 0x05,
      48,   15,   15,   15, 0x05,

 // slots: signature, parameters, type, tag, flags
      79,   15,   15,   15, 0x0a,
      93,   15,   15,   15, 0x0a,
     108,   15,   15,   15, 0x0a,
     123,   15,   15,   15, 0x0a,
     141,   15,   15,   15, 0x0a,
     159,   15,   15,   15, 0x0a,
     177,   15,   15,   15, 0x0a,
     199,  193,   15,   15, 0x0a,
     218,  193,   15,   15, 0x0a,
     238,  193,   15,   15, 0x0a,
     258,   15,   15,   15, 0x0a,

       0        // eod
};

static const char qt_meta_stringdata_MaterialWidget[] = {
    "MaterialWidget\0\0materialChanged(cmod::Material)\0"
    "materialEdited(cmod::Material)\0"
    "editDiffuse()\0editSpecular()\0"
    "editEmissive()\0editBaseTexture()\0"
    "editSpecularMap()\0editEmissiveMap()\0"
    "editNormalMap()\0color\0setDiffuse(QColor)\0"
    "setSpecular(QColor)\0setEmissive(QColor)\0"
    "changeMaterialParameters()\0"
};

void MaterialWidget::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        MaterialWidget *_t = static_cast<MaterialWidget *>(_o);
        switch (_id) {
        case 0: _t->materialChanged((*reinterpret_cast< const cmod::Material(*)>(_a[1]))); break;
        case 1: _t->materialEdited((*reinterpret_cast< const cmod::Material(*)>(_a[1]))); break;
        case 2: _t->editDiffuse(); break;
        case 3: _t->editSpecular(); break;
        case 4: _t->editEmissive(); break;
        case 5: _t->editBaseTexture(); break;
        case 6: _t->editSpecularMap(); break;
        case 7: _t->editEmissiveMap(); break;
        case 8: _t->editNormalMap(); break;
        case 9: _t->setDiffuse((*reinterpret_cast< const QColor(*)>(_a[1]))); break;
        case 10: _t->setSpecular((*reinterpret_cast< const QColor(*)>(_a[1]))); break;
        case 11: _t->setEmissive((*reinterpret_cast< const QColor(*)>(_a[1]))); break;
        case 12: _t->changeMaterialParameters(); break;
        default: ;
        }
    }
}

const QMetaObjectExtraData MaterialWidget::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject MaterialWidget::staticMetaObject = {
    { &QWidget::staticMetaObject, qt_meta_stringdata_MaterialWidget,
      qt_meta_data_MaterialWidget, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &MaterialWidget::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *MaterialWidget::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *MaterialWidget::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_MaterialWidget))
        return static_cast<void*>(const_cast< MaterialWidget*>(this));
    return QWidget::qt_metacast(_clname);
}

int MaterialWidget::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QWidget::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 13)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 13;
    }
    return _id;
}

// SIGNAL 0
void MaterialWidget::materialChanged(const cmod::Material & _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void MaterialWidget::materialEdited(const cmod::Material & _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}
QT_END_MOC_NAMESPACE
