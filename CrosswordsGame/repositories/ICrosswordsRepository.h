#pragma once

#include <QList>

class UnitOfWork;
class Crosswords;

/**
 * @brief The ICrosswordsRepository class
 * Interface for CrosswordsRepository
 */
class ICrosswordsRepository {
public:
    /**
     * @brief ~ICrosswordsRepository - virtual destructor
     */
    virtual ~ICrosswordsRepository() noexcept = default;

    /**
     * @brief getAllCrosswords - get all crosswords
     * @param parent - parent QObject to destroy the object
     * @return - list of crosswords
     */
    virtual QList<Crosswords*> getAllCrosswords(QObject* parent = nullptr) noexcept = 0;
};
