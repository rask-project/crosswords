#include "CrosswordsResponseRepository.h"

#include "utils/ResourceUtils.h"

#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>

CrosswordsResponseRepository::CrosswordsResponseRepository(QSqlDatabase& db) noexcept
    : m_db(db)
{
}

CrosswordsResponseRepository::~CrosswordsResponseRepository() noexcept = default;

QList<QString> CrosswordsResponseRepository::getCrosswordsResponse(const QString& awake) const noexcept
{
    auto sql = ResourceUtils::readResource(":/resources/sql/select_crosswords_responses.sql");
    if (sql.isNull()) {
        qCritical() << "Failed to load resource select_all_crosswords.sql";
        return {};
    }

    QSqlQuery query { m_db };
    query.prepare(sql);
    query.addBindValue(awake);
    if (!query.exec()) {
        qCritical() << "Failed to execute query:" << query.lastError().text();
        return {};
    }

    QList<QString> list;
    list.resize(15 * 15, nullptr);

    while (query.next()) {
        int position = query.value("position").toInt();
        QString response = query.value("response").toString();
        list[position] = response;
    }

    return list;
}

bool CrosswordsResponseRepository::insertResponse(const QString& awake,
    int position,
    const QString& response) noexcept
{
    auto sql = ResourceUtils::readResource(":/resources/sql/insert_crosswords_response.sql");
    if (sql.isNull()) {
        qCritical() << "Failed to load resource insert_crosswords_response.sql";
        return false;
    }

    QSqlQuery query { m_db };
    query.prepare(sql);
    query.addBindValue(awake);
    query.addBindValue(position);
    query.addBindValue(response);

    if (!query.exec()) {
        qCritical() << "Failed to execute query:" << query.lastError().text();
        return false;
    }

    return true;
}

bool CrosswordsResponseRepository::deleteResponses(const QString& awake) noexcept
{
    auto sql = ResourceUtils::readResource(":/resources/sql/delete_crosswords_responses.sql");
    if (sql.isNull()) {
        qCritical() << "Failed to load resource delete_crosswords_responses.sql";
        return false;
    }

    QSqlQuery query { m_db };
    query.prepare(sql);
    query.addBindValue(awake);

    if (!query.exec()) {
        qCritical() << "Failed to execute query:" << query.lastError().text();
        return false;
    }

    return true;
}
