#pragma once

#include <QList>
#include <QString>

class QSqlDatabase;

class CrosswordsResponseRepository {
public:
    explicit CrosswordsResponseRepository(QSqlDatabase& db) noexcept;
    ~CrosswordsResponseRepository() noexcept;

    QList<QString> getCrosswordsResponse(const QString& awake) const noexcept;

    bool insertResponse(const QString& awake, int position, const QString& response) noexcept;

    bool deleteResponses(const QString &awake) noexcept;

private:
    QSqlDatabase& m_db;
};
