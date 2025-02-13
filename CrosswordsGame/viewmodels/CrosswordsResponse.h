#pragma once

#include <QQmlEngine>
#include <QQmlParserStatus>

class CrosswordsResponsePrivate;

class CrosswordsResponse : public QObject, public QQmlParserStatus {
    Q_OBJECT
    QML_ELEMENT

    Q_INTERFACES(QQmlParserStatus)

    Q_PROPERTY(QString awake READ awake WRITE setAwake NOTIFY awakeChanged FINAL)
    Q_PROPERTY(QList<QString> responses READ responses NOTIFY responsesChanged FINAL)
public:
    explicit CrosswordsResponse(QObject* parent = nullptr) noexcept;
    ~CrosswordsResponse() noexcept;

    void classBegin() noexcept override;
    void componentComplete() noexcept override;

    QString awake() const noexcept;
    void setAwake(const QString& value) noexcept;

    QList<QString> responses() const;

public slots:
    void save(int position, const QString& response) noexcept;
    void reset() noexcept;

signals:
    void awakeChanged();
    void responsesChanged();

private:
    std::unique_ptr<CrosswordsResponsePrivate> d_ptr;
};
