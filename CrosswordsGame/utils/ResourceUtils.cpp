#include "ResourceUtils.h"

#include <QDebug>
#include <QFile>
#include <QResource>
#include <QString>

QString ResourceUtils::readResource(const QString& name) noexcept
{
    QResource resource { name };
    QFile file { resource.absoluteFilePath() };
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qCritical() << "Failed to open resource" << name;
        return nullptr;
    }

    QTextStream stream { &file };
    return stream.readAll();
}
