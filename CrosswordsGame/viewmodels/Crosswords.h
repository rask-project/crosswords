#pragma once

#include <QQmlEngine>

class Crosswords : public QObject {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString awake READ awake CONSTANT FINAL)
    Q_PROPERTY(QString label READ label CONSTANT FINAL)
    Q_PROPERTY(QVariantMap questions READ questions CONSTANT FINAL)
public:
    explicit Crosswords(QObject* parent = nullptr) noexcept;
    explicit Crosswords(const QString& awake, const QString& label, const QVariantMap& questions, QObject* parent = nullptr) noexcept;
    ~Crosswords() noexcept;

    QString awake() const;
    QString label() const;
    QVariantMap questions() const;

private:
    QString m_awake {};
    QString m_label {};
    QVariantMap m_questions {};
};

Q_DECLARE_METATYPE(Crosswords*)
