#pragma once

#include <memory>

class QSqlDatabase;
class CrosswordsRepository;
class CrosswordsResponseRepository;

class UnitOfWorkPrivate;
class UnitOfWork {
    explicit UnitOfWork() noexcept;
    UnitOfWork(const UnitOfWork&) = delete;
    UnitOfWork& operator=(const UnitOfWork&) = delete;

public:
    ~UnitOfWork() noexcept;

    static UnitOfWork& instance() noexcept;

    bool initialize() noexcept;
    void beginTransaction() noexcept;
    void commitTransaction() noexcept;
    void rollbackTransaction() noexcept;

    CrosswordsRepository& getCrosswordsRepository() noexcept;
    CrosswordsResponseRepository& getCrosswordsResponseRepository() noexcept;

private:
    std::unique_ptr<UnitOfWorkPrivate> d_ptr;
};
