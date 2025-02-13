#include "CrosswordsRepository.h"

#include "utils/ResourceUtils.h"
#include "viewmodels/Crosswords.h"

#include <QJsonDocument>
#include <QSqlError>
#include <QSqlQuery>

CrosswordsRepository::CrosswordsRepository(QSqlDatabase& db) noexcept
    : m_db(db)
{
}

CrosswordsRepository::~CrosswordsRepository() noexcept = default;

QList<Crosswords*> CrosswordsRepository::getAllCrosswords(QObject* parent) noexcept
{
    auto sql = ResourceUtils::readResource(":/resources/sql/select_all_crosswords.sql");
    if (sql.isNull()) {
        qCritical() << "Failed to load resource select_all_crosswords.sql";
        return {};
    }

    QSqlQuery query { m_db };
    if (!query.exec(sql)) {
        qCritical() << "Failed to execute query:" << query.lastError().text();
        return {};
    }

    QList<Crosswords*> list;
    while (query.next()) {
        QString awake = query.value("awake").toString();
        QString label = query.value("label").toString();
        QVariantMap questions = QJsonDocument::fromJson(query.value("questions").toByteArray()).toVariant().toMap();
        auto crosswords = std::make_unique<Crosswords>(awake, label, questions, parent);

        list.append(crosswords.release());
    }

    return list;
}
