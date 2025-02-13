#include "UnitOfWork.h"

#include "repositories/CrosswordsRepository.h"
#include "repositories/CrosswordsResponseRepository.h"
#include "utils/ResourceUtils.h"

#include <QtSql/qsqldatabase.h>
#include <QtSql/qsqlerror.h>
#include <QtSql/qsqlquery.h>

struct UnitOfWorkPrivate {
    explicit UnitOfWorkPrivate() noexcept;
    ~UnitOfWorkPrivate() noexcept;

    std::unique_ptr<QSqlDatabase> database;
    std::unique_ptr<CrosswordsRepository> crosswordsRepository;
    std::unique_ptr<CrosswordsResponseRepository> crosswordsResponseRepository;
};

UnitOfWorkPrivate::UnitOfWorkPrivate() noexcept
    : database(std::make_unique<QSqlDatabase>(QSqlDatabase::addDatabase("QSQLITE")))
    , crosswordsRepository(std::make_unique<CrosswordsRepository>(*database))
    , crosswordsResponseRepository(std::make_unique<CrosswordsResponseRepository>(*database))
{
    database->setDatabaseName("crosswords.db");
}

UnitOfWorkPrivate::~UnitOfWorkPrivate() noexcept
{
    if (database->isOpen()) {
        database->close();
    }
}

UnitOfWork::UnitOfWork() noexcept
    : d_ptr(std::make_unique<UnitOfWorkPrivate>())
{
}

UnitOfWork::~UnitOfWork() noexcept = default;

UnitOfWork& UnitOfWork::instance() noexcept
{
    static UnitOfWork instance;
    return instance;
}

bool execQuery(QSqlQuery& query, const QString& sql) noexcept
{
    auto sqlStatements = sql.split("-- ;", Qt::SkipEmptyParts); // Split by comment
    for (const auto& statement : sqlStatements) {
        auto trimmed = statement.trimmed();
        if (trimmed.isEmpty()) {
            continue;
        }

        if (!query.exec(trimmed)) {
            qCritical() << "Failed to execute script:" << query.lastError().text();
            return false;
        }
    }

    return true;
}

bool UnitOfWork::initialize() noexcept
{
    if (d_ptr->database->isOpen()) {
        return true;
    }

    if (!d_ptr->database->open()) {
        qCritical() << "Failed to open database:" << d_ptr->database->lastError().text();
        return false;
    }

    QString sql = ResourceUtils::readResource(":/resources/sql/schema.sql");
    if (sql.isNull()) {
        qCritical() << "Failed to load resource schema.sql";
        return false;
    }

    QSqlQuery query { *d_ptr->database };

    bool success = execQuery(query, sql);
    if (!success) {
        return false;
    }

    sql = ResourceUtils::readResource(":/resources/sql/crosswords.sql");
    if (sql.isNull()) {
        qCritical() << "Failed to load resource crosswords.sql";
        return false;
    }
    success = execQuery(query, sql);

    return success;
}

void UnitOfWork::beginTransaction() noexcept
{
    d_ptr->database->transaction();
}

void UnitOfWork::commitTransaction() noexcept
{
    d_ptr->database->commit();
}

void UnitOfWork::rollbackTransaction() noexcept
{
    d_ptr->database->rollback();
}

CrosswordsRepository& UnitOfWork::getCrosswordsRepository() noexcept
{
    return *d_ptr->crosswordsRepository;
}

CrosswordsResponseRepository& UnitOfWork::getCrosswordsResponseRepository() noexcept
{
    return *d_ptr->crosswordsResponseRepository;
}
