#pragma once

#include "ICrosswordsRepository.h"

class QSqlDatabase;

class CrosswordsRepository : public ICrosswordsRepository {
public:
    explicit CrosswordsRepository(QSqlDatabase& db) noexcept;
    ~CrosswordsRepository() noexcept override;

    QList<Crosswords*> getAllCrosswords(QObject* parent = nullptr) noexcept override;

private:
    QSqlDatabase& m_db;
};
