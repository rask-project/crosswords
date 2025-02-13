#include "Crosswords.h"

Crosswords::Crosswords(QObject* parent) noexcept
    : QObject(parent)
{
}

Crosswords::Crosswords(const QString& awake,
    const QString& label,
    const QVariantMap& questions,
    QObject* parent) noexcept
    : QObject(parent)
    , m_awake(awake)
    , m_label(label)
    , m_questions(questions)
{
}

Crosswords::~Crosswords() noexcept
{
    qDebug() << __PRETTY_FUNCTION__;
}

QString Crosswords::label() const
{
    return m_label;
}

QString Crosswords::awake() const
{
    return m_awake;
}

QVariantMap Crosswords::questions() const
{
    return m_questions;
}
