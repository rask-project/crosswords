#pragma once

#include <QAbstractItemModel>
#include <QQmlEngine>

class Crosswords;

class CrosswordsModel : public QObject {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QList<Crosswords*> model READ model NOTIFY modelChanged FINAL)
public:
    explicit CrosswordsModel(QObject* parent = nullptr) noexcept;
    ~CrosswordsModel() noexcept;

    QList<Crosswords*> model() const;

signals:
    void modelChanged();

private:
    QList<Crosswords*> m_crosswords;
};
