/****************************************************************************
** Generated QML type registration code
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <QtQml/qqml.h>
#include <QtQml/qqmlmoduleregistration.h>

#if __has_include(<Crosswords.h>)
#  include <Crosswords.h>
#endif
#if __has_include(<CrosswordsModel.h>)
#  include <CrosswordsModel.h>
#endif
#if __has_include(<CrosswordsResponse.h>)
#  include <CrosswordsResponse.h>
#endif


#if !defined(QT_STATIC)
#define Q_QMLTYPE_EXPORT Q_DECL_EXPORT
#else
#define Q_QMLTYPE_EXPORT
#endif
Q_QMLTYPE_EXPORT void qml_register_types_CrosswordsGame()
{
    QT_WARNING_PUSH QT_WARNING_DISABLE_DEPRECATED
    qmlRegisterTypesAndRevisions<Crosswords>("CrosswordsGame", 1);
    qmlRegisterTypesAndRevisions<CrosswordsModel>("CrosswordsGame", 1);
    qmlRegisterTypesAndRevisions<CrosswordsResponse>("CrosswordsGame", 1);
    QT_WARNING_POP
    qmlRegisterModule("CrosswordsGame", 1, 0);
}

static const QQmlModuleRegistration crosswordsGameRegistration("CrosswordsGame", qml_register_types_CrosswordsGame);
